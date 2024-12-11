//
//  ChatbotView.swift
//  AcademyLifeFE
//
//  Created by SeYeong's MacBook on 12/11/24.
//

import SwiftUI

struct ChatbotView: View {
    @EnvironmentObject var chatbotVM: ChatbotViewModel
    @State var userInput = ""
   
    var body: some View {
        VStack {
                   ScrollView {
                       ForEach(chatbotVM.messages, id:\.id) { message in
                           HStack {
                               if message.role == "user" {
                                   
                                   VStack{
                                       Spacer()
                                       Text("User: \(message.content)")
                                           .padding()
                                           .background(Color.blue)
                                           .foregroundColor(.white)
                                           .cornerRadius(10)
                                           .padding(.horizontal)
                                   }.frame(maxWidth: .infinity)
                               } else {
                                   VStack(alignment: .leading) {
                                       Text("Assistant: \(message.content)")
                                           .padding()
                                           .background(Color.green)
                                           .foregroundColor(.white)
                                           .cornerRadius(10)
                                           .padding(.horizontal)
                                   }
                               }
                           }
                           .padding(.vertical, 4)
                       }
                   }
                   
                   HStack {
                       TextField("Type your message...", text: $userInput)
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                           .padding()
                       
                       Button(action: {
                           // 사용자가 메시지 보내면, 메시지를 전송
                           chatbotVM.sendMessage(content: userInput)
                           userInput = "" // 메시지 전송 후 입력창 비우기
                       }) {
                           Text("Send")
                               .padding()
                               .background(Color.accentDark)
                               .foregroundColor(.white)
                               .cornerRadius(10)
                       }
                   }
                   .padding()
               }
    }
}

#Preview {
    ChatbotView()
        .environmentObject(ChatbotViewModel())
}
