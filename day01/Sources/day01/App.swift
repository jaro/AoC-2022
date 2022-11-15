import Foundation

@main
public struct App {
    public static func main() {
        let part = ProcessInfo.processInfo.environment["part"] ?? "part1"
        
        if part == "part2" {
            print(App().getSolutionPart2())
        } else  {
            print(App().getSolutionPart1())
        }
    }
    
    private func getSolutionPart1() -> Int {
        return 1
    }

    private func getSolutionPart2() -> Int {
        return 2
    }
}
