// https://adventofcode.com/2019/day/4

var str = "Advent of Code 2019, Day 4"
print(str + "\n")

/*
 --- Day 4: Secure Container ---

 You arrive at the Venus fuel depot only to discover it's protected by a password. The Elves had written the password on a sticky note, but someone threw it out.

 However, they do remember a few key facts about the password:

 It is a six-digit number.
 The value is within the range given in your puzzle input.
 Two adjacent digits are the same (like 22 in 122345).
 Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
 Other than the range rule, the following are true:

 111111 meets these criteria (double 11, never decreases).
 223450 does not meet these criteria (decreasing pair of digits 50).
 123789 does not meet these criteria (no double).
 How many different passwords within the range given in your puzzle input meet these criteria?
 */

// Your puzzle input is 146810-612564.

//let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
//let input = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
//let program = input.components(separatedBy: ",").compactMap { Int($0) }

let input = "146810-612564"

func countDigits(in number: Int) -> Int {
    return getDigitsArray(from: number).count
}

func getDigitsArray(from numberIn: Int) -> [Int] {
    guard numberIn >= 0 else {
        return []
    }
    guard numberIn != 0 else {
        return [0]
    }

    var digits: [Int] = []
    var num = numberIn
    while num > 0 {
        digits.append(num % 10)
        num /= 10
    }

    return digits
}

func getRange(input: String) -> ClosedRange<Int>? {
    let inputs = input.split(separator: "-")
    guard inputs.count == 2 else {
        print("Error with inputs, count is \(inputs.count)")
        return nil
    }

    guard let lower = Int(inputs[0]), let upper = Int(inputs[1]) else {
        print("Error with lower and upper bounds")
        return nil
    }

    return lower...upper
}

func isValid(_ numIn: Int) -> Bool {
    let digits = getDigitsArray(from: numIn)
    guard digits.count == 6 else {
        print("Error number doesn't have 6 digits")
        return false
    }

    var satisfiesAdjacentRule = false

    var previousDigit: Int? = nil
    for digit in digits.reversed() {
        if let prev = previousDigit {
            if !satisfiesAdjacentRule, prev == digit {
                satisfiesAdjacentRule = true
            }
            if digit < prev {
                return false
            }
        }

        previousDigit = digit
    }

    return satisfiesAdjacentRule
}

func findPossibilities(in range: ClosedRange<Int>) -> Set<Int> {
    guard countDigits(in: range.lowerBound) == 6, countDigits(in: range.upperBound) == 6 else {
        print("Error range bounds must be 6 digits")
        return Set<Int>()
    }

    print("there are \(range.upperBound - range.lowerBound + 1) candidates in range")

    var candidates = Set<Int>()

    for i in range {
        if isValid(i) {
            candidates.insert(i)
        }
    }

    return candidates
}

// Tests
if isValid(111111) {
    print("test1 passed, 111111 valid")
} else {
    print("test1 failed")
}
if !isValid(223450) {
    print("test2 passed, 223450 invalid")
} else {
    print("test2 failed")
}
if !isValid(123789) {
    print("test3 passed, 123789 invalid")
} else {
    print("test3 failed")
}

if let range = getRange(input: input) {
    let possibilities = findPossibilities(in: range)
    print("Found \(possibilities.count) possibilities")
    // answer is 1748
} else {
    print("Error getting range to evaluate")
}

print("\nPART 2")

// An Elf just remembered one more important detail: the two adjacent matching digits are not part of a larger group of matching digits.

func isValid2(_ numIn: Int) -> Bool {
    let digits = getDigitsArray(from: numIn)
    guard digits.count == 6 else {
        print("Error number doesn't have 6 digits")
        return false
    }

    var satisfiesAdjacentRule = false

    var previousDigit: Int? = nil
    var sameCount = 0
    for digit in digits.reversed() {
        if let prev = previousDigit {
            if digit < prev {
                return false
            }
            if (digit != prev) {
                if !satisfiesAdjacentRule, sameCount == 2 {
                    satisfiesAdjacentRule = true
                }
                sameCount = 0
            }
        }

        previousDigit = digit
        sameCount += 1
    }

    // have to check to see if the least sig digit satisifies too
    if !satisfiesAdjacentRule, sameCount == 2 {
        satisfiesAdjacentRule = true
    }

    return satisfiesAdjacentRule
}

func testPart2(num: Int, isValid: Bool) {
    guard isValid2(num) == isValid else {
        print("testing part 2 for \(num) FAILED")
        return
    }
    print("testing part 2 for \(num) PASSED")
}

testPart2(num: 112233, isValid: true)
testPart2(num: 123444, isValid: false)
testPart2(num: 111122, isValid: true)

func findPossibilities2(in range: ClosedRange<Int>) -> Set<Int> {
    guard countDigits(in: range.lowerBound) == 6, countDigits(in: range.upperBound) == 6 else {
        print("Error range bounds must be 6 digits")
        return Set<Int>()
    }

    print("there are \(range.upperBound - range.lowerBound + 1) candidates in range")

    var candidates = Set<Int>()

    for i in range {
        if isValid2(i) {
            candidates.insert(i)
        }
    }

    return candidates
}

if let range = getRange(input: input) {
    let possibilities = findPossibilities2(in: range)
    print("Found \(possibilities.count) possibilities")
    // answer is 1180
} else {
    print("Error getting range to evaluate")
}
