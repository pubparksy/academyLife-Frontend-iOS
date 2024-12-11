//
//  CourseRegisterTextView.swift
//  Academy-Life
//
//  Created by SeYeong's MacBook on 11/20/24.
//

import SwiftUI

struct CourseRegisterTextView: View {
    var title: String
    @Binding var startDate: Date
    @Binding var endDate: Date
    var dateFormatter: DateFormatter
    
    @State var isModalPresented: Bool = false
    var body: some View {
    VStack(alignment: .leading) {
        HStack {
            Text(title)
            Spacer()
            Button("기간 선택하기") {
                // 날짜 선택 모달 띄우기
                isModalPresented = true
            }.sheet(isPresented: $isModalPresented) {
                DatePickerView(selectedStartDate: $startDate, selectedEndDate: $endDate)
                    .onDisappear {
                        startDate = startDate
                        endDate = endDate
                        print(startDate, endDate)
                    }
            }
        }

            Text("\(dateFormatter.string(from: startDate)) ~ \(dateFormatter.string(from: endDate))")
                .padding()
                .frame(maxWidth: .infinity)
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            
    }
    }
}

#Preview {
    CourseRegisterTextView(title: "기간", startDate: .constant(Date()), endDate: .constant(Date()), dateFormatter: DateFormatter())
}
