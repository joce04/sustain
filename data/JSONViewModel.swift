//
//  JSONViewModel.swift
//  Sustain
//
//  Created by Jocelyn Zhao on 2022-01-21.
//

import SwiftUI

class JSONViewModel: ObservableObject {
    @Published var habits: [HabitModel] = []
    @Published var topics: [TopicModel] = []
    
    init() {
        self.habits = Bundle.main.decode("habits.json")
        self.topics = Bundle.main.decode("topics.json")
    }
}

struct HabitModel: Codable, Hashable {
    var name: String
    var section: String
    var information: String
    var points: Int
    var special: Bool
}

struct TopicModel: Codable, Hashable {
    var name: String
    var progress: Int
    var symbol: String
    var goal: Int
}
