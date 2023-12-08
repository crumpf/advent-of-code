//
//  Day02.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/03/2023.
//
// --- Day 2: Cube Conundrum ---

import Foundation

class Day02: Day {
    func part1() -> String {
        "\(sumOfPossibleGameIds(withRed: 12, green: 13, blue: 14))"
    }
    
    func part2() -> String {
        "\(sumOfGamePowers())"
    }
    
    typealias Reveal = (count: Int, color: String)
    typealias Game = (id: Int, reveals: [[Reveal]])
    
    private func sumOfPossibleGameIds(withRed red: Int, green: Int, blue: Int) -> Int {
        input.lines()
            .map(makeGame(line:))
            .filter { isGameValid(game: $0, red: red, green: green, blue: blue) }
            .map { $0.id }
            .reduce(0, +)
    }
    
    private func sumOfGamePowers() -> Int {
        input.lines()
            .map(makeGame(line:))
            .map(power(ofGame:))
            .reduce(0, +)
    }
    
    private func makeGame(line: String) -> Game {
        //Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        let comps = line.components(separatedBy: ":")
        let id = Int(comps[0].dropFirst("Game ".count))!
        let reveals = comps[1].components(separatedBy: ";").map {
            $0.components(separatedBy: ",")
            .map {
                let split = $0.components(separatedBy: " ")
                return Reveal(Int(split[1])!, split[2])
            }
        }
        return Game(id, reveals)
    }
    
    private func isGameValid(game: Game, red: Int, green: Int, blue: Int) -> Bool {
        for reveal in game.reveals {
            for cubes in reveal {
                switch cubes {
                case let (count, "red"): if count > red { return false }
                case let (count, "green"): if count > green { return false }
                case let (count, "blue"): if count > blue { return false }
                default: break
                }
            }
        }
        return true
    }
    
    private func power(ofGame game: Game) -> Int {
        var minimum: (r: Int, g: Int, b: Int) = (0, 0, 0)
        for reveal in game.reveals {
            for cubes in reveal {
                switch cubes {
                case let (count, "red"): minimum.r = max(minimum.r, count)
                case let (count, "green"): minimum.g = max(minimum.g, count)
                case let (count, "blue"): minimum.b = max(minimum.b, count)
                default: break
                }
            }
        }
        return minimum.r * minimum.g * minimum.b
    }
}
