//
//  CSStakesCollection.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 29.03.2022.
//

import UIKit

final class CSStakesCollection: UICollectionView, CSStakeCellDelegate {

    
    
    var willSelectMore: (() -> Void)?
    var willSelectStake: ((CSStake) -> Void)?
    var willUnselectStake: ((CSStake) -> Void)?
    var didScroll: ((CGFloat) -> Void)?
    
    private var cellHeight: CGFloat = 40
    
    private var model: [CellType] = []
    var selectedStakes = Set<String>()
    var betStop = false
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        
        super.init(frame: .zero, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(
        _ stakes: [CSStake],
        total: Int32,
        betStop: Bool,
        cellHeight: CGFloat,
        stakesOffset: CGFloat
    ) {
        self.betStop = betStop
        self.model = formatStakes(stakes, total: total)
//        self.cellHeight = cellHeight
        self.setContentOffset(CGPoint(x: stakesOffset, y: 0), animated: false)
        reloadData()
    }
    
    func clear() {
        self.model = []
        isScrollEnabled = false
        isScrollEnabled = true
        reloadData()
    }
    
    func highlight(_ olds: [CSStake]) {
        for cell in visibleCells.compactMap({ ($0 as? NewCSStakesCell) }) {
            let new = cell.model
            if let old = olds.first(where: { $0.id == new.id }) {
                if old.factor > new.factor {
                    cell.highlight(.red)
                } else if old.factor < new.factor {
                    cell.highlight(.green)
                }
            }
        }
    }
    
    func updateSelectedStakes(_ model: Set<String>) {
        selectedStakes = model
        visibleCells.forEach { cell in
            if let stakeCell = cell as? CSStakeCell {
                stakeCell.stakeSelected = selectedStakes.contains(stakeCell.model.id)
            }
        }
    }
    
    func selectStake(_ id: String) {
        selectedStakes.insert(id)
        if let cell = visibleCells
            .first(where: { ($0 as? CSStakeCell)?.model.id == id }) as? CSStakeCell
        {
            cell.stakeSelected = true
        }
    }
    
    func unselectStake(_ id: String) {
        selectedStakes.remove(id)
        if let cell = visibleCells
            .first(where: { ($0 as? CSStakeCell)?.model.id == id }) as? CSStakeCell
        {
            cell.stakeSelected = false
        }
    }
    
    func allowDelegates() {
        dataSource = self
        delegate = self
        
    }
}

extension CSStakesCollection: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch model[indexPath.item] {
        case let .stake(item):
            let cell = collectionView.dequeueReusableCell(for: indexPath) as NewCSStakesCell

            cell.configure(item)
            
            cell.delegate = self
            return cell
        case let .longStake(item):
            let cell = collectionView.dequeueReusableCell(for: indexPath) as NewCSStakesCell
            cell.configure(item)
//            cell.configure(item, selected: selectedStakes.contains(item.id), betStop: betStop)
            cell.delegate = self
            return cell
        case let .more(value):
            let cell = collectionView.dequeueReusableCell(for: indexPath) as CSMoreStakesCell
            cell.configure(value)
            cell.delegate = self
            return cell
        case let .placeholder(title):
            let cell = collectionView.dequeueReusableCell(for: indexPath) as NewCSStakesCell
            print("title", title)
//            cell.placeholder(title)
            return cell
        }
    }
    
    func tapStake(_ model: CSStake) {
        willSelectStake?(model)
    }
}

extension CSStakesCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        if model.count == 1 {
            return CGSize(width: collectionView.frame.size.width, height: cellHeight)
        }
        
        if model.count == 2 {
      
            return CGSize(width: (collectionView.frame.size.width - 8) * 0.5, height: cellHeight)
        }
        
        let item = model[indexPath.item]
        let size: CGSize
        switch item {
        case .stake:
            size = CGSize(width: collectionView.frame.size.width * 0.317, height: cellHeight)
        case .longStake:
            size = CGSize(width: 97, height: cellHeight)
        case .more:
            let width: CGFloat = model.count < 2 ? collectionView.frame.size.width : collectionView.frame.size.width * 0.317
            size = CGSize(width: width, height: cellHeight)
        case .placeholder:
            size = CGSize(width: collectionView.frame.size.width * 0.317, height: cellHeight)
        }
        return size
    }
}

extension CSStakesCollection: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(scrollView.contentOffset.x)
    }
  
  
}

private extension CSStakesCollection {
    func setup() {
        alwaysBounceHorizontal = true
        showsHorizontalScrollIndicator = false
        
//        register(type: CSStakeCell.self)
        register(type: CSMoreStakesCell.self)
        register(type: NewCSStakesCell.self)
    }
    
    func formatStakes(_ model: [CSStake], total: Int32) -> [CellType] {
        var cells: [CellType] = model.map { $0.stakeTypeView == "view_1" ? .stake($0) : .longStake($0) }
        
        let moreStakes = Int(total)
        if moreStakes > 0 {
            cells.append(.more(moreStakes))
        }
        if cells.isEmpty {
            cells = [.placeholder("П1"), .placeholder("Х"), .placeholder("П2")]
        }
        return cells
    }
    
    func updateStakes(old: [Stake], new: [Stake]) -> [Stake] {
        var updated = new
        for index in 0...updated.count - 1 {
            let newItem = updated[index]
            if let oldItem = old.first(where: { newItem.id == $0.id }) {
                if oldItem.factor == newItem.factor {
                    updated[index].stakeColor = nil
                } else if oldItem.factor < newItem.factor {
                    updated[index].stakeColor = .green
                } else if oldItem.factor > newItem.factor {
                    updated[index].stakeColor = .red
                }
            } else { updated[index].stakeColor = nil }
        }
        return updated
    }
}

private extension CSStakesCollection {
    enum CellType: Equatable {
        case placeholder(String)
        case longStake(CSStake)
        case stake(CSStake)
        case more(Int)
        
        static func ==(lhs: CellType, rhs: CellType) -> Bool {
            switch lhs {
            case let .longStake(left):
                if case let .longStake(right) = rhs {
                    return left.id == right.id
                } else { return false }
            case let .stake(left):
                if case let .stake(right) = rhs {
                    return left.id == right.id
                } else { return false }
            case let .more(left):
                if case let .more(right) = rhs {
                    return left == right
                } else { return false }
            case let .placeholder(left):
                if case let .placeholder(right) = rhs {
                    return left == right
                } else { return false }
            }
        }
    }
}
