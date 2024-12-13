//
//  ChatbotSpeechView.swift
//  AcademyLifeFE
//
//  Created by 서희재 on 12/12/24.
//

import SwiftUI

struct ChatbotSpeechView: View {
    @EnvironmentObject var chatbotVM: ChatbotViewModel
    
    var text = ""
    var role: ChatbotRole = .user
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if role == .user {
                    CustomSpacer()
                }
                
                Text(text)
                    .font(.system(size: 16))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(role == .user ? .accent : .timiTextField)
                    .foregroundColor(role == .user ? .white : .timiBlack)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(maxWidth: .infinity, alignment: role == .user ? .trailing : .leading)
                
                if role == .agent {
                    CustomSpacer()
                }
            }
            
            if role == .agent {
                if chatbotVM.isPlaying {
                    Button {
                        chatbotVM.stopAudio()
                    } label: {
                        Image(systemName: "stop.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.accent)
                    }
                } else {
                    Button {
                        chatbotVM.convertTextToSpeech(text: text)
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.accent)
                    }
                    .onAppear {
                        chatbotVM.isPlaying = false
                        chatbotVM.isProcessing = false
                    }
                }
            }
            
        }
        .padding(.horizontal)
    }
    
    enum ChatbotRole {
        case user
        case agent
    }
}

#Preview {
    ChatbotSpeechView(text: "How", role: .user)
        .environmentObject(ChatbotViewModel())
    ChatbotSpeechView(text: "If", role: .agent)
        .environmentObject(ChatbotViewModel())
}
