//
//  Queue.swift
//
//  Created by Christopher Rumpf on 12/14/22.
//

struct Queue<Element> {
    
    private var q: [Element] = []
    var isEmpty: Bool { q.isEmpty }
    var count: Int { q.count }
    
    mutating func push(_ element: Element) {
        q.append(element)
    }
    
    mutating func pop() -> Element {
        q.removeFirst()
    }
    
    func peek() -> Element? {
        q.first
    }
    
}
