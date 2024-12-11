//
//  ChatbotViewModel.swift
//  AcademyLifeFE
//
//  Created by SeYeong's MacBook on 12/11/24.
//

import SwiftUI
import Alamofire

class ChatbotViewModel: ObservableObject {
    @Published var messages: [Message] = []
    
    let host = AppConfig.azureOpenAIDomain
    let token = AppConfig.apiKeyAzureOpenAI
    
    func sendMessage(content: String) {
        let url = "https://\(host)"
        let messages: [[String: String]] = [
                   ["role": "user", "content": content]
               ]
               
               let params: Parameters = [
                   "messages": messages,
                   "max_tokens": 100
               ]
        let headers: HTTPHeaders = [
            "api-key": "\(token)",
            "Content-Type": "application/json"
        ]
       
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                    .responseDecodable(of: ChatbotRoot.self) { response in
                        print("리스폰스", response)
                        switch response.result {
                        case .success(let root):
                            print("루트", root)
                            // 응답 받은 내용에서 assistant의 메시지를 추출하여 업데이트
                            if let assistantMessage = root.choices.first?.message.content {
                                DispatchQueue.main.async {
                                    
                                    // 사용자 메시지와 챗봇의 답변을 배열에 추가
                                    self.messages.append(Message(role: "user", content: content))
                                    self.messages.append(Message(role: "assistant", content: assistantMessage))
                                }
                            }
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                        }
                    }
            }
    
//        AF.request(url, method: .post, parameters: params,encoding: JSONEncoding.default, headers: headers)
//            .responseDecodable(of: ChatbotQuestionRoot.self) { response in
//                print("리스폰스" ,response)
//                switch response.result {
//                case .success(let root):
//                    print(root)
//                    print("강좌 추가 성공")
//                case .failure(let error):
//                    print(error.localizedDescription)
//     
//                    
//                }
//            }
    }

