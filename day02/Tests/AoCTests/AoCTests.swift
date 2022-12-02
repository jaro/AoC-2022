import XCTest
@testable import AoC

final class AoCTests: XCTestCase {
    // A - Rock, B - Paper, C - Scissors (opponent)
    // X - Rock, Y - Paper, Z - Scissors (reponse)
    //Score: Paper=2 Rock=1, Scissors=3, loss = 0, win=6
    let input = ["A Y", "B X", "C Z"]
    
    func testSolution1() throws {
        XCTAssertEqual(AoC(input).getSolutionPart1(), 15)
    }
    
    func testSolution2() throws {
        XCTAssertEqual(AoC(input).getSolutionPart2(), 12)
    }
}
