//
//  Colors.swift
//  BetBoom
//
//  Created by Vitaliy Kozlov on 23/06/2020.
//  Copyright © 2020 BetBoom. All rights reserved.
//

import UIKit
import SwiftTheme

struct Colors {
    static let backgroundColor: UIColor = #colorLiteral(red: 0.05098039216, green: 0.05098039216, blue: 0.05098039216, alpha: 1)
    static let buttonTextColor: UIColor = #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1)
    static let elementBackgroundColor: UIColor = #colorLiteral(red: 0.09803921569, green: 0.1019607843, blue: 0.1019607843, alpha: 1)
    static let mainYellowColor: UIColor = #colorLiteral(red: 0.9725490196, green: 0.9098039216, blue: 0, alpha: 1)
    static let mainRedColor: UIColor = #colorLiteral(red: 1, green: 0, blue: 0.1450980392, alpha: 1)
    static let disableColor: UIColor = #colorLiteral(red: 0.4509803922, green: 0.4509803922, blue: 0.4509803922, alpha: 1)
    static let textColor =  #colorLiteral(red: 0.6901960784, green: 0.6901960784, blue: 0.6901960784, alpha: 1)
    static let blackGrayColor: UIColor = #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1)
    static let greenColor = #colorLiteral(red: 0.00542704761, green: 0.7129969001, blue: 0.4756041765, alpha: 1)
    static let borderColor = #colorLiteral(red: 0.2509803922, green: 0.2509803922, blue: 0.2509803922, alpha: 1)
    static let selectedElement = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 1)
    static let disableElementColor = #colorLiteral(red: 0.3294117647, green: 0.3294117647, blue: 0.3294117647, alpha: 1)
    static let betWinGreenColor =  #colorLiteral(red: 0, green: 0.7058823529, blue: 0.4705882353, alpha: 1)
   // MARK: Figma colors
    static let red = #colorLiteral(red: 1, green: 0.00171912217, blue: 0.1419937611, alpha: 1)
    static let yellow = #colorLiteral(red: 0.9716858268, green: 0.9108504653, blue: 0, alpha: 1)
    static let green = #colorLiteral(red: 0, green: 0.7056218386, blue: 0.4719268084, alpha: 1)
    static let blue = #colorLiteral(red: 0, green: 0.3949321508, blue: 0.8900768757, alpha: 1)
    static let white = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 1)
    static let superGrey = #colorLiteral(red: 0.7993550301, green: 0.7994901538, blue: 0.7993372083, alpha: 1)
    static let grey = #colorLiteral(red: 0.4519355893, green: 0.4520157576, blue: 0.4519249797, alpha: 1)
    static let deepGrey = #colorLiteral(red: 0.1285692155, green: 0.1285982728, blue: 0.1285654306, alpha: 1)
    static let blackGrey = #colorLiteral(red: 0.09274540097, green: 0.09276878089, blue: 0.09274233133, alpha: 1)
    static let richBlack = #colorLiteral(red: 0.07139129192, green: 0.07141128927, blue: 0.07138866931, alpha: 1)
    static let deepBlack = #colorLiteral(red: 0.04919179529, green: 0.04920829087, blue: 0.04918961972, alpha: 1)
    static let orange = #colorLiteral(red: 1, green: 0.7294117647, blue: 0.2, alpha: 1)
}

enum Color {
    
    static let electricYellowLightTheme = UIColor(red: 1, green: 0.729, blue: 0.2, alpha: 1)
    static let electricYellow = UIColor(red: 0.973, green: 0.91, blue: 0, alpha: 1)
    static let deepBlack = UIColor(red: 0.051, green: 0.051, blue: 0.051, alpha: 1)
    static let emeraldGreen = UIColor(red: 0, green: 0.706, blue: 0.471, alpha: 1)
    static let carmineRed = UIColor(red: 1, green: 0, blue: 0.145, alpha: 1)

    static let blue = UIColor(red: 0.38, green: 0.36, blue: 1, alpha: 1)

    static let blackInsurance = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 0.7)
    static let whiteInsurance = UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 0.7)

    /*
    static let textPrimaryNight = UIColor.white
    static let textPrimaryDay = deepBlack
    
    static let textSecondaryNight = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    static let textSecondaryDay = UIColor(red: 0.631, green: 0.639, blue: 0.671, alpha: 1)

    static let textAdditionalAll = UIColor(red: 0.451, green: 0.451, blue: 0.451, alpha: 1)
    */
}

enum ThemeColor {
    static let barStyle                 = ThemeBarStylePicker(styles: .black, .default)
    
    static let backgroundPrimary        = ThemeColorPicker(colors: "#0D0D0D", "#F6F7FB")
    static let backgroundSecondary      = ThemeColorPicker(colors: "#181818", "#FFFFFF")
    static let backgroundAdditional     = ThemeColorPicker(colors: "#262626", "#FFFFFF")
    static let backgroundBlackGray      = ThemeColorPicker(colors: "#212121", "#FFFFFF")

    static let expressContainerView     = ThemeColorPicker(colors: "#2E2E2E", "#FFFFFF")
    static let containerView            = ThemeColorPicker(colors: "#2E2E2E", "#4442B2")
    static let blueOne                  = ThemeColorPicker(colors: "#615EFF", "#615EFF")

    static let backgroundInsurance      = ThemeColorPicker(colors: "#0D0D0D", "#737373")
    

    
    static let textWhiteGray            = ThemeColorPicker(colors: "#FFFFFF", "#737373")
    static let textPrimary              = ThemeColorPicker(colors: "#FFFFFF", "#0D0D0D")
    static let textSecondary            = ThemeColorPicker(colors: "#CCCCCC", "#0D0D0D")
    static let textAdditional           = ThemeColorPicker(colors: "#737373", "#737373")
    static let textActions              = ThemeColorPicker(colors: "#F8E800", "#0D0D0D")
    
    static let buttonDefault            = ThemeColorPicker(colors: "#F8E800", "#F8E800")
    static let buttonDefaultTitle       = ThemeColorPicker(colors: "#0D0D0D", "#0D0D0D")
    static let seniaIcon          = ThemeColorPicker(colors: "#CCCCCC", "#A1A3AB")
    static let buttonDisable            = ThemeColorPicker(colors: "#737373", "#D2D5E0")
    static let buttonDisableTitle       = ThemeColorPicker(colors: "#CCCCCC", "#0D0D0D")
    static let buttonNav                 = ThemeColorPicker(colors: "#CCCCCC", "#CCCCCC")
    static let tableSeparator           = ThemeColorPicker(colors: "#262626", "#EDEEF2")
    static let navObjectsDetails        = ThemeColorPicker(colors: "#FFFFFF", "#FFFFFF")
    static let iconPrimary              = ThemeColorPicker(colors: "#CCCCCC", "#737373")
    static let iconSecondary            = ThemeColorPicker(colors: "#737373", "#A1A3AB")
    static let iconAdditional           = ThemeColorPicker(colors: "#FFFFFF", "#0D0D0D")
    static let topStakeIcon             = ThemeColorPicker(colors: "#FFFFFF", "#0D0D0D")
    static let topStakeIconUnselected           = ThemeColorPicker(colors: "#737373", "#A1A3AB")
    static let topFavoriteIcon           = ThemeColorPicker(colors: "#F8E800", "#FF0025")
    static let orangeIcon           = ThemeColorPicker(colors: "#FFBA33", "#FFBA33")
    // MARK: SportColors
    static let yellowRed          = ThemeColorPicker(colors: "#F8E800", "#FF0025")
    static let soccerIconColor          = ThemeColorPicker(colors: "#00B478", "#00B478")
    static let basketballIconColor      = ThemeColorPicker(colors: "#FF8B00", "#FF8B00")
    static let hockeyIconColor          = ThemeColorPicker(colors: "#2774F1", "#2774F1")
    static let roomSportsIconColor      = ThemeColorPicker(colors: "#FFBA33", "#FFBA33")
    static let winterSportsIconColor    = ThemeColorPicker(colors: "#73BCFC", "#73BCFC")
    static let waterSportsIconColor     = ThemeColorPicker(colors: "#1C9DE6", "#1C9DE6")
    static let cyberSportsIconColor     = ThemeColorPicker(colors: "#7B5BFF", "#7B5BFF")
    static let tableSportsIconColor     = ThemeColorPicker(colors: "#1D797F", "#1D797F")
    static let fightingSportsIconColor  = ThemeColorPicker(colors: "#E13232", "#E13232")
    static let otherSportsIconColor     = ThemeColorPicker(colors: "#1EB5AC", "#1EB5AC")
    
    static let yellowOrangeColor      = ThemeColorPicker(colors: "#F8E800", "#FFBA33")
    
    
    static let sportDetailsWhiteGreyColor       = ThemeColorPicker(colors: "#FFFFFF", "#EDEEF2")
    static let sportDetailsGreyBlackColor       = ThemeColorPicker(colors: "#0D0D0D", "#F6F7FB")
    static let sportDetailsBlackWhiteColor      = ThemeColorPicker(colors: "#0D0D0D", "#FFFFFF")
    static let sportDetailsSeparatorColor      = ThemeColorPicker(colors: "#292929", "#FFFFFF")
    static let sportDetailsGradientColor      = ThemeColorPicker(colors: "#181818", "#F6F7FB")
    static let sportDetailsScoresColors         = ThemeColorPicker(colors: "#FFFFFF", "#A1A3AB")
    static let sportDetailsContainerColors         = ThemeColorPicker(colors: "#191919", "#F6F7FB")
    static let expressSkeletonContentColors           = ThemeColorPicker(colors: "#2B2B2B", "#F6F7FB")
    static let sportDetailsArgumentColor            = ThemeColorPicker(colors: "#191919", "#D2D5E0")
    static let navBarTitle              = ThemeStringAttributesPicker(
                                            [
                                                .foregroundColor: UIColor(hex: "#FFFFFF")!,
                                                .font: R.font.gilroyBold(size: 16)!
                                            ],
                                            [
                                                .foregroundColor: UIColor(hex: "#0D0D0D")!,
                                                .font: R.font.gilroyBold(size: 16)!
                                            ]
                                        )
    
    
    static let navBarTitleDetails              = ThemeStringAttributesPicker(
                                            [
                                                .foregroundColor: UIColor(hex: "#FFFFFF")!,
                                                .font: R.font.gilroyBold(size: 16)!
                                            ],
                                            [
                                                .foregroundColor: UIColor(hex: "#FFFFFF")!,
                                                .font: R.font.gilroyBold(size: 16)!
                                            ]
                                        )
    
    static let navBarMainTitle          = ThemeStringAttributesPicker(
                                            [
                                                .foregroundColor: UIColor(hex: "#FFFFFF")!,
                                                .font: R.font.gilroyBold(size: 24)!
                                            ],
                                            [
                                                .foregroundColor: UIColor(hex: "#0D0D0D")!,
                                                .font: R.font.gilroyBold(size: 24)!
                                            ]
                                        )
    
    static let segmentControlDeselect   = ThemeStringAttributesPicker(
                                            [
                                                .foregroundColor: UIColor(hex: "#FFFFFF")!,
                                                .font: R.font.lato_BBRegular(size: 14)!
                                            ],
                                            [
                                                .foregroundColor: UIColor(hex: "#0D0D0D")!,
                                                .font: R.font.lato_BBRegular(size: 14)!
                                            ]
                                        )

 
  
}

