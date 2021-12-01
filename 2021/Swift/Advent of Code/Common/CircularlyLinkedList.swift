//
//  LinkedList.swift
//  Day 23
//
//  Created by Christopher Rumpf on 12/23/20.
//

import Foundation

// MARK: CircularLinkedList

struct CircularlyLinkedList<Element> where Element: Hashable {
  private(set) var head: Node<Element>?
  private var lookup: [Element: Node<Element>] = [:] // use a map to avoid scanning the list when inserting by an element instead of index offset
  
  var isEmpty: Bool { lookup.isEmpty }
  var count: Int { lookup.count }
  
  mutating func removeAll() {
    head?.previous?.next = nil
    head = nil
    lookup.removeAll()
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
    let node = Node(element: element)
    insert(node, at: index)
  }
  
  /// Inserts an array of elements at the specified index (offset from head).
  mutating func insert(_ elements: [Element], at index: Int) {
    elements.reversed().forEach { element in
      insert(element, at: index)
    }
  }
  
  mutating func insert(_ element: Element, after index: Int) {
    let node = Node(element: element)
    insert(node, after: index)
  }
  
  mutating func insert(_ elements: [Element], after index: Int) {
    elements.reversed().forEach { element in
      insert(element, after: index)
    }
  }
  
  mutating func insert(_ element: Element, afterElement: Element) {
    guard let currentNode = lookup[afterElement] else { return }
    let node = Node(element: element, previous: currentNode, next: currentNode.next)
    currentNode.next?.previous = node
    currentNode.next = node
    lookup[node.element] = node
  }
  
  mutating func insert(_ elements: [Element], afterElement: Element) {
    elements.reversed().forEach { element in
      insert(element, afterElement: afterElement)
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
    lookup[currentNode.element] = nil
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
      node.next = currentNode
      node.previous = currentNode.previous
      currentNode.previous?.next = node
      currentNode.previous = node
      if index == 0 {
        head = node
      }
    }
    lookup[node.element] = node
  }
  
  private mutating func insert(_ node: Node<Element>, after index: Int) {
    if isEmpty {
      return
    } else {
      guard let currentNode = self.node(at: index) else { return }
      node.next = currentNode.next
      node.previous = currentNode
      currentNode.next?.previous = node
      currentNode.next = node
    }
    lookup[node.element] = node
  }
  
  private func node(at index: Int) -> Node<Element>? {
    guard !isEmpty, index < count else { return nil }
    guard index != 0 else { return head }
    
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
    
    init(element: Element, previous: Node<Element>? = nil, next: Node<Element>? = nil) {
      self.element = element
      self.previous = previous
      self.next = next
    }
  }
  
}
