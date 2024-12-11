import Foundation

// 최상단 구조
struct OpenAIRoot<T: Codable>: Codable {
    let success: Bool
    let documents: T
    let message: String
}

// OpenAIMessage 모델
struct OpenAIMessage: Codable {
    let role: String
    let content: String
}

// OpenAIRequest 모델
struct OpenAIRequest: Codable {
    let messages: [OpenAIMessage]
}

// OpenAIResponse 내부 구조
struct OpenAIResponse: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let role: String
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}
