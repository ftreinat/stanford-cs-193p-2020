//
//  Array+Identifable.swift
//  Memorize
//
//  Created by Florian Treinat on 12.06.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
}
