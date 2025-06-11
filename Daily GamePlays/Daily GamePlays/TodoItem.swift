//
//  TodoItem.swift
//  Daily GamePlays
//
//  Created by Michael Piccerillo on 6/10/25.
//

import Foundation
import SwiftUI

struct TodoItem: Identifiable, Equatable {
    let id = UUID()
    let text: String
    var isCompleted: Bool = false
    let createdAt = Date()
    
    //for future features
    var priority: Priority = .normal
    var dueDate: Date?
}

enum Priority: String, CaseIterable {
    case low = "green"
    case normal = "blue"
    case high = "red"

    var color: Color {
        switch self {
        case .low: return .green
        case .normal: return .blue
        case .high: return .red
        }
    }
}
