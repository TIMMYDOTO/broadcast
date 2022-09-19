//
//  Extensions.swift
//  BetBoom
//
//  Created by Шкёпу Артём Вячеславович on 25.06.2020.
//  Copyright © 2020 BetBoom. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftTheme

extension Data {
    func getStringFromData() -> String{
        return String(decoding: self, as: UTF8.self)
    }
}

extension String {
    func applyPatternOnNumbers(pattern:String = "+# (###) ### ## ##", replacmentCharacter:Character = "#") -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            
            pureNumber.insert(patternCharacter, at: stringIndex)
            
        }
        return pureNumber
    }
    
    func applyPatternOnSnilsNumbers(pattern:String = "###-###-### ##", replacmentCharacter:Character = "#") -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            
            pureNumber.insert(patternCharacter, at: stringIndex)
            
        }
        return pureNumber
    }
    
    
    var htmlToAttributedString: NSMutableAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    
    var isCyrillic: Bool {
        let upper = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"
        let lower = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя"
        for c in self.map({String($0)}) where !upper.contains(c) && !lower.contains(c) {
            return false
        }
        return true
    }
    var isLatin: Bool {
        let upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let lower = "abcdefghijklmnopqrstuvwxyz"
        for c in self.map({String($0)}) where !upper.contains(c) && !lower.contains(c) {
            return false
        }
        return true
    }
    var isInt: Bool {
        let ints = "0987654321"
        for c in self.map({String($0)}) where !ints.contains(c) {
            return false
        }
        return true
    }
    
    
    func currencyInputFormatting(_ symbol: String) -> String {

        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = symbol
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0

        var amountWithPrefix = self

        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))

        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }

        return formatter.string(from: number)!
    }
    
}

extension UIButton {
    
    func enableButton() {
        self.theme_backgroundColor = ThemeColor.buttonDefault
        self.theme_setTitleColor(ThemeColor.buttonDefaultTitle, forState: .normal)
        let color = UIColor(hex: "#0D0D0D")!.withAlphaComponent(0.5)
        self.theme_setTitleColor(ThemeColorPicker(colors: color, color), forState: .highlighted)
        self.isUserInteractionEnabled = true
    }
    
    func disableButton() {
        self.theme_backgroundColor = ThemeColor.buttonDisable
        self.theme_setTitleColor(ThemeColor.buttonDisableTitle, forState: .normal)
        self.isUserInteractionEnabled = false
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    var asImage: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}

extension UIImage {
    convenience init?(base64: String) {
        let str = base64.replacingOccurrences(of: "data:image/png;base64", with: "")
        
        guard let decodedData =  Data(base64Encoded: str, options: .ignoreUnknownCharacters) else {
            return nil
        }
        self.init(data: decodedData)
    }
    
    func image(byDrawingImage image: UIImage, inRect rect: CGRect) -> UIImage! {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    public enum DataUnits: String {
        case byte, kilobyte, megabyte, gigabyte
    }
    
    func getSizeIn(_ type: DataUnits) -> Double {
        
        guard let data = self.pngData() else {
            return 0.0
        }
        var size: Double = 0.0
        
        switch type {
        case .byte:
            size = Double(data.count)
        case .kilobyte:
            size = Double(data.count) / 1024
        case .megabyte:
            size = Double(data.count) / 1024 / 1024
        case .gigabyte:
            size = Double(data.count) / 1024 / 1024 / 1024
        }
        return size //String(format: "%.2f", size)
    }
}

extension Bundle {
    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }
        fatalError("Could not load view with type " + String(describing: type))
    }
}

extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}

extension String {
    func getDateFromString(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let date = dateFormatter.date(from: self)
        return date
    }
}

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        let systemLocale: Locale
        
        if let preferredIdentifier = Locale.preferredLanguages.first {
            systemLocale = Locale(identifier: preferredIdentifier)
        } else {
            systemLocale = Locale.current
        }
        dateformat.locale = systemLocale
        return dateformat.string(from: self)
    }
    
    func getLocaleFormattedDate(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: self)
    }
    
    func getDateFromString(string: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: string)
        return date
    }
    
    func reduceToMonthDayYear() -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: "\(month)/\(day)/\(year)") ?? Date()
    }
    
    func convertToLocalTime(fromTimeZone timeZoneAbbreviation: String) -> Date? {
        if let timeZone = TimeZone(abbreviation: timeZoneAbbreviation) {
            let targetOffset = TimeInterval(timeZone.secondsFromGMT(for: self))
            let localOffeset = TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT(for: self))

            return self.addingTimeInterval(targetOffset - localOffeset)
        }

        return nil
    }
    
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }()
    
}


extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}



extension CLLocationCoordinate2D {
    //distance in meters, as explained in CLLoactionDistance definition
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination = CLLocation(latitude:from.latitude, longitude:from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}

extension UILabel {
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        
        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
    
   
} 

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


extension UICollectionView {
    func reloadData(completion:@escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
            { _ in completion() }}
}

extension UITableView {
    func reloadData(completion:@escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
            { _ in completion() }}
    



    
}

extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues

    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

extension UIView {

    func applyGradient(isVertical: Bool, colorArray: [UIColor]) {
        layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
         
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        if isVertical {
            //top to bottom
            gradientLayer.locations = [0.0, 1.0]
        } else {
            //left to right
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        backgroundColor = .clear
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }

}

extension Int32 {
     func bonusesString() -> String {
         var bonusesString: String!
        if "1".contains("\(self % 10)")      {bonusesString = "фрибет"}
         if "234".contains("\(self % 10)")    {bonusesString = "фрибета" }
         if "567890".contains("\(self % 10)") {bonusesString = "фрибетов"}
         if 11...14 ~= self % 100             {bonusesString = "фрибетов"}
    return "\(self) " + bonusesString
    }
}

extension Double {
    var stringWithoutZeroFraction: String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        return String(formatter.string(from: number) ?? "")
    }
    
    var stringWithoutZeroFractionWithDot: String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        return String(formatter.string(from: number) ?? "")
    }
   
}

extension UITableView {

    func scrollToBottom(isAnimated:Bool = true){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
            }
        }
    }

    func scrollToTop(isAnimated:Bool = true) {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: isAnimated)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
