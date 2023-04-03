//
//  ButtonConfiguration.swift
//  garnify_ios
//
//  Created by thermeto_home on 01.04.2023.
//

import Foundation

struct ButtonConfiguration: Hashable {
    let title: String
    var action: (() -> Void)? = nil
    let frameWidth: CGFloat
    var value: Any? = nil

    static func == (lhs: ButtonConfiguration, rhs: ButtonConfiguration) -> Bool {
        return lhs.title == rhs.title
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
