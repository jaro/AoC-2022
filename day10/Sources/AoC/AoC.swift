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
    
    func parseCommands() -> [Cmd] {
        var cmds = [Cmd]()
        for row in input {
            let cmd = row.split(separator: " ")
            if cmd[0] == "noop" {
                cmds.append(Cmd(value: 0, cycles: 1))
            }
            if cmd[0] == "addx" {
                cmds.append(Cmd(value: Int(cmd[1])!, cycles: 2))
            }
        }
            
        return cmds
    }
    
    func getSolutionPart1() -> Int {
        var cmds = parseCommands()
        var x = 1
        var cycles = 0
        var checkpoint = 20
        var sum = 0
        
        while (!cmds.isEmpty) {
            cycles += 1
            if (cycles == checkpoint) {
                print(x)
                sum += (cycles * x)
                checkpoint += 40
            }
            
            var cmd = cmds.first!
            if cmd.doCycle() {
                x += cmd.value
                cmds.remove(at: 0)
            }
        }
        
        return sum
    }
    
    func getSolutionPart2() -> Int {
        var cmds = parseCommands()
        var x = 1
        var cycles = 0
        var rows = ["", "", "", "", "", ""]
        
        while (!cmds.isEmpty) {
            cycles += 1
            let pos = (cycles-1) % 40
            let row = (cycles-1) / 40
            
            if abs(pos-x) < 2 {
                rows[row].append("#")
            } else {
                rows[row].append(".")
            }
            //print("Row \(row) - \(pos)")
            
            var cmd = cmds.first!
            if cmd.doCycle() {
                x += cmd.value
                cmds.remove(at: 0)
            }
        }
        
        for row in rows {
            print(row)
        }
        
        return x
    }
    
    class Cmd {
        let value: Int
        var cycles:Int
        
        init(value: Int, cycles: Int) {
            self.value = value
            self.cycles = cycles
        }
        
        func doCycle() -> Bool {
            cycles -= 1
            return cycles <= 0
        }
    }
}
