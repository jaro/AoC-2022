import XCTest
@testable import AoC

final class AoCTests: XCTestCase {
    let input = [[3,0,3,7,3],
                 [2,5,5,1,2],
                 [6,5,3,3,2],
                 [3,3,5,4,9],
                 [3,5,3,9,0]]
    
    func testSolution1() throws {
        XCTAssertEqual(AoC(input).getSolutionPart1(), 21)
    }
    
    func testSolution2() throws {
        XCTAssertEqual(AoC(input).getSolutionPart2(), 8)
    }
}
