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
    let pkt = message.readPacket()!
    
    return "\(totalVersion(packet: pkt))"
  }
  
  func part2() -> String {
    var message = makeBinaryMessage()
    let pkt = message.readPacket()!
    
    return "\(pkt.expressionValue())"
  }
  
  func totalVersion(packet: Packet) -> Int {
    var total = 0
    total += packet.header.version
    for p in packet.subPackets {
      total += totalVersion(packet: p)
    }
    return total
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
      guard range.upperBound < message.count else {
        return ""
      }
      offset += length
      return String(message[range])
    }
    
    mutating func readPacket() -> Packet? {
      guard let version = Int(read(3), radix: 2),
            let typeID = Int(read(3), radix: 2),
            let type = Packet.ExpressionType(rawValue: typeID)
      else {
        return nil
      }
      
      let header = Packet.Header(version: version, type: type)
      
      switch header.type {
      case .literal:
        var literal = ""
        var isLastGroup = false
        repeat {
          isLastGroup = read(1) == "0"
          literal.append(read(4))
        } while !isLastGroup
        guard let literalValue = Int(literal, radix: 2) else {
          return nil
        }
        return Packet(header: header, literalValue: literalValue, subPackets: [])
        
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
        return Packet(header: header, literalValue: nil, subPackets: subPkts)
      }
    }
  }
  
  struct Packet {
    let header: Header
    let literalValue: Int?
    let subPackets: [Packet]
    
    func expressionValue() -> Int {
      var result = 0
      switch header.type {
      case .sum:
        result = subPackets.map { $0.expressionValue() }.reduce(0, +)
      case .product:
        result = subPackets.map { $0.expressionValue() }.reduce(1, *)
      case .minimum:
        if let min = subPackets.map({ $0.expressionValue() }).min() {
          result = min
        }
      case .maximum:
        if let max = subPackets.map({ $0.expressionValue() }).max() {
          result = max
        }
      case .literal:
        if let value = literalValue {
          result = value
        }
      case .greaterThan:
        result = subPackets[0].expressionValue() > subPackets[1].expressionValue() ? 1 : 0
      case .lessThan:
        result = subPackets[0].expressionValue() < subPackets[1].expressionValue() ? 1 : 0
      case .equalTo:
        result = subPackets[0].expressionValue() == subPackets[1].expressionValue() ? 1 : 0
      }
      return result
    }
    
    enum ExpressionType: Int {
      case sum = 0, product, minimum, maximum, literal, greaterThan, lessThan, equalTo
    }
    
    struct Header {
      let version: Int
      let type: ExpressionType
    }
  }

}
