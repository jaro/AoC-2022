import XCTest
@testable import AoC

final class AoCTests: XCTestCase {
    let testdata1: [String:Int] = ["bvwbjplbgvbhsrlpgdmjqwftvncz":5,
                                   "nppdvjthqldpwncqszvftbrmjlhg":6,
                                   "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg":10,
                                   "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw":11]
    
    let testdata2: [String:Int] = ["mjqjpqmgbljsphdztnvjfqwrcgsmlb":19,
                                   "bvwbjplbgvbhsrlpgdmjqwftvncz":23,
                                   "nppdvjthqldpwncqszvftbrmjlhg":23,
                                   "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg":29,
                                   "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw":26]
    
    func testSolution1() throws {
        for key in testdata1.keys {
            XCTAssertEqual(AoC(key).getSolutionPart1(), testdata1[key])
        }
    }
    
    func testSolution2() throws {
        for key in testdata2.keys {
            XCTAssertEqual(AoC(key).getSolutionPart2(), testdata2[key])
        }
    }
}
