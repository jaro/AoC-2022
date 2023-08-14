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
    
    func parseRocks() -> (rocks: [Rock], width: (Int,Int), depth: (Int,Int)) {
        var rocks = [Rock]()
        var width = (Int.max,0)
        var depth = (Int.max,0)
        
        for row in input {
            var rock = Rock()
            let points = row.split(separator: " -> ")
            for point in points {
                let cord = point.split(separator: ",")
                let x = Int(cord[0])!
                let y = Int(cord[1])!
                rock.vertices.append(Point(x: x, y: y))
                
                width.0 = min(width.0, x)
                width.1 = max(width.1, x)
                depth.0 = min(depth.0, y)
                depth.1 = max(depth.1, y)
            }
            rocks.append(rock)
        }
        
        return (rocks, width, depth)
    }
    
    func getSolutionPart1() -> Int {
        let data = parseRocks()
        var points = data.rocks.flatMap{$0.calcPoints()}
        
        var sandCount = 1
        var sand = Point(x: 500, y: 0)
        while true {
            let nextSand = calcNext(rock: Set(points), sand: sand)
            if nextSand == sand {
                print("Sand comes to rest")
                points.append(nextSand)
                
                sandCount += 1
                sand = Point(x: 500, y: 0)
            } else {
                sand = nextSand
            }
            
            if sand.y > data.depth.1 {
                print("Overflow...")
                break
            }
        }
        
        //visualize(points: points, width: data.width.1, depth: data.depth.1, startX: data.width.0-10)
        
        return sandCount-1
    }
    
    func calcNext(rock: Set<Point>, sand: Point ) -> Point {
        var next = Point(x: sand.x, y: sand.y+1)
        
        if rock.contains(next) {
            next = Point(x: sand.x-1, y: sand.y+1)
            if rock.contains(next) {
                next = Point(x: sand.x+1, y: sand.y+1)
                if rock.contains(next) {
                    return sand
                }
            }
        }
        
        return next
    }
    
    func calcNext(rock: [[Int]], sand: Point ) -> Point {
        var next = (x: sand.x, y: sand.y+1)
        
        if rock[next.y][next.x] == 1 {
            next = (x: sand.x-1, y: sand.y+1)
            if rock[next.y][next.x] == 1 {
                next = (x: sand.x+1, y: sand.y+1)
                if rock[next.y][next.x] == 1 {
                    return sand
                }
            }
        }
        
        return Point(x: next.x, y: next.y)
    }
    
    func createGrid(points: [Point], width: Int, depth: Int) -> [[Int]] {
        var grid = [[Int]]()
        
        for y in 0..<depth {
            var row = [Int]()
            
            for x in 0..<width {
                if points.contains(Point(x: x, y: y)) {
                    row.append(1)
                } else {
                    row.append(0)
                }
            }
            grid.append(row)
        }
        
        return grid
    }
    
    func visualize(points: [Point], width: Int, depth: Int, startX: Int) {
        var grid = [[Int]]()
        
        for y in 0..<(depth+5) {
            var row = [Int]()
            
            for x in 0..<(width+10) {
                if points.contains(Point(x: x, y: y)) {
                    row.append(1)
                } else {
                    row.append(0)
                }
            }
            grid.append(row)
        }
        
        for y in 0..<grid.count {
            for x in startX..<grid[0].count {
                print("\(grid[y][x])", terminator: "")
            }
            print("")
        }
        
        print("")
    }
    
    func getSolutionPart2() -> Int {
        var data = parseRocks()
        var floor = Rock()
        floor.vertices.append(Point(x: 0, y: (data.depth.1+2)))
        floor.vertices.append(Point(x: data.width.1+500, y: (data.depth.1+2)))
        data.rocks.append(floor)
                              
        var points = data.rocks.flatMap{$0.calcPoints()}
        var grid = createGrid(points: points, width: data.width.1+100, depth: data.depth.1+10)
        
        var sandCount = 1
        var sand = Point(x: 500, y: 0)
        var vis = 0
        while true {
            let nextSand = calcNext(rock: grid, sand: sand)
            if nextSand == sand {
                if sand == Point(x: 500, y: 0) {
                    print("Filled up... \(sand)")
                    break
                }
                grid[nextSand.y][nextSand.x] = 1
                
                sandCount += 1
                sand = Point(x: 500, y: 0)
            } else {
                sand = nextSand
            }
            
            if sand.y > (data.depth.1+2) {
                print("Overflow... \(sand)")
                break
            }
            
            vis += 1
        }
        
        return sandCount
    }
    
    struct Rock {
        var vertices = [Point]()
        
        func calcPoints() -> Set<Point> {
            var points = Set<Point>()
            for i in 0..<(vertices.count-1) {
                let start = vertices[i]
                let end = vertices[i+1]
                
                if start.x == end.x { //Vertical rock
                    let range = (start.y<end.y) ? start.y...end.y : end.y...start.y
                    
                    for y in range {
                        points.insert(Point(x: start.x, y: y))
                    }
                } else if start.y == end.y { //Horizontal rock
                    let range = (start.x<end.x) ? start.x...end.x : end.x...start.x
                    
                    for x in range {
                        points.insert(Point(x: x, y: start.y))
                    }
                }
            }
            
            return points
        }
    }
    
    struct Point: Hashable, Equatable {
        let x: Int
        let y: Int
        
        static func == (lhs: Point, rhs: Point) -> Bool {
            return (lhs.x == rhs.x) && (lhs.y == rhs.y)
        }
    }
}
