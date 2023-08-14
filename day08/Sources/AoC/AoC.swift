import Foundation

@main
public struct AoC {
    let input: [[Int]]
    
    init(_ data: [[Int]]) { self.input = data }
    
    public static func main() {
        let part = ProcessInfo.processInfo.environment["part"] ?? "part1"
        let input = parse(file: "input.txt")
        
        if part == "part2" {
            print(AoC(input).getSolutionPart2())
        } else  {
            print(AoC(input).getSolutionPart1())
        }
    }
    
    static func parse(file filename: String) -> [[Int]] {
        guard let content = try? String(contentsOfFile: filename) else {fatalError("Error parsing file \(filename)")}
        let rows = content.components(separatedBy: .newlines).filter{!$0.isEmpty}.compactMap{$0}
        
        var grid = [[Int]]()
        
        for i in 0..<rows.count {
            var gridRow = [Int]()
            for c in rows[i] {
                gridRow.append(Int(String(c))!)
            }
            
            grid.append(gridRow)
        }
        
        return grid
    }
    
    func getSolutionPart1() -> Int {
        var visibleTrees = Set<Tree>()
        
        for y in 0..<input.count {
            visibleTrees.insert(Tree(x: 0,y: y))
            visibleTrees.insert(Tree(x: input[y].count-1,y: y))
        }
        
        for x in 0..<input[0].count {
            visibleTrees.insert(Tree(x: x,y: 0))
            visibleTrees.insert(Tree(x: x,y: input.count-1))
        }
        
        for y in 1..<(input.count-1) { // row 1 to 3
            var top = input[y][0]
            for x in 1..<input[y].count { // column 1 to 4
                if input[y][x] > top {
                    visibleTrees.insert(Tree(x: x, y: y))
                    top = max(input[y][x], top)
                }
            }
            top = input[y][input[y].count-1]
            for x in stride(from: (input[y].count-2), through: 0, by: -1) { // column 3 to 0
                if input[y][x] > top {
                    visibleTrees.insert(Tree(x: x, y: y))
                    top = max(input[y][x], top)
                }
            }
        }
        for x in 1..<(input[0].count-1) { // column 1 to 3
            var top = input[0][x]
            for y in 1..<input.count { // row 1 to 4
                if input[y][x] > top {
                    visibleTrees.insert(Tree(x: x, y: y))
                    top = max(input[y][x], top)
                }
            }
            top = input[input.count-1][x]
            for y in stride(from: (input.count-2), through: 0, by: -1) { // row 3 to 0
                if input[y][x] > top {
                    visibleTrees.insert(Tree(x: x, y: y))
                    top = max(input[y][x], top)
                }
            }
        }
        
        return visibleTrees.count
    }
    
    func getSolutionPart2() -> Int {
        var maxScore = 0
        
        for y in 0..<input.count {
            for x in 0..<input[y].count {
                maxScore = max(sonicScore(tree: Tree(x: x, y: y)), maxScore)
            }
        }
        
        return maxScore
    }
    
    func sonicScore(tree: Tree) -> Int {
        let up = getSpaceUp(tree: tree)
        let left = getSpaceLeft(tree: tree)
        let right = getSpaceRight(tree: tree)
        let down = getSpaceDown(tree: tree)
        
        return up * left * right * down
    }
    
    func getSpaceRight(tree: Tree) -> Int {
        var space = 0
        let width = input.count
        
        for x in (tree.x+1)..<width {
            if input[tree.y][x] < input[tree.y][tree.x] {
                space += 1
            } else {
                space += 1
                break
            }
        }
        
        return space
    }
    
    func getSpaceLeft(tree: Tree) -> Int {
        var space = 0
        
        for x in stride(from: tree.x-1, through: 0, by: -1) {
            if input[tree.y][x] < input[tree.y][tree.x] {
                space += 1
            } else {
                space += 1
                break
            }
        }
        
        return space
    }
    
    func getSpaceDown(tree: Tree) -> Int {
        var space = 0
        let heigh = input[0].count
        
        for y in (tree.y+1)..<heigh {
            if input[y][tree.x] < input[tree.y][tree.x] {
                space += 1
            } else {
                space += 1
                break
            }
        }
        
        return space
    }
    
    func getSpaceUp(tree: Tree) -> Int {
        var space = 0
        
        for y in stride(from: tree.y-1, through: 0, by: -1) {
            if input[y][tree.x] < input[tree.y][tree.x] {
                space += 1
            } else {
                space += 1
                break
            }
        }
        
        return space
    }
    
    struct Tree: Hashable {
        let x: Int
        let y: Int
    }
}
