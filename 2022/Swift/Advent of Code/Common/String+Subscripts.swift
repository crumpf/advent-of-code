//
//  String+Subscripts.swift
//  AdventUnitTests
//
//  Created by Christopher Rumpf on 12/18/20.
//

import Foundation

extension String {
    /**
     Subscript to get the Character at an offset.
     
     # Example #
     ```
     let s = "Swift"
     let c = s[1] // "w"
     ```
     */
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
    
    /**
     Subscript to get the Substring for a range.
     
     # Example #
     ```
     let s = "Swift"
     let substr = s[1..<3] // "wi"
     ```
     */
    subscript(range: Range<Int>) -> Substring {
        self[index(startIndex, offsetBy: range.lowerBound)..<index(startIndex, offsetBy: range.upperBound)]
    }
    
    /**
     Subscript to get the SubSequence for a closed range.
     
     # Example #
     ```
     let s = "Swift"
     let subseq = s[1...3] // "wif"
     ```
     */
    subscript(range: ClosedRange<Int>) -> SubSequence {
        self[index(startIndex, offsetBy: range.lowerBound)...index(startIndex, offsetBy: range.upperBound)]
    }
    
    /**
     Subscript to get the Substring for a partial range up to an upper bound.
     
     # Example #
     ```
     let s = "Swift"
     let substr = s[..<3] // Swi
     ```
     */
    subscript(range: PartialRangeUpTo<Int>) -> Substring {
        self[..<index(startIndex, offsetBy: range.upperBound)]
    }
    
    /**
     Subscript to get the Substring for a partial range through an upper bound.
     
     # Example #
     ```
     let s = "Swift"
     let substr = s[...3] // "Swif
     ```
     */
    subscript(range: PartialRangeThrough<Int>) -> Substring {
        self[...index(startIndex, offsetBy: range.upperBound)]
    }
    
    /**
     Subscript to get the Substring for a partial range from a lower bound.
     
     # Example #
     ```
     let s = "Swift"
     let substr = s[2...] // "ift"
     ```
     */
    subscript(range: PartialRangeFrom<Int>) -> Substring {
        self[index(startIndex, offsetBy: range.lowerBound)...]
    }
    
}
