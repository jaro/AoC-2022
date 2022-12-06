import Foundation

@main
public struct AoC {
    let input: String
    
    init(_ data: String) { self.input = data }
    
    public static func main() {
        let part = ProcessInfo.processInfo.environment["part"] ?? "part1"
        let input = parse(file: "input.txt")
        
        if part == "part2" {
            print(AoC(input[0]).getSolutionPart2())
        } else  {
            print(AoC(input[0]).getSolutionPart1())
        }
    }
    
    static func parse(file filename: String) -> [String] {
        guard let content = try? String(contentsOfFile: filename) else {fatalError("Error parsing file \(filename)")}
        return content.components(separatedBy: .newlines).filter{!$0.isEmpty}.compactMap{$0}
    }
    
    func getSolutionPart1() -> Int {
        return ((0...(input.count-4)).filter{Set(subString(msg: input, start: $0, lenght: 4)).count == 4}.first)!+4
    }
    
    private func subString(msg: String, start: Int, lenght: Int) -> String {
        let start = input.index(input.startIndex, offsetBy: start)
        let end = input.index(start, offsetBy: lenght)
        
        return String(input[start..<end])
    }
    
    func getSolutionPart2() -> Int {
        return ((0...(input.count-14)).filter{Set(subString(msg: input, start: $0, lenght: 14)).count == 14}.first)!+14
    }
}
