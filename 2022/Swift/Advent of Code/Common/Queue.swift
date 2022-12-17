//
//  Queue.swift
//
//  Created by Christopher Rumpf on 12/14/22.
//

struct Queue<Element> {
    
    private var q: [Element] = []
    var isEmpty: Bool { q.isEmpty }
    var count: Int { q.count }
    
    // Add an element to the end of the queue.
    mutating func enqueue(_ element: Element) {
        q.append(element)
    }
    
    // Remove the first element from the queue and return it.
    mutating func dequeue() -> Element {
        q.removeFirst()
    }
    
    // Peek at the first queue element without removing it.
    func peek() -> Element? {
        q.first
    }
    
}
