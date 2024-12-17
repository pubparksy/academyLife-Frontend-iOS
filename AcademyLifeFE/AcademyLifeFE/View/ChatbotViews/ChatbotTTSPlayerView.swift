//
//  ChatbotTTSPlayerView.swift
//  AcademyLifeFE
//
//  Created by Heejae Seo on 12/14/24.
//

import SwiftUI
import AVKit

struct ChatbotTTSPlayerView: View {
    @EnvironmentObject var chatbotVM: ChatbotViewModel
    
    var body: some View {
        VStack {
            Text("음성이 재생중입니다.")
            
            VStack {
                if #available(iOS 18.0, *) {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80)
                        .symbolEffect(.variableColor, options: .repeat(.continuous))
                        .foregroundStyle(.accentDefault)
                        .frame()
                } else if #available(iOS 17.0, *) {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80)
                        .symbolEffect(.bounce.up.wholeSymbol)
                        .symbolEffect(.variableColor)
                } else {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80)
                }
            }
            .padding(.vertical, 40)
//            Button {
//                chatbotVM.stopAudio()
//            } label: {
//                Image(systemName: "xmark.circle.fill")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 60, height: 60)
//            }
//            .bold()
        }
    }
}

#Preview {
    ChatbotTTSPlayerView()
}
