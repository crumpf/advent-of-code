//
//  Day5_Unit_Test.swift
//  Day5 Unit Test
//
//  Created by Chris Rumpf on 12/15/19.
//  Copyright © 2019 Chris Rumpf. All rights reserved.
//

import XCTest

class Day5_Unit_Test: XCTestCase {

    let computer = IntcodeComputer()
    var suppliedInput = 0

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        computer.inputDelegate = self
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testPart1() {
        var program = [1002,4,3,4,33]
        check(program: program, input: 1, buffer: [1002,4,3,4,99])

        program = [1101,100,-1,4,0]
        check(program: program, input: 1, buffer: [1101,100,-1,4,99])
    }

    func testLessThanEqual() {
        print("Testing: equal to 8, position mode")
        var program = [3,9,8,9,10,9,4,9,99,-1,8]
        check(program: program, input: 4, finalOutput: 0)
        check(program: program, input: 8, finalOutput: 1)
        check(program: program, input: 12, finalOutput: 0)

        print("Testing: less than 8, position mode")
        program = [3,9,7,9,10,9,4,9,99,-1,8]
        check(program: program, input: 4, finalOutput: 1)
        check(program: program, input: 8, finalOutput: 0)
        check(program: program, input: 12, finalOutput: 0)

        print("Testing: equal to 8, immediate mode")
        program = [3,3,1108,-1,8,3,4,3,99]
        check(program: program, input: 4, finalOutput: 0)
        check(program: program, input: 8, finalOutput: 1)
        check(program: program, input: 12, finalOutput: 0)

        print("Testing: less than 8, immediate mode")
        program = [3,9,7,9,10,9,4,9,99,-1,8]
        check(program: program, input: 4, finalOutput: 1)
        check(program: program, input: 8, finalOutput: 0)
        check(program: program, input: 12, finalOutput: 0)
    }

    func testJumpcodes() {
        // jump tests that take an input, then output 0 if the input was zero or 1 if the input was non-zero
        var program = [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]
        check(program: program, input: 0, finalOutput: 0)
        check(program: program, input: 8, finalOutput: 1)

        program = [3,3,1105,-1,9,1101,0,0,12,4,12,99,1]
        check(program: program, input: 0, finalOutput: 0)
        check(program: program, input: 8, finalOutput: 1)
    }

    func testLargerExample() {
        // example program uses an input instruction to ask for a single number. The program will then output 999 if the input value is below 8, output 1000 if the input value is equal to 8, or output 1001 if the input value is greater than 8.
        let program = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]
        check(program: program, input: 3, finalOutput: 999)
        check(program: program, input: 8, finalOutput: 1000)
        check(program: program, input: 21, finalOutput: 1001)
    }

    func testCountdownProgram() {
        let program = [101,-1,7,7,4,7,1105,11,0,99]
        check(program: program, input: 1, output: [10,9,8,7,6,5,4,3,2,1,0])
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

    private func check(program: [Int], input: Int, buffer: [Int]) {
        XCTAssert(!program.isEmpty, "test input is empty")
        suppliedInput = input
        do {
            let result = try computer.process(program)
            XCTAssertEqual(computer.buffer, buffer)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    private func check(program: [Int], input: Int, finalOutput: Int) {
        XCTAssert(!program.isEmpty, "test input is empty")
        suppliedInput = input
        do {
            let result = try computer.process(program)
            XCTAssertEqual(result.last, finalOutput)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    private func check(program: [Int], input: Int, output: [Int]) {
        XCTAssert(!program.isEmpty, "test input is empty")
        suppliedInput = input
        do {
            let result = try computer.process(program)
            XCTAssertEqual(computer.output, output)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

extension Day5_Unit_Test: InputDelegate {
    func input() -> Int {
        return suppliedInput
    }

    func output(_ value: Int) {
        print(value)
    }
}
