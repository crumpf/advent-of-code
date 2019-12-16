//
//  Day5_Unit_Test.swift
//  Day5 Unit Test
//
//  Created by Chris Rumpf on 12/15/19.
//  Copyright © 2019 Chris Rumpf. All rights reserved.
//

import XCTest

class Day5_Unit_Test: XCTestCase {

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

    func testIntcodeComputer() {
        let input1 = [1002,4,3,4,33]
        let output1 = [1002,4,3,4,99]
        check(input: input1, expectedOutput: output1)

        let input2 = [1101,100,-1,4,0]
        let output2 = [1101,100,-1,4,99]
        check(input: input2, expectedOutput: output2)
    }

    private func check(input: [Int], expectedOutput: [Int]) {
        XCTAssert(!input.isEmpty, "test input is empty")

        let computer = IntcodeComputer()
        do {
            let result = try computer.process(input)
            XCTAssert(!result.isEmpty, "IntcodeComputer produced no results")
            XCTAssertEqual(result, expectedOutput)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testIntcodeComputerInstructionParsing() {
        let value = 1002
        let computer = IntcodeComputer()
        do {
            let codes = try computer.parseValue(value)
            XCTAssertEqual(codes.opcode, .multiply)
            XCTAssertEqual(codes.parameterModes, [.position,.immediate,.position])
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
