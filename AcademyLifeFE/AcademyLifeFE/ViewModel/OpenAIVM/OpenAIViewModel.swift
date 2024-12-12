import Foundation
import Alamofire
import SwiftUI

class OpenAIViewModel: ObservableObject {
    @AppStorage("token") var token: String?
    @AppStorage("userID") var userID: String?
    @Published var messages: [OpenAIMessage] = []
    @Published var userInput: String = ""
    @Published var isChatLoading: Bool = false
    
    private let nodeServerURL = "\(AppConfig.baseURL)/openai"

    func sendMessage() {
        guard let token else { return }
        guard !userInput.isEmpty else { return }

        // Append user message
        let userMessage = OpenAIMessage(role: "user", content: userInput)
        messages.append(userMessage)
        userInput = ""
        isChatLoading = true

        // Prepare request data
        let requestData = OpenAIRequest(messages: messages)

        let headers: HTTPHeaders = [
            "Authorization": "\(token)"
        ]

        AF.request(nodeServerURL,
                   method: .post,
                   parameters: requestData,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
            .validate()
            .responseDecodable(of: OpenAIRoot<OpenAIResponse>.self) { [weak self] response in
                DispatchQueue.main.async {
                    self?.isChatLoading = false
                    switch response.result {
                    case .success(let result):
                        if let assistantMessage = result.documents.choices.first?.message {
                            self?.messages.append(OpenAIMessage(role: assistantMessage.role, content: assistantMessage.content))
                        }
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
    }

    func resetMessages() {
        messages = []
    }
}
