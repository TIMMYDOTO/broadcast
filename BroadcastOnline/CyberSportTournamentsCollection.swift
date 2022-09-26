//
//  CyberSportTournamentsCollection.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 29.03.2022.
//

import UIKit
import SkeletonView

final class CyberSportTournamentsCollection: UICollectionView {
    
    var willSelectTournament: ((_ model: CSTournament) -> Void)?
    var didSelectMatch: ((_ model: CSMatch) -> Void)?
    
    var willSelectStake: ((CSMatch, CSStake) -> Void)?
    var actionFavoriteEvent: ((_ item: (match: CSMatch, add: Bool)) -> Void)?
    var actionFavoriteTournament: ((_ item: (tournament: CSTournamentInfo, add: Bool)) -> Void)?
    
    var skeletonModel: [Int] = [4, 0, 0, 0] /// Section Array<countInSection>
    
    var model: [CSTournament] = []
    var selectedStakes = [String: Set<String>]() /// [matchId: Set<stakeIds>]
    var favoriteTournaments = Set<String>() /// Set<stakeIds>
    var favoriteEvents = Set<String>() /// Set<stakeIds>
    
    ///
    private var stakesOffsetHash = [String: CGFloat]() /// [matchId: offsetX]
    private var currentDeleting: String? /// matchId/tournamentId
    ///
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.sectionHeadersPinToVisibleBounds = true
        
        super.init(frame: .zero, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(_ model: [CSTournament]) {
        hideSkeleton()
        self.model = model
        if sk.isSkeletonActive { return }
        reloadData()
    }
    
    func clear() {
        hideSkeleton()
        self.model.removeAll()
        reloadData()
    }
    
    func update(_ model: [CSTournament]) {
        if currentDeleting != nil { return }
        
        let olds = self.model
        self.model = model
        reloadData {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.highlight(olds: olds)
            }
        }
    }
    
    func setLoading() {
        
        showAnimatedSkeleton(usingColor: #colorLiteral(red: 0.1843137255, green: 0.2117647059, blue: 0.2745098039, alpha: 1))
    }
    
    func updateTournament(_ tournament: CSTournament, scroll: Bool) {
        guard let indexToUpdate = model.firstIndex(where: { tournament.info.id == $0.info.id }) else { return }
        
        model[indexToUpdate] = tournament
        UIView.animate(withDuration: 0) {
            if scroll, let attributes = self.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: indexToUpdate)) {
                let offsetY = attributes.frame.origin.y //- contentInset.top
                self.setContentOffset(CGPoint(x: 0, y: offsetY - 105), animated: false)
            }
        } completion: { _ in
            if self.numberOfSections > indexToUpdate {
                UIView.animate(withDuration: 0.2) { self.reloadSections(IndexSet(integer: indexToUpdate)) }
            }
        }
    }
    
    func setSelectedStakes(_ model: [String: Set<String>], reload: Bool) {
        selectedStakes = model
        if reload { reloadData() }
    }
    
    func clearSelectedStakes() {
        selectedStakes.removeAll()
        reloadData()
    }
    
    func selectStake(_ id: String, matchId: String) {
        if selectedStakes[matchId] == nil {
            selectedStakes[matchId] = [id]
        } else { selectedStakes[matchId]?.insert(id) }
        
        if let cell = visibleCells
            .first(where: { ($0 as? CSMatchBaseCell)?.model.id == matchId })
        {
            (cell as! CSMatchBaseCell).stakesCollection.selectStake(id)
        }
    }
    
    func unselectStake(_ id: String, matchId: String) {
        selectedStakes[matchId]?.remove(id)
        
        if let cell = visibleCells
            .first(where: { ($0 as? CSMatchBaseCell)?.model.id == matchId  })
        {
            (cell as! CSMatchBaseCell).stakesCollection.unselectStake(id)
        }
    }
    
    func setFavoriteEvents(_ model: Set<String>) {
        favoriteEvents = model
        
        let cells: [CSMatchBaseCell] = visibleCells
            .compactMap({ $0 as? CSMatchBaseCell })
        model.forEach { id in
            if let cell = cells.first(where: { $0.model.id == id }) {
                cell.favoriteState(true)
            }
        }
    }
    
    

    
    
}

extension CyberSportTournamentsCollection: SkeletonCollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model[section].collapsed ? model[section].matches.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = model[indexPath.section].matches[indexPath.item]
        let cell = collectionView.dequeueReusableCell(for: indexPath) as CSDefaultMatchCell
        
    
        cell.stakesCollection.selectedStakes = selectedStakes[item.id] ?? []
        cell.configure(item, stakesOffset: stakesOffsetHash[item.id] ?? 0)
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let item = model[indexPath.section]
        let header = collectionView.dequeueReusableView(ofKind: kind, for: indexPath) as CSTournamentHeader
        
        header.configure(item.info, collapsed: item.collapsed)

        header.delegate = self
        
        return header
    }
    
    
    
    // MARK: - SkeletonCollectionViewDataSource
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CSMatchSkeletonCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier? {
        return "TournamentSkeletonCHeader"
    }
    
}

extension CyberSportTournamentsCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if model.isEmpty {
            return CGSize(width: UIScreen.main.bounds.width, height: 0)
        }else{
            return CGSize(width: UIScreen.main.bounds.width, height: 40)
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 136)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 6, right: 0)
    }
}

extension CyberSportTournamentsCollection: CSTournamentHeaderDelegate {
    func tapTournamentHeader(_ id: String) {
        guard let tournament = model.first(where: { $0.info.id == id }) else { return }
        
        willSelectTournament?(tournament)
    }
    
    func switchFavorite(_ tournamentId: String) {
        guard let tournament = model.first(where: { $0.info.id == tournamentId }) else { return }
        
        actionFavoriteTournament?((tournament: tournament.info, !favoriteTournaments.contains(tournamentId)))
    }
}
 
extension CyberSportTournamentsCollection: CSMatchCellDelegate {
    func willSelectMatch(_ match: CSMatch) {
        didSelectMatch?(match)
    }
    
    func switchFavorite(_ match: CSMatch) {
        actionFavoriteEvent?((match: match, add: !favoriteEvents.contains(match.id)))
    }
    
    func stakeSelected(match: CSMatch, stake: CSStake) {
        willSelectStake?(match, stake)
    }

    
    func saveStakesOffset(matchId: String, x: CGFloat) {
        stakesOffsetHash[matchId] = x
    }
    
    func setCurrentDeleting(_ id: String) {
        currentDeleting = id
    }
    
    func setDeletingIsAvailable() {
        currentDeleting = nil
    }
    
    func checkDeletingIsAvailable(_ id: String) -> Bool {
        return currentDeleting == nil || currentDeleting == id
    }
}

private extension CyberSportTournamentsCollection {
    func setup() {
        showsVerticalScrollIndicator = false
        alwaysBounceVertical = true
        
        dataSource = self
        delegate = self
        
        register(type: CSMatchSkeletonCell.self)
        register(type: CSDefaultMatchCell.self)

        register(type: TournamentSkeletonCHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        register(type: CSTournamentHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        
    }
    
    func highlight(olds: [CSTournament]) {
        for indexPath in indexPathsForVisibleItems {
            guard let newItem = self.model[safe: indexPath.section]?.matches[safe: indexPath.item] else { continue }
            if let oldItem: CSMatch = olds
                .first(where: { $0.info.id == newItem.tournamentId })?.matches
                .first(where: { $0.id == newItem.id })
            {
                if let cell = cellForItem(at: indexPath) as? CSMatchBaseCell {
                    cell.highlight(oldItem)
                }
            }
        }
    }
}
