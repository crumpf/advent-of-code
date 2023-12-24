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

    func iteratePath(body: (Int, PathNode<Vertex>, inout Bool) -> Void) {
        var i = 0
        var it: PathNode<Vertex>? = self
        var stop = false
        while it != nil && !stop {
            body(i, it!, &stop)
            it = it?.predecessor
            i += 1
        }
    }
}

struct BreadthFirstSearch<Graph: Pathfinding> {
    static func findPath(from start: Graph.Vertex, to destination: Graph.Vertex, in graph: Graph) -> PathNode<Graph.Vertex>? {
        findPath(from: start, isDestination: { $0 == destination }, in: graph)
    }

    static func findPath(from start: Graph.Vertex, isDestination: (Graph.Vertex) -> Bool, in graph: Graph) -> PathNode<Graph.Vertex>? {
        var frontier = Queue<PathNode<Graph.Vertex>>()
        frontier.enqueue(PathNode(vertex: start))
        var explored: Set<Graph.Vertex> = [start]
        while let currentNode = frontier.dequeue() {
            if isDestination(currentNode.vertex) {
                return currentNode
            }
            for successor in graph.neighbors(for: currentNode.vertex) where !explored.contains(successor) {
                explored.insert(successor)
                frontier.enqueue(PathNode(vertex: successor, predecessor: currentNode))
            }
        }
        return nil
    }
}

struct DepthFirstSearch<Graph: Pathfinding> {
    static func findPath(from start: Graph.Vertex, to destination: Graph.Vertex, in graph: Graph) -> PathNode<Graph.Vertex>? {
        findPath(from: start, isDestination: { $0 == destination }, in: graph)
    }

    static func findPath(from start: Graph.Vertex, isDestination: (Graph.Vertex) -> Bool, in graph: Graph) -> PathNode<Graph.Vertex>? {
        var frontier = Stack<PathNode<Graph.Vertex>>()
        frontier.push(PathNode(vertex: start))
        var explored: Set<Graph.Vertex> = [start]
        while let currentNode = frontier.pop() {
            if isDestination(currentNode.vertex) {
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
