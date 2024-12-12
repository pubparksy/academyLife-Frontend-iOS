//
//  MyPageCourseView.swift
//  Academy-Life
//
//  Created by SeYeong's MacBook on 11/22/24.
//

import SwiftUI

struct MyPageCourseView: View {
    var courseName: String = ""
    var startDate: String = ""
    var endDate: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "graduationcap.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                Spacer()
                Image(systemName: "arrow.up.right")
            }
            .padding(.bottom, 50)
            .foregroundStyle(.accent)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(courseName)
                    .lineLimit(2)
                    .font(.system(size: 16))
                    .bold()
                    .foregroundStyle(.timiBlack)
                VStack(alignment: .leading) {
                    Text("\(startDate)")
                        .font(.system(size: 13))
                    Text("~ \(endDate)")
                        .font(.system(size: 13))
                }
                .foregroundStyle(.timiBlackLight)
            }
        }
        .padding()
        .background(.accentLight)
        .frame(width: 170, height: 170)
        .cornerRadius(15)
    }
}

#Preview {
    MyPageCourseView(courseName: "courseName", startDate: "2024-12-32", endDate: "2024-12-30")
}
