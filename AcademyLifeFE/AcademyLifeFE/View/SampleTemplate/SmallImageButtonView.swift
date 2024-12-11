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
                    Image(systemName: strSystemImage).resizable().frame(width: 30, height: 30)
                        .foregroundStyle(.green)
                        .padding(.bottom, 10)
                    Text("삭제")
                }
            }
            
        }.padding()
    }
}

#Preview {
    SmallImageButtonView(btnText: "수정", action: {
        print("edit button")
    }, strSystemImage: "slider.horizontal.3")
}
