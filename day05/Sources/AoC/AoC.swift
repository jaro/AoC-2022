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
    
    struct Move {
        let numb: Int
        let from: Int
        let to: Int
    }
    
    private func parseInput() -> (supplies: [Stack<String>], moves: [Move]) {
        var supplies = parseStacks2()
        var moves = parseMoves()
        
        return (supplies, moves)
    }
    
    private func parseMoves() -> [Move] {
        return input.filter{$0.starts(with: "move")}.map{matchString(regex: #"^\w+\s+(\d+)\s+\w+\s+(\d+)\s+\w+\s+(\d+)"#, string: $0)}.map{Move(numb: Int($0[0]) ?? 0, from: Int($0[1]) ?? 1, to: Int($0[2]) ?? 1)}
    }
    
    private func parseNumbOfStacks() -> Int {
        for row in input {
            if row.range(of: "[0-9]+", options: .regularExpression) != nil {
                return row.split(separator: " ").map{Int($0)!}.max()!
            }
        }
        
        return 0
    }
    
//    "    [D]",
//    "[N] [C]"
//    "[Z] [M] [P]"
    func parseStacks2() -> [Stack<String>] {
        let numbStacks = parseNumbOfStacks()
        
        var supplies = [Stack<String>]()

        
        let piles = input.filter{$0.contains("[")}
        for p in piles {
            matchString(regex: #"^(.{3})(?:\s(.{3}))*"#, string: p)
        }
        
//        for row in input {
//            if isDigit {
//                let numbOfStacks = row.split(separator: " ").map{Int($0)!}.max()!
//                stacks = Array(repeating: [], count: numbOfStacks)
//
//                for stack in pile {
//                    let base = stack.index(stack.startIndex, offsetBy: 1)
//
//                    for pos in 0...numbOfStacks-1 {
//                        if (pos*4)+1 > stack.count {
//                            break
//                        }
//                        let start = stack.index(base, offsetBy: pos*4)
//                        let end = stack.index(start, offsetBy: 1)
//
//                        let char = String(stack[start..<end])
//
//                        if (char != " ") {
//                            stacks[pos].append(char)
//                        }
//                    }
//
//                }
//
//                break
//            } else {
//                pile.append(row)
//            }
//        }

        
        return supplies
    }
    
    private func matchString(regex: String, string: String) -> [String] {
        let range = NSRange(location: 0, length: string.utf16.count)
        let regex = try! NSRegularExpression(pattern: regex)
        

        for r in regex.matches(in: string, range: range) {
            print((0..<r.numberOfRanges).map{r.range(at: $0)}.map{Range($0, in: string)!}.compactMap{String(string[$0])})
        }
        
        if let result = regex.firstMatch(in: string, range: range) {
            return (1..<result.numberOfRanges).map{result.range(at: $0)}.map{Range($0, in: string)!}.compactMap{String(string[$0])}
        }
        
        return [String]()
    }
    
    
    //<---------------- OLD SOLUTION ----------------->
    
    private func parseMove(row: String) -> Move {
        let inst = matchString(regex: #"^\w+\s+(\d+)\s+\w+\s+(\d+)\s+\w+\s+(\d+)"#, string: row)
        return Move(numb: Int(inst[0]) ?? 0, from: Int(inst[1]) ?? 1, to: Int(inst[2]) ?? 1)
    }
    
    private func parseStacks() -> [[String]] {
        var pile = [String]()
        var stacks = [[String]]()
        
        for row in input {
            let isDigit = row.range(of: "[0-9]+", options: .regularExpression) != nil
            
            if isDigit {
                let numbOfStacks = row.split(separator: " ").map{Int($0)!}.max()!
                stacks = Array(repeating: [], count: numbOfStacks)
                
                for stack in pile {
                    let base = stack.index(stack.startIndex, offsetBy: 1)
                    
                    for pos in 0...numbOfStacks-1 {
                        if (pos*4)+1 > stack.count {
                            break
                        }
                        let start = stack.index(base, offsetBy: pos*4)
                        let end = stack.index(start, offsetBy: 1)
                        
                        let char = String(stack[start..<end])
                        
                        if (char != " ") {
                            stacks[pos].append(char)
                        }
                    }
                    
                }
                
                break
            } else {
                pile.append(row)
            }
        }
        
        for i in 0..<stacks.count {
            stacks[i].reverse()
        }
        
        return stacks
    }
    
    func getSolutionPart1() -> String {
        var msg = ""
        
        print(parseMoves())

        var stacks = parseStacks()
        var moves = [Move]()
        
        for row in input {
            if row.contains("move") {
                moves.append(parseMove(row: row))
            }
        }
        
        for move in moves {
            for _ in 0..<move.numb {
                var stack = stacks[move.from-1]
                let item = stack[stack.count-1]
                stack.remove(at: stack.count-1)
                
                stacks[move.to-1].append(item)
                stacks[move.from-1] = stack
            }
        }
        
        for stack in stacks {
            msg += stack[stack.count-1]
        }
        
        return msg
    }
    
    func getSolutionPart2() -> String {
        var msg = ""

        var stacks = parseStacks()
        var moves = [Move]()
        
        for row in input {
            if row.contains("move") {
                moves.append(parseMove(row: row))
            }
        }
        
        for move in moves {
            var stack = stacks[move.from-1]
            let start = stack.count-(move.numb)
            let end = start+move.numb
            let items = stack[start..<end]
            
            stack.removeSubrange(start..<end)
            
            stacks[move.to-1].append(contentsOf: items)
            stacks[move.from-1] = stack
        }
        
        for stack in stacks {
            msg += stack[stack.count-1]
        }
        
        return msg
    }
}
