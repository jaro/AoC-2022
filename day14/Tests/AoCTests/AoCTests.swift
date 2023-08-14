import XCTest
@testable import AoC

final class AoCTests: XCTestCase {
    let input = ["498,4 -> 498,6 -> 496,6",
                 "503,4 -> 502,4 -> 502,9 -> 494,9"]
    
    func testSolution1() throws {
        XCTAssertEqual(AoC(input).getSolutionPart1(), 24)
    }
    
    func testSolution2() throws {
        XCTAssertEqual(AoC(input).getSolutionPart2(), 93)
    }
}
