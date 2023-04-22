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
                          .t: "\u{2510}",
                          .T: "\u{2511}"],
                     .T: [.n: "",
                          .t: "\u{2512}",
                          .T: "\u{2513}"]],
                .t: [.n: [.n: "",
                          .t: "\u{2500}",
                          .T: ""],
                     .t: [.n: "\u{250C}",
                          .t: "\u{252C}",
                          .T: "\u{250D}"],
                     .T: [.n: "\u{250E}",
                          .t: "\u{2530}",
                          .T: "\u{2531}"]],
                .T: [.n: [.n: "",
                          .t: "",
                          .T: "\u{2501}"],
                     .t: [.n: "\u{250D}",
                          .t: "\u{252E}",
                          .T: "\u{252F}"],
                     .T: [.n: "\u{250F}",
                          .t: "\u{2532}",
                          .T: "\u{2533}"]]],
           .t: [.n: [.n: [.n: "",
                          .t: "\u{2518}",
                          .T: "\u{2519}"],
                     .t: [.n: "\u{2502}",
                          .t: "\u{2524}",
                          .T: "\u{2525}"],
                     .T: [.n: "",
                          .t: "\u{2527}",
                          .T: "\u{252A}"]],
                .t: [.n: [.n: "\u{2514}",
                          .t: "\u{2534}",
                          .T: "\u{2535}"],
                     .t: [.n: "\u{251C}",
                          .t: "\u{253C}",
                          .T: "\u{253D}"],
                     .T: [.n: "\u{251F}",
                          .t: "\u{2541}",
                          .T: "\u{2545}"]],
                .T: [.n: [.n: "\u{2515}",
                          .t: "\u{2536}",
                          .T: "\u{2537}"],
                     .t: [.n: "\u{251D}",
                          .t: "\u{253E}",
                          .T: "\u{253F}"],
                     .T: [.n: "\u{2522}",
                          .t: "\u{2546}",
                          .T: "\u{2548}"]]],
           .T: [.n: [.n: [.n: "",
                          .t: "\u{251A}",
                          .T: "\u{251B}"],
                     .t: [.n: "",
                          .t: "\u{2526}",
                          .T: "\u{2529}"],
                     .T: [.n: "\u{2503}",
                          .t: "\u{2528}",
                          .T: "\u{252B}"]],
                .t: [.n: [.n: "\u{2516}",
                          .t: "\u{2538}",
                          .T: "\u{2539}"],
                     .t: [.n: "\u{251E}",
                          .t: "\u{2540}",
                          .T: "\u{2543}"],
                     .T: [.n: "\u{2520}",
                          .t: "\u{2542}",
                          .T: "\u{2549}"]],
                .T: [.n: [.n: "\u{2517}",
                          .t: "\u{253A}",
                          .T: "\u{253B}"],
                     .t: [.n: "\u{2521}",
                          .t: "\u{2544}",
                          .T: "\u{2547}"],
                     .T: [.n: "\u{2523}",
                          .t: "\u{254A}",
                          .T: "\u{254B}"]]]]

    static func getUnicode(for border: Border) -> String? {
        guard let symbol = Constants.map[border.top]?[border.right]?[border.bottom]?[border.left] else {
            return nil
        }
        return symbol
    }
}
