import SwiftUI

struct OpenAIListView: View {
    @StateObject private var openAIVM = OpenAIViewModel()

    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVStack {
                        if openAIVM.messages.isEmpty {
                            OpenAIRowView(message: OpenAIMessage(role: "assistant", content: "무엇이 궁금하신가요?"))
                        } else {
                            ForEach(openAIVM.messages, id: \.content) { message in
                                OpenAIRowView(message: message)
                                    .id(message.content) // 각 메시지에 고유 ID 추가
                            }
                        }
                    }
                }
                .padding(.vertical)
                .onChange(of: openAIVM.messages.count) { _ in
                    withAnimation {
                        scrollView.scrollTo(openAIVM.messages.last?.content, anchor: .bottom)
                    }
                }
                .onAppear {
                    if openAIVM.messages.isEmpty {
                        openAIVM.messages.append(OpenAIMessage(role: "assistant", content: "무엇이 궁금하신가요?"))
                    }
                    // 초기 렌더링 시 마지막 메시지로 이동
                    DispatchQueue.main.async {
                        if let lastMessage = openAIVM.messages.last?.content {
                            scrollView.scrollTo(lastMessage, anchor: .bottom)
                        }
                    }
                }
                .onTapGesture {
                    hideKeyboard() // 키보드 숨기기
                }
            }
            
            Divider()
            HStack {
                TextField("질문을 입력하세요", text: $openAIVM.userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 40)
                
                if openAIVM.isLoading {
                    ProgressView()
                        .frame(width: 40, height: 40)
                } else {
                    Button(action: {
                        openAIVM.sendMessage()
                        hideKeyboard() // 메시지를 보낸 후 키보드 숨기기
                    }) {
//                        Text("Send")
                        Image(systemName: "paperplane.fill")
                            .padding()
                    }
                }
            }
            .padding()
        }
        .onDisappear {
            openAIVM.resetMessages()
        }
    }
}

// 키보드 숨기기 Helper
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
