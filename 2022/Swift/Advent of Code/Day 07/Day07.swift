//
//  Day07.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/07/2022.
//

import Foundation

class Day07: Day {
    
    func part1() -> String {
        "\(sumOfAllDirectorySizes(havingMaxSize: 100_000))"
    }
    
    func part2() -> String {
        "\(sizeOfSmallestDirectoryToBeDeletedToRunUpdate(requiringSpace: 30_000_000))"
    }
    
    private func sumOfAllDirectorySizes(havingMaxSize max: Int) -> Int {
        filesystem(fromTerminalOutput: input)
            .allDirectoriesInHierarchy()
            .map { $0.totalSize() }
            .filter { $0 <= max }
            .reduce(0, +)
    }
    
    private func sizeOfSmallestDirectoryToBeDeletedToRunUpdate(requiringSpace requiredSpace: Int) -> Int {
        let totalSpace = 70_000_000
        let fs = filesystem(fromTerminalOutput: input)
        let usedSpace = fs.totalSize()
        let unusedSpace = totalSpace - usedSpace
        let neededSpace = requiredSpace - unusedSpace
        let qualifyingDirs = fs.allDirectoriesInHierarchy()
            .map { $0.totalSize() }
            .filter { $0 >= neededSpace }
            .sorted(by: <)
        return qualifyingDirs.first ?? -1
    }
    
    private func filesystem(fromTerminalOutput terminalOutput: String) -> Dir {
        let root = Dir(parent: nil, name: "/")
        var pwd = root
        let operations = terminalOutput.components(separatedBy: "$ ").map { $0.trimmingCharacters(in: .newlines) }
        for op in operations {
            if op.hasPrefix("cd") {
                let comps = op.components(separatedBy: .whitespaces)
                if comps.indices.contains(1) {
                    let dirName = comps[1]
                    switch dirName {
                    case "..":
                        if let parent = pwd.parent {
                            pwd = parent
                        }
                    case "/":
                        pwd = root
                    default:
                        if let dir = pwd.subdirs.first(where: { $0.name == dirName }) {
                            pwd = dir
                        }
                    }
                }
            } else if op.hasPrefix("ls") {
                for listItem in op.components(separatedBy: .newlines).dropFirst() {
                    let comps = listItem.components(separatedBy: .whitespaces)
                    if comps.count == 2 {
                        let name = comps[1]
                        switch comps[0] {
                        case "dir":
                            let dir = Dir(parent: pwd, name: name)
                            pwd.subdirs.append(dir)
                        case let size where Int(size) != nil:
                            let file = File(dir: pwd, name: name, size: Int(size)!)
                            pwd.files.append(file)
                        default:
                            break
                        }
                    }
                }
            }
        }
        return root
    }
    
}

class Dir {
    weak var parent: Dir?
    var name: String
    var subdirs: [Dir] = []
    var files: [File] = []
    
    init(parent: Dir?, name: String) {
        self.parent = parent
        self.name = name
    }
    
    func totalSize() -> Int {
        files.map { $0.size }.reduce(0, +) + subdirs.reduce(0) { $0 + $1.totalSize() }
    }
    
    func allDirectoriesInHierarchy() -> [Dir] {
        subdirs.reduce(into: [self]) { $0 += $1.allDirectoriesInHierarchy()}
    }
}

struct File {
    private(set) weak var dir: Dir?
    let name: String
    let size: Int
}
