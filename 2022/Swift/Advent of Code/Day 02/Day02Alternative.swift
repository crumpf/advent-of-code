//
//  Day02Alternative.swift
//  Day 02
//
//  Created by Christopher Rumpf on 12/2/22.
//

import Foundation

class Day02Alternative: Day {
    
    func part1() -> String {
        "\(input.lines().reduce(0) { $0 + (part1Map[$1] ?? 0) })"
    }
    
    func part2() -> String {
        "\(input.lines().reduce(0) { $0 + (part2Map[$1] ?? 0) })"
    }
    
    enum HandShape {
        case rock, paper, scissors
        
        var score: Int {
            switch self {
            case .rock:     return 1
            case .paper:    return 2
            case .scissors: return 3
            }
        }
    }
    
    enum Outcome {
        case loss, draw, win
        
        var score: Int {
            switch self {
            case .loss: return 0
            case .draw: return 3
            case .win:  return 6
            }
        }
    }
    
    // A=rock B=paper C=scissors
    // X=rock Y=paper Z=scissors
    private let part1Map = [
        "A X" : Outcome.draw.score + HandShape.rock.score,
        "A Y" : Outcome.win.score  + HandShape.paper.score,
        "A Z" : Outcome.loss.score + HandShape.scissors.score,
        "B X" : Outcome.loss.score + HandShape.rock.score,
        "B Y" : Outcome.draw.score + HandShape.paper.score,
        "B Z" : Outcome.win.score  + HandShape.scissors.score,
        "C X" : Outcome.win.score  + HandShape.rock.score,
        "C Y" : Outcome.loss.score + HandShape.paper.score,
        "C Z" : Outcome.draw.score + HandShape.scissors.score
    ]
    
    // A=rock B=paper C=scissors
    // X=needLose Y=needDraw Z=needWin
    private let part2Map = [
        "A X" : Outcome.loss.score + HandShape.scissors.score,
        "A Y" : Outcome.draw.score + HandShape.rock.score,
        "A Z" : Outcome.win.score  + HandShape.paper.score,
        "B X" : Outcome.loss.score + HandShape.rock.score,
        "B Y" : Outcome.draw.score + HandShape.paper.score,
        "B Z" : Outcome.win.score  + HandShape.scissors.score,
        "C X" : Outcome.loss.score + HandShape.paper.score,
        "C Y" : Outcome.draw.score + HandShape.scissors.score,
        "C Z" : Outcome.win.score  + HandShape.rock.score
    ]
    
}
