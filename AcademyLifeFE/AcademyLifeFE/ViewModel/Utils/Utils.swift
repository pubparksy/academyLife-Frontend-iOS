//
//  Utils.swift
//  Academy-Life
//
//  Created by SeYeong's MacBook on 11/22/24.
//

import SwiftUI

//dateFormatter는 연산 프로퍼티
var dateFormatter: DateFormatter{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}

// Date 타입을 날짜 문자열로 바꾸는 함수
func formatDateToString(_ date: Date) ->  String {
    return dateFormatter.string(from: date)
}


// 날짜 문자열을 Date 타입으로 바꾸는 함수
func formatStringToDate(_ dateString: String) -> Date {
    return dateFormatter.date(from: dateString) ?? Date()
    
}


struct iOSCheckobxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack{
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "checkmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                configuration.label
            }
            .foregroundStyle(.accent)
        }
    }
}

func dismissKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
