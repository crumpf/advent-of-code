//
//  Containers.swift
//  AoC2019 Day 15
//
//  Created by Chris Rumpf on 1/1/20.
//  Copyright © 2020 Chris Rumpf. All rights reserved.
//

import Foundation

protocol StackInterface {
    associatedtype ItemType

    var isEmpty: Bool { get }
    var count: Int { get }

    mutating func push(_ item: ItemType)
    mutating func pop() -> ItemType?
    func peek() -> ItemType?
    func clear()
}

/**
A container of objects inserted and removed according to LIFO principle.
*/
class Stack<T>: StackInterface {
    typealias ItemType = T

    private var container: [T] = []

    var isEmpty: Bool {
        container.isEmpty
    }

    var count: Int {
        container.count
    }

    func push(_ item: T) {
        container.append(item)
    }

    func pop() -> T? {
        container.popLast()
    }

    func peek() -> T? {
        container.last
    }

    func clear() {
        container.removeAll()
    }
}

protocol QueueInterface {
    associatedtype ItemType

    var isEmpty: Bool { get }
    var count: Int { get }

    mutating func enqueue(_ item: ItemType)
    mutating func dequeue() -> ItemType?
    func peek() -> ItemType?
    func clear()
}

/**
 A container of objects inserted and removed according to FIFO principle.
 */
class Queue<T>: QueueInterface {
    typealias ItemType = T

    private var container: [T] = []

    var isEmpty: Bool {
        container.isEmpty
    }

    var count: Int {
        container.count
    }

    func enqueue(_ item: T) {
        container.append(item)
    }

    func dequeue() -> T? {
        guard !container.isEmpty else { return nil }
        return container.removeFirst()
    }

    func peek() -> T? {
        container.first
    }

    func clear() {
        container.removeAll()
    }
}
