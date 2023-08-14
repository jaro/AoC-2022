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
    
    func parseMsgs() -> [Msg] {
        var msgs = [Msg]()
        var count = 1
        
        for i in stride(from: 0, to: input.count, by: 3) {
            let left = input[i]
            let right = input[i+1]
            
            let leftMsg = parseMsg(msgString: left)
            let rightMsg = parseMsg(msgString:right)
            
            msgs.append(Msg(index: count, leftPart: leftMsg, rightPart: rightMsg))
            count += 1
        }
        
        return msgs
    }
    
    func parseAllMsgs() -> [MsgContainer] {
        var msgs = [MsgContainer]()
        
        for row in input {
            if !row.isEmpty {
                let msg = parseMsg(msgString: row)
                msgs.append(MsgContainer(msg: msg, msgString: row))
            }
        }
        
        return msgs
    }
    
    func parseMsg(msgString: String) -> List {
        var stack = Stack<List>()
        var number = ""
        var current: List?
        
        for char in msgString {
            if char == "[" {
                if current != nil {
                    stack.push(current!)
                }
                current = List()
            } else if char.isNumber {
                number += String(char)
            } else if char == "," {
                if let numb = Int(number) {
                    let value = Value(val: numb)
                    current?.add(value)
                }
                number = ""
            } else if char == "]" {
                if let numb = Int(number) {
                    let value = Value(val: numb)
                    current?.add(value)
                }
                number = ""
                
                if !stack.isEmpty() {
                    let parent = stack.pop()
                    parent.add(current!)
                    current = parent
                }
            }
        }
        
        return current!
    }
    
    enum Order {
        case RIGHT, NOT_RIGHT, CONTINUE
    }
    
    func isRightOrder(leftPart: Part, rightPart: Part) -> Order {
        if (type(of: leftPart) == Value.self && type(of: rightPart) == Value.self) {
            let leftValue = (leftPart as! Value).val
            let rightValue = (rightPart as! Value).val
            
            if (leftValue < rightValue) {
                return .RIGHT
            } else if (leftValue > rightValue) {
                return .NOT_RIGHT
            }
        } else if (type(of: leftPart) == List.self && type(of: rightPart) == List.self) {
            let leftList = (leftPart as! List).parts
            let rightList = (rightPart as! List).parts
            
            for i in 0..<min(leftList.count, rightList.count) {
                let result = isRightOrder(leftPart: leftList[i], rightPart: rightList[i])
                if  result != .CONTINUE {
                    return result
                }
            }
            
            if leftList.count < rightList.count {
                return .RIGHT
            } else if leftList.count > rightList.count {
                return .NOT_RIGHT
            }
        } else {
            if (type(of: leftPart) == Value.self) {
                let leftPart = List(val: leftPart as! AoC.Value)
                
                let result = isRightOrder(leftPart: leftPart, rightPart: rightPart)
                if  result != .CONTINUE {
                    return result
                }
            } else if (type(of: rightPart) == Value.self) {
                let rightPart = List(val: rightPart as! AoC.Value)
                
                let result = isRightOrder(leftPart: leftPart, rightPart: rightPart)
                if  result != .CONTINUE {
                    return result
                }
            }
        }
    
        return .CONTINUE
    }
    
    func getSolutionPart1() -> Int {
        var indexSum = 0
        let msgs = parseMsgs()
        
        for msg in msgs {
            let result = isRightOrder(leftPart: msg.leftPart, rightPart: msg.rightPart)
            if result == .RIGHT {
                print("Message \(msg.index) is correct")
                indexSum += msg.index
            } else if (result == .CONTINUE) {
                print("Message \(msg.index) is correct - WITH CONTINUE")
                indexSum += msg.index
            } else {
                print("Message \(msg.index) is NOT correct")
            }
        }
        
        return indexSum
    }
    
    func getSolutionPart2() -> Int {
        var msgs = parseAllMsgs()
        let div1 = "[[2]]"
        let div2 = "[[6]]"
        msgs.append(MsgContainer(msg: parseMsg(msgString: div1), msgString: div1) )
        msgs.append(MsgContainer(msg: parseMsg(msgString: div2), msgString: div2) )
        
        msgs.sort{isRightOrder(leftPart: $0.msg, rightPart: $1.msg) == .RIGHT}
        
        let div1Index = msgs.firstIndex{$0.msgString == div1}! + 1
        let div2Index = msgs.firstIndex{$0.msgString == div2}! + 1
        
        return div1Index * div2Index
    }
    
    class Part {
        
    }
    
    class Value: Part {
        let val: Int
        
        init(val: Int) {
            self.val = val
        }
    }
    
    class List: Part {
        var parts = [Part]()
        
        override init() {}
        
        init(val: Value) {
            parts.append(val)
        }
        
        func add(_ part: Part) {
            parts.append(part)
        }
    }
    
    struct Msg {
        let index: Int
        let leftPart: Part
        let rightPart: Part
    }
    
    struct MsgContainer {
        let msg: Part
        let msgString: String
    }
}
