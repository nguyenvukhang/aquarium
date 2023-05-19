//
//  Sortable.swift
//  
//
//  Created by Quan Teng Foong on 19/5/23.
//

import Foundation

public struct Sortable<T> {
    public var value: T
    public var priority: Int
    
    init(_ t: T.Type, value: T, priority: Int = 0) {
        self.value = value
        self.priority = priority
    }
}
