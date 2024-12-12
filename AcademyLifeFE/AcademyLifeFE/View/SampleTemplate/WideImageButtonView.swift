//
//  WideButtonView.swift
//  timi-not-pull-ver
//
//  Created by SeYeong's MacBook on 11/16/24.
//

import SwiftUI

struct WideImageButtonView: View {
    var btnText: String
    var strImageName: String = ""
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: strImageName)
                Text(btnText)
            }
            
        }
        .bold()
        .frame(maxWidth: .infinity)
        .foregroundStyle(.accent)
        .padding()
        .background(.accentLight)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
        
    }
}

#Preview {
    WideImageButtonView(btnText: "신규", strImageName: "hand.rays", action: {
        print("move to new course")
    })
}
