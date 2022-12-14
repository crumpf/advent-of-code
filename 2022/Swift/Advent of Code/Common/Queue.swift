//
//  Queue.swift
//
//  Created by Christopher Rumpf on 12/14/22.
//

public struct Queue<Element> {
    
    private var q: [Element] = []
    public var isEmpty: Bool { q.isEmpty }
    
    public mutating func push(_ element: Element) {
        q.append(element)
    }
    
    public mutating func pop() -> Element {
        q.removeFirst()
    }
    
    public func peek() -> Element? {
        q.first
    }
    
}
