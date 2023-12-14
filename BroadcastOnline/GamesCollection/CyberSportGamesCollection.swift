//
//  CyberSportGamesCollection.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 22.03.2022.
//

import UIKit
import SkeletonView

class CyberSportGamesCollection: UICollectionView {

    var willSelect: ((_ game: CSSportInfo) -> Void)?
    
    var model: [CSSportInfo] = []
    
    var selectedId: String = ""
    var currentIndexes: Set<Int>?
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 8

        super.init(frame: .zero, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setLoading() {
        
        showSkeleton(usingColor: #colorLiteral(red: 0.2274509804, green: 0.2705882353, blue: 0.368627451, alpha: 0.5), transition: .crossDissolve(0.25))

    }
    
    func allowDelegates() {
        dataSource = self
        delegate = self
    }
    
    func set(_ model: [CSSportInfo], with selected: String?) {
        self.model = model.sorted(by: { $0.order < $1.order })
        
        if let id = selected { selectedId = id }
        if sk.isSkeletonActive { return }
        self.reloadData {}
        /*
        UIView.animate(withDuration: 0) {
            self.indexPathsForVisibleItems.forEach {
                (self.cellForItem(at: $0) as? CyberSportGameCell)?.testHide()
            }
        } completion: { _ in
            self.reloadData {
                if let id = selected {
                    self.select(id, scrollToCenter: true)
                }
            }
        }
            */
    }
    
    func update(_ model: [CSSportInfo]) {
        self.model = model.sorted(by: { $0.order < $1.order })
        
        reloadData()
    }
    
    func select(_ id: String, scrollToCenter: Bool = false) {
        guard let index = model.firstIndex(where: { $0.id == id }) else { return }
        
        selectedId = id
        indexPathsForVisibleItems.forEach {
            (cellForItem(at: $0) as? CyberSportGameCell)?.configure(model[$0.item], selected: model[$0.item].id == selectedId)
        }
        
        let indexPath = IndexPath(item: index, section: 0)
        if scrollToCenter {
            if indexPathsForVisibleItems.contains(where: { $0 == indexPath }) { return }
            scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else if let cellFrame = cellForItem(at: indexPath)?.frame {

            if contentOffset.x + 4 > cellFrame.origin.x {
                scrollToItem(at: indexPath, at: .left, animated: true)
            } else if (contentOffset.x + frame.width) - 4 < (cellFrame.origin.x + cellFrame.width) {
                scrollToItem(at: indexPath, at: .right, animated: true)
            }
        }
    }
}

extension CyberSportGamesCollection: SkeletonCollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as CyberSportGameCell
        
        let item = model[indexPath.item]
        cell.configure(item, selected: item.id == selectedId)
        
        return cell
    }
    
    // MARK: - SkeletonCollectionViewDataSource
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CyberSportGameSkeletonCell"
    }
    
    
}

extension CyberSportGamesCollection: UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if model[indexPath.item].id == selectedId { return }
        
        willSelect?(model[indexPath.item])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if indexPathsForVisibleItems.count < 1 {
            return
        }
        
        guard
            let old = currentIndexes
        else {
            currentIndexes = Set(indexPathsForVisibleItems.map { $0.item })
            return
        }
         
        let new = Set(indexPathsForVisibleItems.map { $0.item })
        
        if !new.getDifference(with: old).toInsert.isEmpty {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            currentIndexes = new
        }
    }
}

extension CyberSportGamesCollection: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if sk.isSkeletonActive {
            return CGSize(width: 80, height: 72)
        } else {
            let width: CGFloat = model[indexPath.item].abbreviation.width(withConstrainedHeight: 10, font: UIFont.systemFont(ofSize: 12))
         
            return CGSize(width: max(width + 16, 60), height: 72)
        }
    }
}

private extension CyberSportGamesCollection {
    func setup() {
        setupCollectionView()
    }
    
    func setupCollectionView() {
        contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        alwaysBounceHorizontal = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    
        register(type: CyberSportGameSkeletonCell.self)
        
        register(type: CyberSportGameCell.self)
    }
}





