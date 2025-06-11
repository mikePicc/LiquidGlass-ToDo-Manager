//
//  Item.swift
//  Daily GamePlays
//
//  Created by Michael Piccerillo on 6/9/25.
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
