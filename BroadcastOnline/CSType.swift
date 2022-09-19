//
//  CSType.swift
//  BetBoom
//
//  Created by Хван Александр Альбертович on 24.03.2022.
//

import Foundation
import SwiftTheme
import UIKit

enum CSType: String {
    case lol = "od:sport:1"
    case dota2 = "od:sport:2"
    case csgo = "od:sport:3"
    case fortnite = "od:sport:4"
    case pubg = "od:sport:5"
    case fifa = "od:sport:6"
    case nba2k = "od:sport:7"
    case overwatch = "od:sport:8"
    case hearthstone = "od:sport:9"
    case kingofglory = "od:sport:10"
    case starcraft2 = "od:sport:11"
    case rocketleague = "od:sport:12"
    case valorant = "od:sport:13"
    case starcraft = "od:sport:14"
    case callofduty = "od:sport:15"
    case rainbowsix = "od:sport:16"
    case nhl = "od:sport:17"
    case warcraft3 = "od:sport:18"
    case rushsoccer = "od:sport:19"
    case hallo = "od:sport:27"
    case wildrift = "od:sport:28"
    case arenaofvalor = "od:sport:29"
    case ageofempires = "od:sport:30"
    case mobilelegends = "od:sport:31"
}

struct CSInfoVM {
    var color: UIColor
    var icon: UIImage
    var type: CSType?
}

class CSTypeProvider {
    class func getInfoVM(id: String) -> CSInfoVM {
        let type = CSType(rawValue: id)
        let vm: CSInfoVM
        switch type {
        case .lol:
            vm = CSInfoVM(color: UIColor(hex: "#029DCE")!, icon: UIImage(named: "icCyberLol")!, type: type)
        case .dota2:
            vm = CSInfoVM(color: UIColor(hex: "#5A3A73")!, icon: UIImage(named: "icCyberDota2")!, type: type)
        case .csgo:
            vm = CSInfoVM(color: UIColor(hex: "#DE900A")!, icon: UIImage(named: "icCyberCsgo")!, type: type)
        case .fortnite:
            vm = CSInfoVM(color: UIColor(hex: "#AB539E")!, icon: UIImage(named: "icCyberFortnite")!, type: type)
        case .pubg:
            vm = CSInfoVM(color: UIColor(hex: "#F2A900")!, icon: UIImage(named: "icCyberPubg")!, type: type)
        case .fifa:
            vm = CSInfoVM(color: UIColor(hex: "#008F54")!, icon: UIImage(named: "icCyberFifa")!, type: type)
        case .nba2k:
            vm = CSInfoVM(color: UIColor(hex: "#1C3F83")!, icon: UIImage(named: "icCyberNba")!, type: type)
        case .overwatch:
            vm = CSInfoVM(color: UIColor(hex: "#FA9C1E")!, icon: UIImage(named: "icCyberOverwatch")!, type: type)
        case .hearthstone:
            vm = CSInfoVM(color: UIColor(hex: "#573FB7")!, icon: UIImage(named: "icCyberHearthstone")!, type: type)
        case .kingofglory:
            vm = CSInfoVM(color: UIColor(hex: "#635BC8")!, icon: UIImage(named: "icCyberKingOfGlory")!, type: type)
        case .starcraft2:
            vm = CSInfoVM(color: UIColor(hex: "#3F69A5")!, icon: UIImage(named: "icCyberStarcraft2")!, type: type)
        case .rocketleague:
            vm = CSInfoVM(color: UIColor(hex: "#433A73")!, icon: UIImage(named: "icCyberRocketLeague")!, type: type)
        case .valorant:
            vm = CSInfoVM(color: UIColor(hex: "#80232A")!, icon: UIImage(named: "icCyberValorant")!, type: type)
        case .starcraft:
            vm = CSInfoVM(color: UIColor(hex: "#3F69A5")!, icon: UIImage(named: "icCyberStarcraft")!, type: type)
        case .callofduty:
            vm = CSInfoVM(color: UIColor(hex: "#808889")!, icon: UIImage(named: "icCyberCallOfDuty")!, type: type)
        case .rainbowsix:
            vm = CSInfoVM(color: UIColor(hex: "#808889")!, icon: UIImage(named: "icCyberRainbow6")!, type: type)
        case .nhl:
            vm = CSInfoVM(color: UIColor(hex: "#4F7AB7")!, icon: UIImage(named: "icCyberNhl")!, type: type)
        case .warcraft3:
            vm = CSInfoVM(color: UIColor(hex: "#C85139")!, icon: UIImage(named: "icCyberWarcraft3")!, type: type)
        case .rushsoccer:
            vm = CSInfoVM(color: UIColor(hex: "#433A73")!, icon: UIImage(named: "icCyberRushSoccer")!, type: type)
        case .hallo:
            vm = CSInfoVM(color: UIColor(hex: "#6E8196")!, icon: UIImage(named: "icCyberHalo")!, type: type)
        case .wildrift:
            vm = CSInfoVM(color: UIColor(hex: "#238CB2")!, icon: UIImage(named: "icCyberWildRift")!, type: type)
        case .arenaofvalor:
            vm = CSInfoVM(color: UIColor(hex: "#8C89DD")!, icon: UIImage(named: "icCyberArenaOfValor")!, type: type)
        case .ageofempires:
            vm = CSInfoVM(color: UIColor(hex: "#96391B")!, icon: UIImage(named: "icCyberAgeOfEmpires")!, type: type)
        case .mobilelegends:
            vm = CSInfoVM(color: UIColor(hex: "#602C68")!, icon: UIImage(named: "icCyberMobileLegends")!, type: type)
        default:
            vm = CSInfoVM(color: UIColor(hex: "#808889")!, icon: UIImage(named: "cyberSport")!, type: nil)
        }
        return vm
    }
    

    /* old colors
    class func getInfoVM(id: String) -> CSInfoVM {
        let type = CSType(rawValue: id)
        let vm: CSInfoVM
        switch type {
        case .lol:
            vm = CSInfoVM(color: UIColor(hex: "#02B2CE")!, icon: R.image.icCyberLol()!, type: type)
        case .dota2:
            vm = CSInfoVM(color: UIColor(hex: "#F04C36")!, icon: R.image.icCyberDota2()!, type: type)
        case .csgo:
            vm = CSInfoVM(color: UIColor(hex: "#DE9A34")!, icon: R.image.icCyberCsgo()!, type: type)
        case .fortnite:
            vm = CSInfoVM(color: UIColor(hex: "#6083FF")!, icon: R.image.icCyberFortnite()!, type: type)
        case .pubg:
            vm = CSInfoVM(color: UIColor(hex: "#F2A900")!, icon: R.image.icCyberPubg()!, type: type)
        case .fifa:
            vm = CSInfoVM(color: UIColor(hex: "#007DD9")!, icon: R.image.icCyberFifa()!, type: type)
        case .nba2k:
            vm = CSInfoVM(color: UIColor(hex: "#D02A30")!, icon: R.image.icCyberNba()!, type: type)
        case .overwatch:
            vm = CSInfoVM(color: UIColor(hex: "#FA9C1E")!, icon: R.image.icCyberOverwatch()!, type: type)
        case .hearthstone:
            vm = CSInfoVM(color: UIColor(hex: "#5D69D5")!, icon: R.image.icCyberHearthstone()!, type: type)
        case .kingofglory:
            vm = CSInfoVM(color: UIColor(hex: "#E77F63")!, icon: R.image.icCyberKingOfGlory()!, type: type)
        case .starcraft2:
            vm = CSInfoVM(color: UIColor(hex: "#4798D4")!, icon: R.image.icCyberStarcraft2()!, type: type)
        case .rocketleague:
            vm = CSInfoVM(color: UIColor(hex: "#317CCD")!, icon: R.image.icCyberRocketLeague()!, type: type)
        case .valorant:
            vm = CSInfoVM(color: UIColor(hex: "#FF4655")!, icon: R.image.icCyberValorant()!, type: type)
        case .starcraft:
            vm = CSInfoVM(color: UIColor(hex: "#4798D4")!, icon: R.image.icCyberStarcraft()!, type: type)
        case .callofduty:
            vm = CSInfoVM(color: UIColor(hex: "#FF9B3E")!, icon: R.image.icCyberCallOfDuty()!, type: type)
        case .rainbowsix:
            vm = CSInfoVM(color: UIColor(hex: "#FF7E55")!, icon: R.image.icCyberRainbow6()!, type: type)
        case .nhl:
            vm = CSInfoVM(color: UIColor(hex: "#8BC5FF")!, icon: R.image.icCyberNhl()!, type: type)
        case .warcraft3:
            vm = CSInfoVM(color: UIColor(hex: "#DB7311")!, icon: R.image.icCyberWarcraft3()!, type: type)
        case .rushsoccer:
            vm = CSInfoVM(color: UIColor(hex: "#FFD400")!, icon: R.image.icCyberRushSoccer()!, type: type)
        default:
            vm = CSInfoVM(color: UIColor(hex: "#FFFFFF")!, icon: R.image.cyberSport()!, type: type)
        }
        return vm
    }
    */
}
