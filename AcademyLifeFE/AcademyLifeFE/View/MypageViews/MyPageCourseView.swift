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
            }.padding(.bottom, 50)
          
            VStack(alignment: .leading) {
                Text(courseName)
                    .lineLimit(2)
                    .font(.headline)
                    
                Text("\(startDate)")
                    .lineLimit(2)
                    .font(.caption)
                Text("\(endDate)")
                    .lineLimit(2)
                    .font(.caption)
            }
        }.padding()
        .frame(width: 170, height: 170)
            .background(Color.accentLight)
            .cornerRadius(20)
    }
}

#Preview {
    MyPageCourseView(courseName: "courseName", startDate: "2024-12-32", endDate: "2024-12-30")
}
