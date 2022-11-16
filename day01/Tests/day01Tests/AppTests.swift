import XCTest
@testable import day01

final class AppTests: XCTestCase {
    let input = [1337, 42]
    
    func testSolution1() throws {
        XCTAssertEqual(App(input).getSolutionPart1(), 1379)
    }
    
    func testSolution2() throws {
        XCTAssertEqual(App(input).getSolutionPart2(), 56154)
    }
}
