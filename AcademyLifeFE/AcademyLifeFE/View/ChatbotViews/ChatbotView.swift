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
        ZStack {
            VStack {
                PageHeading(title: "AI 학습 도우미", bottomPaddng: 16)
                
                ScrollViewReader { proxy in
                    ScrollView {
                        Color.clear
                            .frame(height: 1)
                            .id("top")
                        
                        VStack {
                            Text("학습 중에 궁금한 점이 생기면 AI 학습 도우미에게 물어보세요.\n대화 내용은 앱이 종료되면 사라집니다.")
                                .foregroundColor(.timiBlackLight)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 16)
                            
                            ForEach(chatbotVM.messages, id:\.id) { message in
                                VStack(spacing: 4) {
                                    VStack {
                                        HStack {
                                            if message.role == "user" {
                                                VStack{
                                                    ChatbotSpeechView(text: message.content)
                                                        .id(message)
                                                }
                                            } else {
                                                VStack{
                                                    ChatbotSpeechView(text: message.content, role: .agent)
                                                        .id(message)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .onTapGesture {
                        dismissKeyboard()
                    }
                    .onChange(of: chatbotVM.messages) { _ in
                        if let lastSpeech = chatbotVM.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastSpeech, anchor: .bottom)
                            }
                        }
                    }
                    .onAppear { // 챗봇 뷰를 나갔다가 다시 들어오면 페이지 최상단으로 갔다가 밑으로 내려오기
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            if let lastSpeech = chatbotVM.messages.last {
                                withAnimation {
                                    proxy.scrollTo(lastSpeech, anchor: .bottom)
                                }
                            }
                        }
                    }
                    .onDisappear {
                        proxy.scrollTo("top", anchor: .top)
                    }
                }
                
                // 텍스트 필드 + 보내기 버튼 + 음성 녹음 버튼
                HStack(spacing: 0) {
                    HStack {
                        TextField("질문을 입력해주세요.", text: $userInput)
                            .font(.system(size: 16))
                            .onSubmit {
                                chatbotVM.sendMessage(content: userInput)
                                resetTextField()
                            }
                        
                        Button {
                            chatbotVM.sendMessage(content: userInput)
                            resetTextField()
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16, height: 16)
                                .padding(8)
                                .foregroundStyle(.white)
                                .background(userInput.isEmpty ? .timiGray : .accent)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .disabled(userInput.isEmpty || chatbotVM.isProcessing)
                        
                    }
                    .padding(8)
                    .foregroundStyle(.timiBlack)
                    .background(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.timiGray.opacity(0.5), lineWidth: 2)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    Button {
                        if !chatbotVM.isProcessing {
                            chatbotVM.toggleRecording()
                            resetTextField()
                        }
                    } label: {
                        Image(systemName: !chatbotVM.isRecording ? "microphone.fill" : "microphone.badge.xmark.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding(.vertical, 14)
                            .padding(.leading, !chatbotVM.isRecording ? 14 : 16)
                            .padding(.trailing, !chatbotVM.isRecording ? 14 : 12)
                            .foregroundColor(!chatbotVM.isRecording ? .accent : .timiRed)
                            .background(!chatbotVM.isRecording ? .accentLight : .timiRed.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(8)
                    }
                    .disabled(chatbotVM.isProcessing)
                }
                .padding()
            }
        }
    }
    
    func resetTextField() {
        userInput = "" // 메시지 전송 후 입력창 비우기
        dismissKeyboard()
    }
}

#Preview {
    ChatbotView()
        .environmentObject(ChatbotViewModel())
}
