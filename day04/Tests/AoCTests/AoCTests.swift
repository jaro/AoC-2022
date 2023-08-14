import XCTest
@testable import AoC

final class AoCTests: XCTestCase {
    let input = ["2-4,6-8", "2-3,4-5", "5-7,7-9", "2-8,3-7", "6-6,4-6", "2-6,4-8"]
    
    func testSolution1() throws {
        XCTAssertEqual(AoC(input).getSolutionPart1(), 2)
    }
    
    func testSolution2() throws {
        XCTAssertEqual(AoC(input).getSolutionPart2(), 4)
    }
}
