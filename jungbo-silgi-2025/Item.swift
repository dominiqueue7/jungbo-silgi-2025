//
//  Item.swift
//  jungbo-silgi-2025
//
//  Created by DOMINIQUE on 6/13/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
