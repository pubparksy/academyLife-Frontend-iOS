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
            Text("수호천사 티미ㅋㅋ")
                .padding(.top, 20)
            
            ScrollView {
                Text("질문을 시작해주세요.")
                    .font(.headline)
                    .foregroundColor(.gray)
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
                                HStack {
                                    Text("Assistant: \(message.content)")
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                    if chatbotVM.isPlaying {
                                        Button(action: {
                                            chatbotVM.stopAudio()
                                        }) {
                                            Text("Stop")
                                                .padding()
                                                .background(Color.green)
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                        }
                                        } else {
                                            
                                        Button(action: {
                                            chatbotVM.convertTextToSpeech(text: message.content)
                                            
                                        }) {
                                            Image(systemName: "speaker.wave.2.fill")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor( .green)
                                                .padding()
                                        }.onAppear {
                                            chatbotVM.isPlaying = false
                                            chatbotVM.isProcessing = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                
            }
            
            //텍스트 필드 + 보내기 버튼 + 음성 녹음 버튼
            HStack {
                TextField("티미에게 질문해보세요!", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack {
                    Button(action: {
                        chatbotVM.sendMessage(content: userInput)
                        userInput = "" // 메시지 전송 후 입력창 비우기
                    }) {
                        Text("Send")
                            .padding()
                            .background(Color.accentDark)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(userInput.isEmpty || chatbotVM.isProcessing)
                    
                   Button(action: {
                        if !chatbotVM.isProcessing {
                            chatbotVM.toggleRecording()
                        }
                        
                    }) {
                        VStack(spacing:10){
                            Image(systemName: chatbotVM.isRecording ? "stop.circle" : "mic.circle")
                                .font(.system(size: 60))
                                .foregroundColor(chatbotVM.isRecording ? .red : .blue)
                        }
                    }
                }
                .padding()
                .disabled(chatbotVM.isProcessing)
                
            }
            .padding()
        }
    }
}

#Preview {
    ChatbotView()
        .environmentObject(ChatbotViewModel())
}
