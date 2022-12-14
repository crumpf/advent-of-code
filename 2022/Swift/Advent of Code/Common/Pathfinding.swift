//
//  Pathfinding.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/14/22.
//

struct Pathfinding {
    
    class Node<Element> {
        let element: Element
        let predecessor: Node?

        init(element: Element, predecessor: Node? = nil) {
            self.element = element
            self.predecessor = predecessor
        }
    }
    
    static func breadthFirstSearch<Location: Hashable>(
        startingAt: Location,
        goalReached: (Location) -> Bool,
        successorsFor: (Location) -> [Location]
    ) -> Node<Location>? {
        
        var frontier = Queue<Node<Location>>()
        frontier.push(Node(element: startingAt))
        var explored: Set<Location> = [startingAt]
        while !frontier.isEmpty {
            let currentNode = frontier.pop()
            if goalReached(currentNode.element) {
                return currentNode
            }
            for child in successorsFor(currentNode.element) where !explored.contains(child) {
                explored.insert(child)
                frontier.push(Node(element: child, predecessor: currentNode))
            }
        }
        return nil
    }
    
}
