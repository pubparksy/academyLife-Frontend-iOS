//
//  AddStudentRowView.swift
//  Academy-Life
//
//  Created by SeYeong's MacBook on 12/2/24.
//

import SwiftUI

struct AddStudentRowView: View {
    var userName: String
    var mobile: String
    @Binding var isChecked: Bool
    var onToggle: (Bool) -> Void  
      
    var body: some View {
          HStack {
              // Toggle 버튼을 커스텀 스타일로
              Toggle(isOn: $isChecked) {  // @Binding으로 isChecked 상태를 바인딩
                  Text(userName)
                      .lineLimit(1)  // 텍스트가 한 줄을 넘지 않게 처리
                      .truncationMode(.tail)  // 텍스트가 너무 길면 말줄임표로 처리
                      .bold()
                      .foregroundStyle(.timiBlack)
                      .padding(.leading, 16)  // Toggle과 텍스트 사이에 여백 추가
              }
              .toggleStyle(iOSCheckobxToggleStyle())  // 커스텀 Toggle 스타일 적용
              .onChange(of: isChecked) { newValue in
                  onToggle(newValue)
              }
              
              // Spacer를 사용하여 Text를 오른쪽 끝으로 정렬
              Spacer()
              
              // 학생의 전화번호 표시
              Text(mobile)
                  .lineLimit(1)  // 텍스트가 한 줄을 넘지 않게 처리
                  .truncationMode(.tail)  // 텍스트가 너무 길면 말줄임표로 처리
          }
          .font(.system(size: 16))  // 폰트 크기
          .padding(.vertical, 12)  // 위아래 여백 추가
      }

    
}

#Preview {
//    AddStudentRowView(userName: "가세영", mobile: "01011112222", isChecked: .constant(true))
//        AddStudentRowView()
}
