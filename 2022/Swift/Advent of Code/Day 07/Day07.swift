//
//  Day07.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/07/2022.
//

import Foundation

class Day07: Day {
    func part1() -> String {
        let fs = filesystem(fromTerminalOutput: input)
        let result = fs.allDirs()
            .map { $0.totalSize() }
            .filter { $0 <= 100000 }
            .reduce(0, +)
        return "\(result)"
    }
    
    func part2() -> String {
        let totalSpace = 70000000
        let requriedSpace = 30000000
        let fs = filesystem(fromTerminalOutput: input)
        let usedSpace = fs.totalSize()
        let unusedSpace = totalSpace - usedSpace
        let neededSpace = requriedSpace - unusedSpace
        
        let qualifyingDirs = fs.allDirs()
            .map { $0.totalSize() }
            .filter { $0 >= neededSpace }
            .sorted(by: <)

        return "\(qualifyingDirs.first ?? -1)"
    }
    
    private func filesystem(fromTerminalOutput terminalOutput: String) -> Dir {
        let fs = Dir(parent: nil, name: "/")
        var pwd = fs
        let operations = terminalOutput.components(separatedBy: "$ ").map { $0.trimmingCharacters(in: .newlines) }
        for op in operations {
            if op.hasPrefix("cd") {
                let comps = op.components(separatedBy: .whitespaces)
                if comps.indices.contains(1) {
                    let dirName = comps[1]
                    if dirName == "..", let parent = pwd.parent {
                        pwd = parent
                    } else if let dir = pwd.subdirs[dirName] {
                        pwd = dir
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
                            pwd.subdirs[dir.name] = dir
                        case let size where Int(size) != nil:
                            let file = File(dir: pwd, name: name, size: Int(size)!)
                            pwd.files[file.name] = file
                        default:
                            break
                        }
                    }
                }
            }
        }
        return fs
    }
    
}

class Dir {
    weak var parent: Dir?
    var name: String
    var subdirs: [String:Dir] = [:]
    var files: [String:File] = [:]
    
    init(parent: Dir?, name: String) {
        self.parent = parent
        self.name = name
    }
    
    func totalSize() -> Int {
        files.values.map { $0.size }.reduce(0, +) + subdirs.values.reduce(0) { $0 + $1.totalSize() }
    }
    
    func allDirs() -> [Dir] {
        var dirs = [self]
        for sub in subdirs.values {
            dirs += sub.allDirs()
        }
        return dirs
    }
}

struct File {
    private(set) weak var dir: Dir?
    let name: String
    let size: Int
}
