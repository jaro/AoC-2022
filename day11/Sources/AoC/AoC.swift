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
        guard let content = try? String(contentsOfFile: filename) else {fatalError("Error parsing file \(filename) - ")}
        return content.components(separatedBy: .newlines).filter{!$0.isEmpty}.compactMap{$0}
    }
    
    func parseMonkies() -> [Monkey] {
        var monkies = [Monkey]()
        var rows = [String]()
        
        for row in input {
            if row.isEmpty {
                monkies.append(parseMonky(rows: rows))
                rows = [String]()
            } else {
                rows.append(row)
            }
        }
        
        monkies.append(parseMonky(rows: rows))
        
        return monkies
    }
    
    func parseMonky(rows: [String]) -> Monkey {
        let row1 = matchString(regex: #"^\s*Starting items:(.*)"#, string: rows[1]).first!
        let items = row1.split(separator: ",").map{$0.filter{!$0.isWhitespace}}.map{Int($0)!}
        
        let ops = matchString(regex: #"Operation: new = old (.) (.+)"#, string: rows[2])
        var op: (Int) -> Int = ops[0] == "*" ? {$0 * $0} : {$0 + $0}
        if (ops[1] != "old") {
            op = ops[0] == "*" ? {$0 * Int(ops[1])!} : {$0 + Int(ops[1])!}
        }
        
        let row3 = matchString(regex: #"Test: divisible by (\d+)"#, string: rows[3])
        let divisible = Int(row3[0])!
        
        let row4 = matchString(regex: #"If true: throw to monkey (\d+)"#, string: rows[4])
        let trueOpt = Int(row4[0])!
        
        let row5 = matchString(regex: #"If false: throw to monkey (\d+)"#, string: rows[5])
        let falseOpt = Int(row5[0])!
        
        return Monkey(items: items, op: op, divisible: divisible, trueOpt: trueOpt, falseOpt: falseOpt)
    }
    
    func getSolutionPart1() -> Int {
        let monkies = parseMonkies()
        
        for _ in 0..<20 {
            for monkey in monkies {
                let items = monkey.items.map{monkey.op($0)}.map{Float($0)/3}.map{Int(floor($0))}
                monkey.count += items.count
                monkey.items = [Int]()
                
                var trueItems = [Int]()
                var falseItems = [Int]()
                for item in items {
                    if item % monkey.divisible == 0 {
                        trueItems.append(item)
                    } else {
                        falseItems.append(item)
                    }
                }
                
                monkies[monkey.trueOpt].items.append(contentsOf: trueItems)
                monkies[monkey.falseOpt].items.append(contentsOf: falseItems)
            }
        }
        
        for monkey in monkies {
            print(monkey.count)
        }
        
        return monkies.map{$0.count}.sorted().suffix(2).reduce(1, *)
    }
    
    func getSolutionPart2() -> Int {
        let monkies = parseMonkies()
        
        var modulo = 1
        for monky in monkies {
            modulo *= monky.divisible
        }
        
        for _ in 0..<10000 {
            for monkey in monkies {
                let items = monkey.items.map{monkey.op($0)}.map{$0%modulo}
                monkey.count += items.count
                monkey.items = [Int]()
                
                var trueItems = [Int]()
                var falseItems = [Int]()
                for item in items {
                    if item % monkey.divisible == 0 {
                        trueItems.append(item)
                    } else {
                        falseItems.append(item)
                    }
                }
                
                monkies[monkey.trueOpt].items.append(contentsOf: trueItems)
                monkies[monkey.falseOpt].items.append(contentsOf: falseItems)
            }
        }
        
        for monkey in monkies {
            print(monkey.count)
        }
        
        return monkies.map{$0.count}.sorted().suffix(2).reduce(1, *)
    }
    
    private func matchString(regex: String, string: String) -> [String] {
        let range = NSRange(location: 0, length: string.utf16.count)
        let regex = try! NSRegularExpression(pattern: regex)
        
        if let result = regex.firstMatch(in: string, range: range) {
            return (1..<result.numberOfRanges).map{result.range(at: $0)}.map{Range($0, in: string)!}.compactMap{String(string[$0])}
        }
        
        return [String]()
    }
    
    
    class Monkey {
        
        init(items: [Int], op: @escaping (Int) -> Int, divisible: Int, trueOpt: Int, falseOpt: Int) {
            self.items = items
            self.op = op
            self.divisible = divisible
            self.trueOpt = trueOpt
            self.falseOpt = falseOpt
        }
        
        var count = 0
        var items: [Int]
        let op: (Int) -> Int
        let divisible: Int
        let trueOpt: Int
        let falseOpt: Int
    }
}
