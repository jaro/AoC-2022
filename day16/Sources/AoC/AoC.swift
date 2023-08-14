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
    
    func parseValve(row: String) -> Valve {
        //let pattern = #"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)"#
        let pattern = #"Valve ([A-Q]{2}) has flow rate=(\d+); (?:tunnels|tunnel) (?:lead|leads) to (?:valves|valve)(.*)"#
        
        let result = matchString(regex: pattern, string: row)
        let tunels = result[2].split(separator: ",").compactMap{$0.trimmingCharacters(in: .whitespaces)}
        let valve = Valve(name: result[0], flow: Int(result[1])!, tunels: tunels)
        
        return valve
    }
    
    func parseAllValves() -> [String:Valve] {
        let valves = input.map{parseValve(row: $0)}
        return valves.reduce(into: [String:Valve]()) {$0[$1.name] = $1}
    }
    
    func calcFlow(path:String, minute:Int, valvesMap: [String:Valve], flow: Int) {
        let startIndex = path.index(path.endIndex, offsetBy: -2)
        let valve = path.suffix(from: startIndex)
        let val = valvesMap[String(valve)]!
        if minute < 29 {
            for v in val.tunels {
                calcFlow(path: path+valvesMap[v]!.name, minute: val.flow > 0 ? minute+2 : minute+1, valvesMap: valvesMap, flow: (flow + val.flow))
            }
        } else if minute == 29 {
            print("Path: \(path) - Flow: \(flow+val.flow)")
        } else {
            print("Path: \(path) - Flow: \(flow)")
        }
    }
    
    func getSolutionPart1() -> Int {
        let valvesMap = parseAllValves()
        print(valvesMap)
        
        calcFlow(path: "AA", minute: 0, valvesMap: valvesMap, flow: 0)
        
        return 0
    }
    
    func getSolutionPart2() -> Int {
        return 0
    }
    
    struct Valve {
        let name: String
        let flow: Int
        let tunels: [String]
    }
    
    private func matchString(regex: String, string: String) -> [String] {
        let range = NSRange(location: 0, length: string.utf16.count)
        let regex = try! NSRegularExpression(pattern: regex)
        
        if let result = regex.firstMatch(in: string, range: range) {
            return (1..<result.numberOfRanges).map{result.range(at: $0)}.map{Range($0, in: string)!}.compactMap{String(string[$0])}
        }
        
        return [String]()
    }
}
