import Foundation

@main
public struct AoC {
    let input: [String]
    
    init(_ data: [String]) { self.input = data }
    
    public static func main() {
        let part = ProcessInfo.processInfo.environment["part"] ?? "part1"
        let input = parse(file: "input.txt")
        
        if part == "part2" {
            print(AoC(input).getSolutionPart2())
        } else  {
            print(AoC(input).getSolutionPart1())
        }
    }
    
    static func parse(file filename: String) -> [String] {
        guard let content = try? String(contentsOfFile: filename) else {fatalError("Error parsing file \(filename)")}
        return content.components(separatedBy: .newlines).filter{!$0.isEmpty}.compactMap{$0}
    }
    
    func getSolutionPart1() -> Int {
        let scoreMap = ["AX":4,"AY":8,"AZ":3,"BX":1,"BY":5,"BZ":9,"CX":7,"CY":2,"CZ":6]
        return input.map{$0.filter{!$0.isWhitespace}}.map{scoreMap[$0]!}.reduce(0,+)
    }
    
    func getSolutionPart2() -> Int {
        let moveMap = ["AX":"AZ","AY":"AX","AZ":"AY","BX":"BX","BY":"BY","BZ":"BZ","CX":"CY","CY":"CZ","CZ":"CX"]
        let scoreMap = ["AX":4,"AY":8,"AZ":3,"BX":1,"BY":5,"BZ":9,"CX":7,"CY":2,"CZ":6]
        return input.map{$0.filter{!$0.isWhitespace}}.map{moveMap[$0]!}.map{scoreMap[$0]!}.reduce(0,+)
    }
}
