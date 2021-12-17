//
//  Day16.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/6/21.
//

import Foundation

class Day16: Day {
  
  func part1() -> String {
    var message = makeBinaryMessage()
    let pkt = message.readPacket()
    
    return "\(totalVersion(packet: pkt!))"
  }
  
  func part2() -> String {
    return ""
  }
  
  func totalVersion(packet: Packet) -> Int {
    var version = 0
    switch packet {
    case .literal(let header, _):
      version += header.version
    case .op(let header, let subPkts):
      version += header.version
      for p in subPkts {
        version += totalVersion(packet: p)
      }
    }
    return version
  }
  
  func makeBinaryMessage() -> BinaryMessage {
    guard let hex = input.lines().first else {
      return BinaryMessage(message: "")
    }
    return BinaryMessage(message: hex.compactMap(binaryString(fromHex:)).joined())
  }
  
  private func binaryString(fromHex hex: Character) -> String? {
    guard hex.isHexDigit,
          let num = Int(String(hex), radix: 16)
    else {
      return nil
    }
    let binary = String(num, radix: 2)
    if binary.count < 4 {
      return String(repeating: "0", count: 4 - binary.count) + binary
    }
    return binary
  }
  
  struct BinaryMessage {
    let message: String
    var offset = 0
    
    mutating func read(_ length: Int) -> String {
      let range = offset..<(offset+length)
      guard let max = range.max(), max < message.count else {
        return ""
      }
      offset += length
      return String(message[range])
    }
    
    mutating func readPacket() -> Packet? {
      guard let version = Int(read(3), radix: 2),
            let typeID = Int(read(3), radix: 2)
      else {
        return nil
      }
      
      let header = Packet.Header(version: version, typeID: typeID)
      
      switch header.typeID {
      case 4: // literal value
        var literal = ""
        var isLastGroup = false
        repeat {
          isLastGroup = read(1) == "0"
          literal.append(read(4))
        } while !isLastGroup
        guard let literalValue = Int(literal, radix: 2) else {
          return nil
        }
        return Packet.literal(header, literalValue)
        
      default: // operator
        let lengthTypeID = read(1)
        let lengthFieldCount = lengthTypeID == "0" ? 15 : 11
        guard let length = Int(read(lengthFieldCount), radix: 2) else {
          return nil
        }
        var subPkts: [Packet] = []
        if lengthTypeID == "0" {
          var subMsg = BinaryMessage(message: read(length))
          while let subPkt = subMsg.readPacket() {
            subPkts.append(subPkt)
          }
        } else {
          for _ in 1...length {
            if let subPkt = readPacket() {
              subPkts.append(subPkt)
            }
          }
        }
        return Packet.op(header, subPkts)
      }
    }
  }
  
  enum Packet {
    case literal(Header, Int)
    case op(Header, [Packet])
    
    struct Header {
      let version: Int
      let typeID: Int
    }
    
    func header() -> Header {
      switch self {
      case .literal(let header, _):
        return header
      case .op(let header, _):
        return header
      }
    }
  }

}
