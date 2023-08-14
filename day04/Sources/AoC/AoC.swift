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
        var count = 0

        for row in input {
            let elves = row.split(separator: ",")
            let elve1 = elves[0]
            let elve2 = elves[1]
            var range = elve1.split(separator: "-")
            var a = range[0]
            var b = range[1]
            
            let sections1 = Array(Int(a)!...Int(b)!)

            range = elve2.split(separator: "-")
            a = range[0]
            b = range[1]
            
            let sections2 = Array(Int(a)!...Int(b)!)
            
            let x = Set(sections1)
            let y = Set(sections2)
            
            if (x.isSubset(of: y) || y.isSubset(of: x)) {
                count += 1
            }
        }

        return count
    }
    
    func getSolutionPart2() -> Int {
        var count = 0

        for row in input {
            let elves = row.split(separator: ",")
            let elve1 = elves[0]
            let elve2 = elves[1]
            var range = elve1.split(separator: "-")
            var a = range[0]
            var b = range[1]
            
            let sections1 = Array(Int(a)!...Int(b)!)

            range = elve2.split(separator: "-")
            a = range[0]
            b = range[1]
            
            let sections2 = Array(Int(a)!...Int(b)!)
            
            let x = Set(sections1)
            let y = Set(sections2)
            
            if (!x.intersection(y).isEmpty) {
                count += 1
            }
        }

        return count
    }
}
