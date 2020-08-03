//
//  Color+RGB.swift
//  Memorize
//
//  Created by Florian Treinat on 03.08.20.
//  Copyright © 2020 Florian Treinat. All rights reserved.
//

import SwiftUI

extension Color {
    init(_ rgb: UIColor.RGB) {
        self.init(UIColor(rgb))
    }
}
