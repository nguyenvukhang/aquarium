//
//  Constants.swift
//  Aquarium
//
//  Created by Quan Teng Foong on 19/4/23.
//

import Foundation

enum BorderCases {
    case n, t, T
}

enum Constants {
    static let map: [BorderCases: [BorderCases: [BorderCases: [BorderCases: String]]]]
        = [.n: [.n: [.n: [.n: "",
                          .t: "",
                          .T: ""],
                     .t: [.n: "",
                          .t: "┐",
                          .T: "┑"],
                     .T: [.n: "",
                          .t: "┒",
                          .T: "┓"]],
                .t: [.n: [.n: "",
                          .t: "─",
                          .T: ""],
                     .t: [.n: "┌",
                          .t: "┬",
                          .T: "┍"],
                     .T: [.n: "┎",
                          .t: "┰",
                          .T: "┱"]],
                .T: [.n: [.n: "",
                          .t: "",
                          .T: "━"],
                     .t: [.n: "┍",
                          .t: "┮",
                          .T: "┯"],
                     .T: [.n: "┏",
                          .t: "┲",
                          .T: "┳"]]],
           .t: [.n: [.n: [.n: "",
                          .t: "┘",
                          .T: "┙"],
                     .t: [.n: "│",
                          .t: "┤",
                          .T: "┥"],
                     .T: [.n: "",
                          .t: "┧",
                          .T: "┪"]],
                .t: [.n: [.n: "└",
                          .t: "┴",
                          .T: "┵"],
                     .t: [.n: "├",
                          .t: "┼",
                          .T: "┽"],
                     .T: [.n: "┟",
                          .t: "╁",
                          .T: "╅"]],
                .T: [.n: [.n: "┕",
                          .t: "┶",
                          .T: "┷"],
                     .t: [.n: "┝",
                          .t: "┾",
                          .T: "┿"],
                     .T: [.n: "┢",
                          .t: "╆",
                          .T: "╈"]]],
           .T: [.n: [.n: [.n: "",
                          .t: "┚",
                          .T: "┛"],
                     .t: [.n: "",
                          .t: "┦",
                          .T: "┩"],
                     .T: [.n: "┃",
                          .t: "┨",
                          .T: "┫"]],
                .t: [.n: [.n: "┖",
                          .t: "┸",
                          .T: "┹"],
                     .t: [.n: "┞",
                          .t: "╀",
                          .T: "╃"],
                     .T: [.n: "┠",
                          .t: "╂",
                          .T: "╉"]],
                .T: [.n: [.n: "┗",
                          .t: "┺",
                          .T: "┻"],
                     .t: [.n: "┡",
                          .t: "╄",
                          .T: "╇"],
                     .T: [.n: "┣",
                          .t: "╊",
                          .T: "╋"]]]]

    static func getUnicode(for border: Border) -> String? {
        guard let symbol = Constants.map[border.top]?[border.right]?[border.bottom]?[border.left] else {
            return nil
        }
        return symbol
    }
}
