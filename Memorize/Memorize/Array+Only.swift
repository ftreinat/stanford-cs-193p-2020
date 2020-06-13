//
//  Array+Only.swift
//  Memorize
//
//  Created by Florian Treinat on 13.06.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
