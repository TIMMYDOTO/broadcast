//
//  MainViewInput.swift
//  BroadcastOnline
//
//  Created by Artyom on 08.09.2022.
//

import Foundation
protocol MainViewInput: ViewInput {
    func setSports(model: [CSSportInfo], id: String?)
    func setSelectedSport(_ id: String, scrollToCenter: Bool)
    func setTournamentsPlaceholder(model: String)
    func setTournaments(model: [CSTournament])
    func setSelectedFilter(_ filter: CSFilter)
    func updateTournament(model: CSTournament, scroll: Bool)
    func updateTournaments(model: [CSTournament])
    func updateSports(model: [CSSportInfo])
    func hideFilterSkeleton()
    func hideGameFilterSkeleton()
    var tournamentsCollection: CyberSportTournamentsCollection! { get  }
    func setSelectedStakes(model: [String : Set<String>], reload: Bool)
    func setInAppStories(id: String, tags: [String])
    func updateInAppStories(_ model: (id: String, tags: [String])?)
}
