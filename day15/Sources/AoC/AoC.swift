import Foundation

@main
public struct AoC {
    let input: [String]
    
    init(_ data: [String]) { self.input = data }
    
    public static func main() {
        let part = ProcessInfo.processInfo.environment["part"] ?? "part1"
        let input = parse(file: "input.txt")
        
        if part == "part2" {
            print(AoC(input).getSolutionPart2(line: 2000000))
        } else  {
            print(AoC(input).getSolutionPart1(line: 2000000))
        }
    }
    
    static func parse(file filename: String) -> [String] {
        guard let content = try? String(contentsOfFile: filename) else {fatalError("Error parsing file \(filename) - ")}
        return content.components(separatedBy: .newlines).filter{!$0.isEmpty}.compactMap{$0}
    }
    
    func parseSensorAndDecons(row: String) -> Sensor {
        let pattern = #"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)"#
        
        let result = matchString(regex: pattern, string: row)
        
        let becon = Becon(x: Int(result[2])!, y: Int(result[3])!)
        let sensor = Sensor(x: Int(result[0])!, y: Int(result[1])!, beacon: becon)
        
        
        return sensor
    }
    
    func parseData() -> [Sensor] {
        return [Sensor](input.map{parseSensorAndDecons(row: $0)})
    }
    
    func getSolutionPart1(line: Int) -> Int {
        let sensors = parseData()
        sensors.map{$0.calcDist()}
        
        let maxDist = sensors.map{$0.beaconDist}.max()!
        
        let width = sensors.flatMap{[$0.x,$0.beacon.x]}.max()! + (3*maxDist)
        let hight = sensors.flatMap{[$0.y,$0.beacon.y]}.max()! + (3*maxDist)
        
        print("Width: \(width) - Hight: \(hight) - Max dist: \(maxDist)")
        
        var grid = [[Int]]()
        
        for y in 0..<hight {
            var row = [Int]()
            var reachable = false
            
            for x in 0..<width {
                for sensor in sensors {
                    if hasSignal(sensor: sensor, x: x-maxDist, y: y-maxDist) {
                        reachable = true
                        break
                    }
                }
                
                if reachable {
                    row.append(1)
                } else {
                    row.append(0)
                }
                reachable = false
            }
            grid.append(row)
        }
        for sensor in sensors {
            grid[sensor.y+maxDist][sensor.x+maxDist] = 4
            grid[sensor.beacon.y+maxDist][sensor.beacon.x+maxDist] = 7
        }
        
        visualize(grid: grid, offset: maxDist)
        
        return grid[line+maxDist].filter{$0==1}.count
    }
    
    func getSolutionPart2(line: Int) -> Int {
        return 0
    }
    
    func hasSignal(sensor: Sensor, x: Int, y: Int) -> Bool {
        return (abs(sensor.x-x) + abs(sensor.y-y)) <= sensor.beaconDist
    }
    
    func visualize(grid: [[Int]], offset: Int) {
        for y in 0..<grid.count {
            
            print(String(format: "%02d-", y-offset), terminator: "")
            for x in 0..<grid[0].count {
                print("\(grid[y][x])", terminator: "")
            }
            print("")
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
        
        func calcDist() {
            beaconDist = abs(x-beacon.x) + abs(y-beacon.y)
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
