//
//  SignTypeCollectionView.swift
//  Cyber Live
//
//  Created by Шкёпу Артём Вячеславович on 01.12.2023.
//

import UIKit
import SkeletonView

class SignTypeCollectionView: UICollectionView {

    var willSelect: ((SignType) -> Void)?
    
    private let model: [SignType] = [
        .signUp,
        .signIn,
       

    ]
    private var selectedIndex: Int = 0
    
    init() {
        let layout = UICollectionViewFlowLayout()
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .horizontal
        
        super.init(frame: .zero, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSelected(_ filter: SignType, scrollToCenter: Bool = false) {
        guard
            let index = model.firstIndex(where: { $0 == filter }),
            selectedIndex != index
        else { return }
        
        let newIndexPath = IndexPath(item: index, section: 0)
        let oldIndexPath = IndexPath(item: selectedIndex, section: 0)
        
        (cellForItem(at: oldIndexPath) as? SignTypeCollectionCell)?.configure(model[selectedIndex], selected: false)
        (cellForItem(at: newIndexPath) as? SignTypeCollectionCell)?.configure(model[index], selected: true)
        
        selectedIndex = index
        
        let indexPath = IndexPath(item: index, section: 0)
        if scrollToCenter {
            scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        } else if let cellFrame = cellForItem(at: indexPath)?.frame {
            if contentOffset.x + 8 > cellFrame.origin.x {
                scrollToItem(at: indexPath, at: .left, animated: true)
            } else if (contentOffset.x + frame.width) - 8 < (cellFrame.origin.x + cellFrame.width) {
                scrollToItem(at: indexPath, at: .right, animated: true)
            }
        }
        
    }
    
    func setLoading() {
        showSkeleton(usingColor: .clear, transition: .crossDissolve(0.25))

    }
    
  
}

extension SignTypeCollectionView: SkeletonCollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as SignTypeCollectionCell
      
        cell.configure(model[indexPath.item], selected: indexPath.item == selectedIndex)
        
        return cell
    }
    
    // MARK: - SkeletonCollectionViewDataSource
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        let cell = skeletonView.dequeueReusableCell(for: indexPath) as CyberSportFilterSkeletonCell
        indexPath.row == 0 ? cell.addBackground() : cell.removeBackground()
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CyberSportFilterSkeletonCell"
    }
}
extension SignTypeCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (frame.size.width - 12) * 0.5, height: 36)
    }
    
}
extension SignTypeCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == selectedIndex { return }
        
        willSelect?(model[indexPath.item])
    }
}

private extension SignTypeCollectionView {
    func setup() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        
        contentInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        
        dataSource = self
        delegate = self
        
        
        layer.cornerRadius = 16
        register(type: SignTypeCollectionCell.self)
        register(type: CyberSportFilterSkeletonCell.self)
        backgroundColor = #colorLiteral(red: 0.1402209699, green: 0.1697322726, blue: 0.2372379601, alpha: 1)
    }
}

//extension SignTypeCollectionView {
//    enum SignType {
//        case signIn
//        case signUp
//
//    }
//}
