//
//  Stack.swift
//  AdventUnitTests
//
//  Created by Christopher Rumpf on 12/16/22.
//

struct Stack<Element> {
    
    private var stack: [Element] = []
    var isEmpty: Bool { stack.isEmpty }
    var count: Int { stack.count }
    
    // Add an element to the top of the stack.
    mutating func push(_ element: Element) {
        stack.append(element)
    }
    
    // Remove an element from the top of the stack and return it.
    mutating func pop() -> Element {
        stack.removeLast()
    }
    
    // Peek at the topmost element without removing it.
    func peek() -> Element? {
        stack.last
    }
    
}
