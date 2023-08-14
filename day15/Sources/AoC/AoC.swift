import Foundation

@main
public struct AoC {
    let input: [String]
    
    init(_ data: [String]) { self.input = data }
    
    public static func main() {
        let part = ProcessInfo.processInfo.environment["part"] ?? "part1"
        let input = parse(file: "input.txt")
        
        if part == "part2" {
            print(AoC(input).getSolutionPart2(maxY: 4000000))
        } else  {
            print(AoC(input).getSolutionPart1(line: 2000000))
        }
    }
    
    static func parse(file filename: String) -> [String] {
        guard let content = try? String(contentsOfFile: filename) else {fatalError("Error parsing file \(filename) - ")}
        return content.components(separatedBy: .newlines).filter{!$0.isEmpty}.compactMap{$0}
    }
    
    func parseSensorsAndBecons(row: String) -> Sensor {
        let pattern = #"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)"#
        
        let result = matchString(regex: pattern, string: row)
        
        let becon = Becon(x: Int(result[2])!, y: Int(result[3])!)
        let sensor = Sensor(x: Int(result[0])!, y: Int(result[1])!, beacon: becon)
        
        
        return sensor
    }
    
    func parseData() -> [Sensor] {
        return [Sensor](input.map{parseSensorsAndBecons(row: $0)})
    }
    
    typealias Pos = (x:Int, y:Int)
    
    func getSolutionPart1(line: Int) -> Int {
        let sensors = parseData()
        
        let ranges = sensors.map{$0.calcRange(line: line)}
        let beacons = sensors.compactMap{$0.beacPos()}
        
        let maxDist = sensors.map{abs($0.x-$0.beacon.x) + abs($0.y-$0.beacon.y)}.max()!
        
        let startX = sensors.flatMap{[$0.x,$0.beacon.x]}.min()! - maxDist
        let width = (sensors.flatMap{[$0.x,$0.beacon.x]}.max()! + maxDist) - startX
        let offsetX = abs(startX)
        
        var count = 0
        for x in 0..<width {
            if !beacons.contains(where: {$0.x==x && $0.y==line}) {
                if ranges.contains(where: {$0.contains(x-offsetX)}) {
                    count += 1
                }
            }
        }
        
        return count
    }
    
    func getSolutionPart2(maxY: Int) -> Int {
        let sensors = parseData()
        
        let beacons = sensors.compactMap{$0.beacPos()}
        
        for y in 0...maxY {
            var ranges = sensors.map{$0.calcRange(line: y, maxY: maxY)}.sorted(by: {$0.lowerBound < $1.lowerBound})
            ranges = ranges.filter{($0.lowerBound != 0) || ($0.upperBound != 0)}
//            for range in ranges {
//                visualize(ranges: [range], upperBound: maxY)
//            }
            for i in 0..<(ranges.count-1) {
                if ranges[i].upperBound > ranges[i+1].upperBound {
                    ranges[i+1] = ranges[i]
                } else if (ranges[i].upperBound+1) == (ranges[i+1].lowerBound) {
                    if !beacons.contains(where: {$0.x==ranges[i].upperBound && $0.y==y}) {
                        //print("spot: (\(y),\(ranges[i].upperBound))")
                        return (ranges[i].upperBound*4000000)+y
                    }
                }
            }
        }
        
        return 0
    }
    
    func visualize(ranges: [Range<Int>], upperBound: Int) {
        for x in 0...upperBound {
            var hit = false
            for range in ranges {
                if range.contains(x) {
                    hit = true
                    break
                }
            }
            if hit {
                print("#", terminator: "")
            } else {
                print(".", terminator: "")
            }
            hit = false
        }
        print("")
    }

    class Sensor {
        let x: Int
        let y: Int
        let beacon: Becon
        var beaconDist = 0
        
        init(x: Int, y: Int, beacon: Becon) {
            self.x = x
            self.y = y
            self.beacon = beacon
        }
        
        func calcRange(line: Int) -> Range<Int> {
            let dist = abs(x-beacon.x) + abs(y-beacon.y)
            let yLineDist = abs(y-line)
            let distLeft = dist-yLineDist
            if distLeft > 0 {
                return Range(x-distLeft...x+distLeft)
            } else {
                return 0 ..< 0
            }
        }
                        
        func calcRange(line: Int, maxY: Int) -> Range<Int> {
            let dist = abs(x-beacon.x) + abs(y-beacon.y)
            let yLineDist = abs(y-line)
            let distLeft = dist-yLineDist
            if distLeft > 0 {
                return Range(max(0,x-distLeft)...min(x+distLeft, maxY))
            } else {
                return 0 ..< 0
            }
        }
                        
                        
        
        func beacPos() -> Pos {
            return (beacon.x, beacon.y)
        }
    }
    
    struct Becon {
        let x: Int
        let y: Int
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
