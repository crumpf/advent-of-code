//
//  WeightedPathfinding.swift
//  AdventUnitTests
//
//  Created by Christopher Rumpf on 12/26/22.
//

import Foundation
import HeapModule

protocol WeightedPathfinding: Pathfinding {
    associatedtype Cost: Numeric & Comparable
    
    func cost(from: Vertex, to: Vertex) -> Cost
}

class WeightedPathNode<Vertex: Hashable, Cost: Numeric & Comparable>: PathNode<Vertex>, Comparable {
    var cost: Cost
    
    static func == (lhs: WeightedPathNode<Vertex, Cost>, rhs: WeightedPathNode<Vertex, Cost>) -> Bool {
        lhs.cost == rhs.cost
    }
    
    static func < (lhs: WeightedPathNode<Vertex, Cost>, rhs: WeightedPathNode<Vertex, Cost>) -> Bool {
        lhs.cost < rhs.cost
    }
    
    init(vertex: Vertex, predecessor: WeightedPathNode? = nil, cost: Cost) {
        self.cost = cost
        super.init(vertex: vertex, predecessor: predecessor)
    }
}

struct DijkstraSearch<Graph: WeightedPathfinding> {
    static func findPath(from start: Graph.Vertex, to destination: Graph.Vertex, in graph: Graph) -> WeightedPathNode<Graph.Vertex, Graph.Cost>? {
        findPath(from: start, isDestination: { $0 == destination }, in: graph)
    }
    
    static func findPath(from start: Graph.Vertex, isDestination: (Graph.Vertex) -> Bool, in graph: Graph) -> WeightedPathNode<Graph.Vertex, Graph.Cost>? {
        let startNode = WeightedPathNode(vertex: start, cost: graph.cost(from: start, to: start))
        var exploredMinimumCosts = [start: startNode.cost]
        var frontier = Heap<WeightedPathNode<Graph.Vertex, Graph.Cost>>()
        frontier.insert(startNode)
        while let currentNode = frontier.popMin() {
            if isDestination(currentNode.vertex) {
                return currentNode
            }
            guard let currentCost = exploredMinimumCosts[currentNode.vertex] else { return nil }
            for successor in graph.neighbors(for: currentNode.vertex) {
                let newCost = currentCost + graph.cost(from: currentNode.vertex, to: successor)
                if exploredMinimumCosts[successor] == nil || newCost < exploredMinimumCosts[successor]! {
                    exploredMinimumCosts[successor] = newCost
                    let node = WeightedPathNode(vertex: successor, predecessor: currentNode, cost: newCost)
                    frontier.insert(node)
                }
            }
        }
        return nil
    }
}
