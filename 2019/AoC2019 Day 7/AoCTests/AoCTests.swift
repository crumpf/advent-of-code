//
//  AoCTests.swift
//  AoCTests
//
//  Created by Chris Rumpf on 12/19/19.
//  Copyright © 2019 Genesys. All rights reserved.
//

import XCTest

class AoCTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testPart1Example1() {
        let input = [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]
        let amps = ["A","B","C","D","E"].map { Amplifier(name: "Amp\($0)", program: input) }

        var outputSignal: Int?
        outputSignal = amps[0].run(phaseSetting: 4, inputSignal: outputSignal)
        outputSignal = amps[1].run(phaseSetting: 3, inputSignal: outputSignal)
        outputSignal = amps[2].run(phaseSetting: 2, inputSignal: outputSignal)
        outputSignal = amps[3].run(phaseSetting: 1, inputSignal: outputSignal)
        outputSignal = amps[4].run(phaseSetting: 0, inputSignal: outputSignal)

        XCTAssert(43210 == outputSignal)
    }

    func testPart1Example2() {
        let input = [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]
        let amps = ["A","B","C","D","E"].map { Amplifier(name: "Amp\($0)", program: input) }

        var outputSignal: Int?
        outputSignal = amps[0].run(phaseSetting: 0, inputSignal: outputSignal)
        outputSignal = amps[1].run(phaseSetting: 1, inputSignal: outputSignal)
        outputSignal = amps[2].run(phaseSetting: 2, inputSignal: outputSignal)
        outputSignal = amps[3].run(phaseSetting: 3, inputSignal: outputSignal)
        outputSignal = amps[4].run(phaseSetting: 4, inputSignal: outputSignal)

        XCTAssert(54321 == outputSignal)
    }

    func testPart1Example3() {
        let input = [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]
        let amps = ["A","B","C","D","E"].map { Amplifier(name: "Amp\($0)", program: input) }

        var outputSignal: Int?
        outputSignal = amps[0].run(phaseSetting: 1, inputSignal: outputSignal)
        outputSignal = amps[1].run(phaseSetting: 0, inputSignal: outputSignal)
        outputSignal = amps[2].run(phaseSetting: 4, inputSignal: outputSignal)
        outputSignal = amps[3].run(phaseSetting: 3, inputSignal: outputSignal)
        outputSignal = amps[4].run(phaseSetting: 2, inputSignal: outputSignal)

        XCTAssert(65210 == outputSignal)
    }

}
