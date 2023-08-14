//
//  File.swift
//  
//
//  Created by Jakob Rönstrom on 2022-12-06.
//

import Foundation

struct Stack<T> {
    private var items: [T] = []
    
    func peek() -> T {
        guard let topElement = items.first else { fatalError("This stack is empty.") }
        return topElement
    }
    
    mutating func pop() -> T {
        return items.removeFirst()
    }
    
    mutating func pop(_ numb: Int) -> [T] {
        return (0..<numb).map{_ in items.removeFirst()}.reversed()
    }
  
    mutating func push(_ element: T) {
        items.insert(element, at: 0)
    }
    
    mutating func push(_ elements: [T]) {
        items.insert(contentsOf: elements, at: 0)
    }
}
