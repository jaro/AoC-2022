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
    
    func getSolutionPart1() -> Int {
        var visitedPos = Set<Pos>()
        var head = Pos(x: 0, y: 0)
        var tail = Pos(x: 0, y: 0)
        
        visitedPos.insert(tail)
        
        for cmds in input {
            let cmd = cmds.split(separator: " ")
            var move = Pos(x: 0, y: 0)
            switch cmd[0] {
            case "R":
                move.x = 1
            case "L":
                move.x = -1
            case "U":
                move.y = 1
            case "D":
                move.y = -1
            default:
                print("Unknown move")
            }
            
            for _ in 0..<Int(cmd[1])! {
                head.move(move: move)
                let tailMove = calcTailPosition(tail: tail, head: head)
                tail.move(move: tailMove)
                visitedPos.insert(tail)
            }
        }
        
        return visitedPos.count
    }
    
    func calcTailPosition(tail: Pos, head: Pos) -> Pos {
        if (head.x == tail.x) && abs(head.y-tail.y) >= 2 { //same column
            return Pos(x: 0, y: head.y > tail.y ? 1 : -1)
        }
        
        if (head.y == tail.y) && abs(head.x-tail.x) >= 2 { //same row
            return Pos(x: head.x > tail.x ? 1 : -1, y: 0)
        }
        
        if (abs(head.x-tail.x) >= 2 && (head.y != tail.y)) || (abs(head.y-tail.y) >= 2 && (head.x != tail.x)) {
            return Pos(x: head.x > tail.x ? 1 : -1, y: head.y > tail.y ? 1 : -1)
        }
        
        return Pos(x: 0, y: 0)
    }
    
    func getSolutionPart2() -> Int {
        var visitedPos = Set<Pos>()
        var rope = [Pos]()
        
        for _ in 0...9 {
            let pos = Pos(x: 0, y: 0)
            rope.append(pos)
        }
        
        visitedPos.insert(rope[9])
        
        for cmds in input {
            let cmd = cmds.split(separator: " ")
            var move = Pos(x: 0, y: 0)
            switch cmd[0] {
            case "R":
                move.x = 1
            case "L":
                move.x = -1
            case "U":
                move.y = 1
            case "D":
                move.y = -1
            default:
                print("Unknown move")
            }
            
            for _ in 0..<Int(cmd[1])! {
                rope[0].move(move: move)
                var tailMove = Pos(x: 0, y: 0)
                for i in 1..<rope.count {
                    tailMove = calcTailPosition(tail: rope[i], head: rope[i-1])
                    rope[i].move(move: tailMove)
                }
                
                visitedPos.insert(rope[9])
            }
        }
        
        return visitedPos.count
    }
    
    struct Pos: Hashable {
        var x: Int
        var y: Int
        
        mutating func move(move: Pos) {
            x += move.x
            y += move.y
        }
    }
}
