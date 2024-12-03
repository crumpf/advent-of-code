//
//  Day20.swift
//  Advent of Code
//
//  Created by Christopher Rumpf on 12/20/23.
//
//  --- Day 20: Pulse Propagation ---

import Foundation
import RegexBuilder

class Day20: Day {
    func part1() -> String {
        let machine = Machine(input: input)

        for _ in 1...1000 {
            machine.pushButton()
        }

        let results = machine.modules.values.reduce((0,0)) { partialResult, m in
            (partialResult.0 + m.pulseCounts.0, partialResult.1 + m.pulseCounts.1)
        }

        return "\(results.0 * results.1)"
    }
    
    func part2() -> String {
        let machine = Machine(input: input)
        let presses = machine.pressesToSendPulsetoRx()
        return "\(presses)"
    }

    enum ModuleType: String {
        case flipflop = "%"
        case conjunction = "&"
        case broadcaster = "b"
    }

    struct Machine {
        fileprivate let modules: [String: Module]
        init(input: String) {
            let connectionRegex = Regex {
                Optionally { Capture { One(.anyOf("%&")) } }
                //Capture { Optionally { One(.anyOf("%&")) } }
                Capture { OneOrMore(.word) }
                " -> "
                Capture { OneOrMore(.any) }
            }
            var mods: [String: Module] = [:]
            var relationships: [String: [String]] = [:]
            input.enumerateLines { line, stop in
                if let match = line.matches(of: connectionRegex).first {
                    switch match.output {
                    case let (_, "%", name, connections):
                        let id = String(name)
                        relationships[id] = connections.components(separatedBy: ", ")
                        mods[String(id)] = FlipFlopModule(name: id)
                    case let (_, "&", name, connections):
                        let id = String(name)
                        relationships[id] = connections.components(separatedBy: ", ")
                        mods[String(id)] = ConjunctionModule(name: id)
                    case let (_, nil, name, connections):
                        let id = String(name)
                        relationships[id] = connections.components(separatedBy: ", ")
                        mods[String(id)] = BroadcastModule(name: id)
                    default:
                        print("parsing error!")
                    }
                }
            }
            for relation in relationships {
                for to in relation.value {
                    if mods[to] == nil {
                        // termination nodes won't have been constructed yet while parsing the lines above since
                        // they're not described on any lhs of the -> instructions
                        mods[to] = Module(name: to)
                    }
                    mods[relation.key]?.outputs.append(mods[to]!)
                    mods[to]?.inputs.append(Weak(value: mods[relation.key]!))
                }
            }

            modules = mods
        }

        func pushButton() {
            modules["broadcaster"]?.receivePulse(false, from: nil)
        }

        func pressesToSendPulsetoRx() -> Int {
            // Looking for  when a single low pulse is sent to rx.
            // rx has a single input:
            // &nc -> rx
            // Since nc is Conjunction, it only sends low when it remembers high pulses for all inputs:
            // &hh -> nc, &fn -> nc, &fh -> nc, &lk -> nc

            //TODO

            return -1
        }
    }
}

// access modifiers on these classes are fast and loose, it's AoC, baby!

fileprivate class Module {
    var name: String = ""
    var inputs: [Weak<Module>]  = []
    var outputs: [Module] = []
    init(name: String) {
        self.name = name
    }
    func receivePulse(_ pulse: Bool, from: Module?) {
        if pulse { pulseCounts.high += 1 } else { pulseCounts.low += 1 }
    }
    func sendPulse(_ pulse: Bool) {
        for next in outputs {
//            print("\(name) -\(pulse)-> \(next.name)")
            next.receivePulse(pulse, from: self)
        }
    }
    var pulseCounts = (low: 0, high: 0)
}

fileprivate class BroadcastModule: Module {
    override func receivePulse(_ pulse: Bool, from: Module?) {
        super.receivePulse(pulse, from: from)
        sendPulse(pulse)
    }
}

fileprivate class FlipFlopModule: Module {
    private(set) var state = false
    override func receivePulse(_ pulse: Bool, from: Module?) {
        super.receivePulse(pulse, from: from)
        guard !pulse, let _ = from else { return }
        state = !state
        sendPulse(state)
    }
}

fileprivate class ConjunctionModule: Module {
    private(set) var memory = [String: Bool]()
    override func receivePulse(_ pulse: Bool, from: Module?) {
        super.receivePulse(pulse, from: from)
        guard let from else { return }
        memory[from.name] = pulse
        if inputs.allSatisfy({ true == memory[$0.value!.name] }) {
            sendPulse(false)
        } else {
            sendPulse(true)
        }
    }
}
