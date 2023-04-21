//
//  Border.swift
//  Aquarium
//
//  Created by Quan Teng Foong on 19/4/23.
//

import Foundation

struct Border {
    var left: BorderCases
    var right: BorderCases
    var top: BorderCases
    var bottom: BorderCases
    
    init(left: BorderCases = .n,
         right: BorderCases = .n,
         top: BorderCases = .n,
         bottom: BorderCases = .n) {
        self.left = left
        self.right = right
        self.top = top
        self.bottom = bottom
    }
}
