import XCTest
@testable import AoC

final class AoCTests: XCTestCase {
    let input = ["    [D]",
                 "[N] [C]",
                 "[Z] [M] [P]",
                 " 1   2   3",
                 "",
                 "move 1 from 2 to 1",
                 "move 3 from 1 to 3",
                 "move 2 from 2 to 1",
                 "move 1 from 1 to 2"]
    
    func testSolution1() throws {
        XCTAssertEqual(AoC(input).getSolutionPart1(), "CMZ")
    }
    
    func testSolution2() throws {
        XCTAssertEqual(AoC(input).getSolutionPart2(), "MCD")
    }
    
    func testRegex() throws {
        AoC(input).parseStacks2()
    }
}
