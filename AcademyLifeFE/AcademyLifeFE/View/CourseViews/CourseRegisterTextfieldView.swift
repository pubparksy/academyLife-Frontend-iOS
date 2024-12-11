//
//  CourseRegisterTextfieldView.swift
//  Academy-Life
//
//  Created by SeYeong's MacBook on 11/17/24.
//

import SwiftUI

struct CourseRegisterTextfieldView: View {
    var title: String
    var placeholder: String
    @Binding var text: String
   
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            TextField(placeholder, text: $text)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    CourseRegisterTextfieldView(title: "강좌명", placeholder: "강좌명을 입력해주세요", text: .constant(""))
}
