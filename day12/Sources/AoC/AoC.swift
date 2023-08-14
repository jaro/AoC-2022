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
    
    func parseNodes() -> (nodes: [Node], start: Node, end: Node) {
        let elevationMap: [Character:Int]  = ["a":1,"b":2,"c":3,"d":4,"e":5,"f":6,"g":7,"h":8,"i":9,"j":10,"k":11,"l":12,"m":13,"n":14,"o":15,"p":16,"q":17,"r":18,"s":19,"t":20,"u":21,"v":22,"w":23,"x":24,"y":25,"z":26, "S":1, "E":26]
        
        var nodes = [Node]()
        var start: Node?
        var end: Node?
        
        var x = 0
        var y = 0
        for row in input {
            for char in row {
                let node = Node(x: x, y: y, hight: elevationMap[char]!)
                nodes.append(node)
                if char == "S" {
                    start = node
                }
                if char == "E" {
                    end = node
                }
                
                x += 1
            }
            x = 0
            y += 1
        }
        
        return (nodes, start!, end!)
    }
    
    func getSolutionPart1() -> Int {
        let data = parseNodes()
        
        return getShortestPath(nodes: data.nodes, start: data.start, end: data.end)
    }
    
    func getSolutionPart2() -> Int {
        let data = parseNodes()
        var starts = data.nodes.filter{$0.hight == 1}
        
        return starts.map{getShortestPath(nodes: data.nodes, start: $0, end: data.end)}.min()!
    }
    
    func getShortestPath(nodes: [Node], start: Node, end: Node) -> Int {
        var unvisited = nodes
        var visited = [Node]()
        var currentNode = start
        currentNode.dist = 0
        
        while (!unvisited.isEmpty) {
            var neighbors = currentNode.getNeighbors(nodes: unvisited)
            
            for i in 0..<neighbors.count {
                if currentNode.dist < Int.max {
                    let index = unvisited.firstIndex(of: neighbors[i])!
                    neighbors[i].dist = min(currentNode.dist + 1, neighbors[i].dist)
                    unvisited[index].dist = neighbors[i].dist
                }
            }
            visited.append(currentNode)
            unvisited = unvisited.filter{($0.x != currentNode.x) || ($0.y != currentNode.y)}
            if let nextNode = unvisited.sorted(by: {$0.dist < $1.dist}).first {
                currentNode = nextNode
            }
        }
        
        let index = visited.firstIndex(of: end)!
        
        return visited[index].dist
    }
    
    struct Node: Equatable {
        let x: Int
        let y: Int
        let hight: Int
        var dist = Int.max
        
        func getNeighbors(nodes: [Node]) -> [Node] {
            let adjacent = nodes.filter{($0.x == x && abs($0.y - y) == 1) || ($0.y == y && abs($0.x - x) == 1)}
            return adjacent.filter{$0.hight <= (hight+1)}
        }
        
        static func == (lhs: Node, rhs: Node) -> Bool {
            return (lhs.x == rhs.x) && (lhs.y == rhs.y)
        }
    }
}
