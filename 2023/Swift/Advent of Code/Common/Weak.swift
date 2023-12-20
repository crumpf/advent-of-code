//
//  Weak.swift
//  Advent of Code
//
//  Created by Chris Rumpf on 12/20/23.
//

import Foundation

struct Weak<T: AnyObject> {
   private(set) weak var value: T?

   init(value: T) {
      self.value = value
   }
}
