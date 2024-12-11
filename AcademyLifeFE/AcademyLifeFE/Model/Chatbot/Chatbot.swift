//
//  Chatbot.swift
//  AcademyLifeFE
//
//  Created by SeYeong's MacBook on 12/11/24.
//

import SwiftUI

struct Message: Codable {
    let id = UUID()
    let role: String
    let content: String
}

struct ChatbotAnswer: Codable {
    let message: Message
}

struct ChatbotRoot: Codable {
    let choices: [ChatbotAnswer]
}

