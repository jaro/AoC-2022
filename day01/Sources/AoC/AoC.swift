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
        return content.components(separatedBy: .newlines).compactMap{$0}
    }
    
    func getSolutionPart1() -> Int {
        return input.split(separator: "").map{Array($0)}.map{$0.map{Int($0)!}}.map{$0.reduce(0,+)}.max()!
    }
    
    func getSolutionPart2() -> Int {
        return input.split(separator: "").map{Array($0)}.map{$0.map{Int($0)!}}.map{$0.reduce(0,+)}.sorted().reversed()[0...2].reduce(0,+)
    }
}
