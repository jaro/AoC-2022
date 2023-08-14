import XCTest
@testable import AoC

final class AoCTests: XCTestCase {
    let input = ["vJrwpWtwJgWrhcsFMMfFFhFp",
                 "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
                 "PmmdzqPrVvPwwTWBwg",
                 "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
                 "ttgJtRGJQctTZtZT",
                 "CrZsJsPPZsGzwwsLwLmpwMDw"]
    
    func testSolution1() throws {
        XCTAssertEqual(AoC(input).getSolutionPart1(), 157)
    }
    
    func testSolution2() throws {
        XCTAssertEqual(AoC(input).getSolutionPart2(), 70)
    }
}
