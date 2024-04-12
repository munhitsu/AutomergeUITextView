//
//  Item.swift
//  AutomergeUITextView
//
//  Created by Mateusz Łapsa-Malawski on 12/04/2024.
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
