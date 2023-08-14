import XCTest
@testable import AoC

final class AoCTests: XCTestCase {
    let input = ["Sabqponm",
                 "abcryxxl",
                 "accszExk",
                 "acctuvwj",
                 "abdefghi"]
    
    func testSolution1() throws {
        XCTAssertEqual(AoC(input).getSolutionPart1(), 31)
    }
    
    func testSolution2() throws {
        XCTAssertEqual(AoC(input).getSolutionPart2(), 29)
    }
}
