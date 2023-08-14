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
        let scoreMap = ["a":1,"b":2,"c":3,"d":4,"e":5,"f":6,"g":7,"h":8,"i":9,"j":10,"k":11,"l":12,"m":13,"n":14,"o":15,"p":16,"q":17,"r":18,"s":19,"t":20,"u":21,"v":22,"w":23,"x":24,"y":25,"z":26,"A":27,"B":28,"C":29,"D":30,"E":31,"F":32,"G":33,"H":34,"I":35,"J":36,"K":37,"L":38,"M":39,"N":40,"O":41,"P":42,"Q":43,"R":44,"S":45,"T":46,"U":47,"V":48,"W":49,"X":50,"Y":51,"Z":52]
        var diff = [String.Element]()
        for row in input {
            let halfindex = row.index(row.startIndex, offsetBy: row.count/2)
            
            let part1 = row.substring(to: halfindex)
            let part2 = row.substring(from: halfindex)
            
            let d = Set(part1).intersection(part2)
            diff.append(contentsOf: d)
        }
        var score = 0
        for c in diff {
            score += scoreMap[String(c)]!
        }
        
        return score
    }
    
    func getSolutionPart2() -> Int {
        let scoreMap = ["a":1,"b":2,"c":3,"d":4,"e":5,"f":6,"g":7,"h":8,"i":9,"j":10,"k":11,"l":12,"m":13,"n":14,"o":15,"p":16,"q":17,"r":18,"s":19,"t":20,"u":21,"v":22,"w":23,"x":24,"y":25,"z":26,"A":27,"B":28,"C":29,"D":30,"E":31,"F":32,"G":33,"H":34,"I":35,"J":36,"K":37,"L":38,"M":39,"N":40,"O":41,"P":42,"Q":43,"R":44,"S":45,"T":46,"U":47,"V":48,"W":49,"X":50,"Y":51,"Z":52]
        var badges = [String.Element]()
        
        for i in stride(from: 0, through: input.count-1, by: 3) {
            let diff = Set(input[i]).intersection(Set(input[i+1])).intersection(Set(input[i+2]))
            badges.append(contentsOf: diff)
        }
        var score = 0
        for c in badges {
            score += scoreMap[String(c)]!
        }
        
        return score
    }
}
