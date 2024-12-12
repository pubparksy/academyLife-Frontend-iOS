//
//  SmallButton.swift
//  timi-not-pull-ver
//
//  Created by SeYeong's MacBook on 11/16/24.
//

import SwiftUI

struct SmallImageButtonView: View {
    var btnText: String
    var action: () -> Void
    var strSystemImage: String
    var body: some View {
        VStack {
            Button {
                action()
            } label: {
                VStack {
                    Image(systemName: strSystemImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                        .foregroundStyle(.accent)
                        .padding(.bottom, 4)
                    Text("삭제")
                        .foregroundStyle(.timiBlack)
                        .font(.system(size: 13))
                }
            }
            .bold()
            
        }
        .padding(20)
    }
}

#Preview {
    SmallImageButtonView(btnText: "수정", action: {
        print("edit button")
    }, strSystemImage: "slider.horizontal.3")
}
