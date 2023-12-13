//
//  CaretString.swift
//  BetBoom
//
//  Created by Занков Владимир Владимирович on 22.11.2021.
//

import Foundation

struct CaretString {
    
    public var string: String
    public var caretPosition: String.Index
    
    func filtered(with characterSet: CharacterSet) -> CaretString {
        var result = self
        let originalCaretPosition = result.caretPosition
        var digitsOnlyString = ""
        
        var i = result.string.startIndex
        
        while i < result.string.endIndex {
            let characterToAdd = result.string[i]
            if let scalar = characterToAdd.unicodeScalars.first,
               characterSet.contains(scalar) {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCaretPosition {
                result.caretPosition = result.string.index(before: result.caretPosition)
            }
            i = result.string.index(after: i)
        }
        result.string = digitsOnlyString
        return result
    }
    
    func formatted(with pattern: String, replacementCharacter: Character = "_") -> CaretString {
        var result = self
        result.string = result.string.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        
        let targetCount = pattern.filter { $0 == replacementCharacter }.count
        if result.string.count > targetCount {
            result.string.removeLast(result.string.count - targetCount)
        }
        
        var index = pattern.startIndex
        
        while index < pattern.endIndex {
            guard index < result.string.endIndex else { break }
            let patternCharacter = pattern[index]
            guard patternCharacter != replacementCharacter else {
                index = pattern.index(after: index)
                continue
            }
            
            result.string.insert(patternCharacter, at: index)
            if index < result.caretPosition && result.caretPosition < result.string.endIndex {
                result.caretPosition = result.string.index(after: result.caretPosition)
            }
            
            index = result.string.index(after: index)
        }
        
        while index < pattern.endIndex {
            let patternCharacter = pattern[index]
            result.string.insert(patternCharacter, at: index)
            index = result.string.index(after: index)
        }
        
        return result
    }
    
    mutating func insert(_ character: Character, at index: String.Index) {
        string.insert(character, at: index)
        if caretPosition > index {
            caretPosition = string.index(after: caretPosition)
        }
    }
    
    var caretOffset: Int {
        string.distance(from: string.startIndex, to: caretPosition)
    }
}
