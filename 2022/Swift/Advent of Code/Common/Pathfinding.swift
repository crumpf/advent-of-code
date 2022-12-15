//
//  Pathfinding.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/14/22.
//

protocol Pathfinding {
    associatedtype Vertex: Hashable
    
    func neighbors(for vertex: Vertex) -> [Vertex]
}

class PathNode<Vertex: Hashable> {
    let vertex: Vertex
    let predecessor: PathNode?

    init(vertex: Vertex, predecessor: PathNode? = nil) {
        self.vertex = vertex
        self.predecessor = predecessor
    }
}

struct BreadthFirstSearch<Graph: Pathfinding> {
    static func findPath(from start: Graph.Vertex, to destination: Graph.Vertex, in graph: Graph) -> PathNode<Graph.Vertex>? {
        var frontier = Queue<PathNode<Graph.Vertex>>()
        frontier.push(PathNode(vertex: start))
        var explored: Set<Graph.Vertex> = [start]
        while !frontier.isEmpty {
            let currentNode = frontier.pop()
            if currentNode.vertex == destination {
                return currentNode
            }
            for successor in graph.neighbors(for: currentNode.vertex) where !explored.contains(successor) {
                explored.insert(successor)
                frontier.push(PathNode(vertex: successor, predecessor: currentNode))
            }
        }
        return nil
    }
}
