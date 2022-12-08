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
    
    private func executeComands() -> Dir {
        let root = Dir(name: "/")
        var current = root
        
        for row in input {
            if row.starts(with: "$") {
                let cmd = row.split(separator: " ")
                
                switch (cmd[1]) {
                case "cd":
                    if (cmd[2] == "/") {
                        current = root
                    } else if (cmd[2] == "..") {
                        current = current.parent ?? root
                    } else {
                        let dir = current.dir(name: String(cmd[2]), parent: current)
                        current = dir
                    }
                default: //ls and unknown commands
                    continue
                }
            } else if row.starts(with: "dir") {
                let info = row.split(separator: " ")
                current.dir(name: String(info[1]), parent: current)
            } else { //File
                let info = row.split(separator: " ")
                current.file(name: String(info[1]), size: Int(info[0])!)
            }
        }
        
        return root
    }
    
    func getSolutionPart1() -> Int {
        let root = executeComands()
        
        var map = [Int : Int]()
        root.sizeMap(map: &map)
        
        return map.filter{$0.value <= 100000}.map{$0.value}.reduce(0, +)
    }
    
    func getSolutionPart2() -> Int {
        let root = executeComands()
        var map = [Int : Int]()
        root.sizeMap(map: &map)
        
        let spaceToFreeup = 30000000-(70000000-map[root.id]!)
        
        return map.values.filter{$0 > spaceToFreeup}.min()!
    }
    
    class Dir {
        static var seed = 0
        let id = getId()
        let name: String
        let parent: Dir?
        var files: [File]
        var dirs: [Dir]
        
        init(name: String, parent: Dir? = nil) {
            self.name = name
            self.parent = parent
            self.files = [File]()
            self.dirs = [Dir]()
        }
        
        func sizeMap(map: inout [Int:Int]){
            var size = 0
            for dir in dirs {
                dir.sizeMap(map: &map)
            }
            
            for dir in dirs {
                size += map[dir.id]!
            }
            
            map[id] = size + files.map{$0.size}.reduce(0,+)
        }
        
        func dir(name: String, parent: Dir) -> Dir {
            if let d = dirs.filter({$0.name == name}).first {
                return d
            } else {
                let dir = Dir(name: name, parent: parent)
                dirs.append(dir)
                return dir
            }
        }
        
        func file(name: String, size: Int) {
            if files.filter({$0.name == name}).first == nil {
                files.append(File(name: name, size: size))
            }
        }
        
        static func getId() -> Int {
            seed += 1
            return seed
        }
    }
    
    struct File {
        let name: String
        let size: Int
    }
}
