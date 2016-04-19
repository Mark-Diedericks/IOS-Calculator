//
//  OperatorTokenSet.swift
//  DDMathParser
//
//  Created by Dave DeLong on 8/7/15.
//
//

import Foundation

internal struct OperatorTokenSet {
    private let characters: Set<Character>
    private let tokens: Set<String>
    
    init(tokens: Set<String>) {
        var characters = Set<Character>()
        var normalizedTokens = Set<String>()
        
        for token in tokens {
            let lower = token.lowercaseString
            
            normalizedTokens.insert(token)
            normalizedTokens.insert(lower)
            
            characters.unionInPlace(token.characters)
            characters.unionInPlace(lower.characters)
        }
        
        self.characters = characters
        self.tokens = normalizedTokens
    }
    
    func isOperatorCharacter(c: Character) -> Bool {
        if c.isAlphabetic { return false }
        return characters.contains(c)
    }
    
    func isOperatorToken(s: String) -> Bool {
        return tokens.contains(s)
    }
    
    func hasOperatorWithPrefix(s: String) -> Bool {
        // TODO: make this more efficient
        let matching = tokens.filter { $0.hasPrefix(s) }
        return !matching.isEmpty
    }
    
}
