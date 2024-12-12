//
//  MyPageRowView.swift
//  Academy-Life
//
//  Created by SeYeong's MacBook on 11/22/24.
//

import SwiftUI

struct MyPageRowView: View {
    var systemName: String = ""
    var title: String = ""
    var body: some View {
        HStack {
            HStack {
                Image(systemName: systemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.accent)
                    .padding(.vertical, 20)
                    .padding(.trailing, 10)
            }
            Text(title)
                .font(.system(size: 16))
                .foregroundStyle(.timiBlack)
                .padding(.trailing, 120)
            Spacer()
        }
        .frame(maxHeight: 40)
    }
}

#Preview {
    MyPageRowView(systemName: "person.text.rectangle.fill", title: "프로필 변경")
    MyPageRowView(systemName: "key.fill", title: "비밀번호 변경")
}
