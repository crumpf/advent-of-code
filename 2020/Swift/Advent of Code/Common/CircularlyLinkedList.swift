//
//  LinkedList.swift
//  Day 23
//
//  Created by Christopher Rumpf on 12/23/20.
//

import Foundation

// MARK: CircularLinkedList

struct CircularlyLinkedList<Element> {
  private(set) var head: Node<Element>?
  
  var isEmpty: Bool { head == nil }
  
  /// Count of Nodes in the list: O(1)
  private(set) var count: Int = 0
  
  mutating func removeAll() {
    head?.previous?.next = nil
    head = nil
    count = 0
  }

  /// Moves the head by the specified distance.
  mutating func moveHead(by offset: Int) {
    guard offset > 0 else { return }
    (1...offset).forEach { _ in
      head = head?.next
    }
  }
  
  /// Returns the first index from head in which an element of the list satisfies the given predicate.
  func firstIndex(where predicate: (Element) -> Bool) -> Int? {
    guard count > 0 else { return nil }
    var node = head
    for index in (0..<count) {
      guard let element = node?.element else { return nil }
      if predicate(element) {
        return index
      }
      node = node?.next
    }
    return nil
  }
  
  /// Inserts a new element at the specified index (offset from head).
  mutating func insert(_ element: Element, at index: Int) {
    let node = Node<Element>(element: element)
    insert(node, at: index)
  }
  
  /// Inserts an array of elements at the specified index (offset from head).
  mutating func insert(_ elements: [Element], at index: Int) {
    elements.reversed().forEach { element in
      insert(element, at: index)
    }
  }
  
  mutating func insert(_ element: Element, after index: Int) {
    let node = Node<Element>(element: element)
    insert(node, after: index)
  }
  
  mutating func insert(_ elements: [Element], after index: Int) {
    elements.reversed().forEach { element in
      insert(element, after: index)
    }
  }
  
  func element(at index: Int) -> Element? {
    node(at: index)?.element
  }
  
  mutating func remove(at index: Int) -> Element? {
    guard let currentNode = self.node(at: index) else { return nil }
    if index == 0 {
      head = count > 1 ? currentNode.next : nil
    }
    currentNode.previous?.next = currentNode.next
    currentNode.next?.previous = currentNode.previous
    currentNode.previous = nil
    currentNode.next = nil
    count -= 1
    return currentNode.element
  }
  
  private mutating func insert(_ node: Node<Element>, at index: Int) {
    if isEmpty {
      guard index == 0 else { return }
      node.next = node
      node.previous = node
      head = node
    } else {
      guard let currentNode = self.node(at: index) else { return }
      currentNode.previous?.next = node
      node.previous = currentNode.previous
      node.next = currentNode
      currentNode.previous = node
      if index == 0 {
        head = node
      }
    }
    count += 1
  }
  
  private mutating func insert(_ node: Node<Element>, after index: Int) {
    if isEmpty {
      return
    } else {
      guard let currentNode = self.node(at: index) else { return }
      currentNode.next?.previous = node
      node.next = currentNode.next
      currentNode.next = node
      node.previous = currentNode
    }
    count += 1
  }
  
  private func node(at index: Int) -> Node<Element>? {
    guard !isEmpty, index < count else { return nil }
    
    var node = head
    for _ in (0..<index) {
      guard node != nil else { return nil }
      node = node?.next
    }
    return node
  }
}

extension CircularlyLinkedList where Element: Equatable {
  /// Returns the first index from head where the specified value appears in the list.
  /// Available when T conformas to Equatable
  func firstIndex(of element: Element) -> Int? {
    guard count > 0 else { return nil }
    var node = head
    for index in (0..<count) {
      guard node != nil else { return nil }
      if node?.element == element {
        return index
      }
      node = node?.next
    }
    return nil
  }
}

extension CircularlyLinkedList: CustomStringConvertible {
  var description: String {
    guard !isEmpty else { return "CircularLinkedList is empty" }
    var str = " "
    var node = head
    (1...count).forEach { _ in
      if let element = node?.element {
        str.append("\(String(describing: element)) ")
      }
      node = node?.next
    }
    str.removeLast()
    return str
  }
  
}

// MARK: Node
extension CircularlyLinkedList {
  
  class Node<Element> {
    private(set) var element: Element
    var next: Node<Element>?
    weak var previous: Node<Element>?
    
    init(element: Element) {
      self.element = element
    }
  }
  
}
