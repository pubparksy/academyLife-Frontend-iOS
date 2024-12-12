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
            TextEditor(text: $text)
                .font(.system(size: 15))
                .padding(8)
                .background(.timiTextField)
                .scrollContentBackground(.hidden)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(height: 80)
        }
    }
}

#Preview {
    CourseRegisterTextfieldView(title: "강좌명", placeholder: "강좌명을 입력해주세요", text: .constant(""))
}
