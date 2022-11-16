import Foundation

@main
public struct App {
    let input: [Int]
    
    init(_ input: [Int]) {
        self.input = input
    }
    
    public static func main() {
        let part = ProcessInfo.processInfo.environment["part"] ?? "part1"
        let input = parse(file: "input.txt")
        
        if part == "part2" {
            print(App(input).getSolutionPart2())
        } else  {
            print(App(input).getSolutionPart1())
        }
    }
    
    static func parse(file filename: String) -> [Int] {
        do {
            let content = try String(contentsOfFile: filename)
            
            return content.components(separatedBy: .newlines).compactMap{Int($0)}
        } catch {
            print("Error reading/parsing \(filename) - \(error)")
        }
        
        return [Int]()
    }
    
    func getSolutionPart1() -> Int {
        return input.reduce(0, +)
    }

    func getSolutionPart2() -> Int {
        return input.reduce(1, *)
    }
}
