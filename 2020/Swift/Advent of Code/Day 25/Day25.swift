//
//  Day25.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/11/20.
//

import Foundation

struct Device {
  let publicKey: Int
  let subjectNumber: Int
  private let secretLoopSize: Int
  
  init(publicKey: Int, subjectNumber: Int) {
    self.publicKey = publicKey
    self.subjectNumber = subjectNumber
    self.secretLoopSize = Device.loopSize(ofPublicKey: publicKey, withSubjectNumber: subjectNumber)
  }
  
  func encryptionKey(withPeerDevice peer: Device) -> Int {
    Device.transformSubjectNumber(peer.publicKey, loopSize: secretLoopSize)
  }
  
  static private func loopSize(ofPublicKey publicKey: Int, withSubjectNumber subjectNumber: Int) -> Int {
    var value = 1
    for loopSize in (1...) {
      value = value * subjectNumber
      value = value % 20201227
      if publicKey == value {
        return loopSize
      }
    }
    return -1
  }
  
  static func transformSubjectNumber(_ num: Int, loopSize: Int) -> Int {
    var value = 1
    (1...loopSize).forEach { i in
      value = value * num
      value = value % 20201227
    }
    return value
  }
}

class Day25: Day {
  
  let publicKeys: [Int]
  
  override init(input: String) {
    publicKeys = input.lines().compactMap { Int($0) }
    super.init(input: input)
  }
  
  func part1() -> String {
    let card = Device(publicKey: publicKeys[0], subjectNumber: 7)
    let door = Device(publicKey: publicKeys[1], subjectNumber: 7)
    
    let encryptionKey = card.encryptionKey(withPeerDevice: door)
    if encryptionKey != door.encryptionKey(withPeerDevice: card) {
      return "Device encryption keys did not match."
    }
    
    return String(encryptionKey)
  }
  
  func part2() -> String {
    "Not Implemented"
  }
  
}
