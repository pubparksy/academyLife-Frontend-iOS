//
//  DatePickerView.swift
//  Academy-Life
//
//  Created by SeYeong's MacBook on 10/29/24.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedStartDate: Date
    @Binding var selectedEndDate: Date
    @Environment(\.dismiss) var dismiss
//    @State var showValidAlert = false
  
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("시작일", selection: $selectedStartDate, in: ...selectedEndDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                } header: {
                    Text("시작일")
                }
                Section {
                    DatePicker("종료일", selection: $selectedEndDate, in: selectedStartDate..., displayedComponents: .date)
                        .datePickerStyle(.graphical)
                } header: {
                    Text("종료일")
                }
            }
            .navigationTitle("기간 선택")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("확인") {
//                        if selectedEndDate < selectedStartDate {
//                            showValidAlert = true
//                        } else {
                            dismiss()  // 모달 닫기
//                        }
                    }
                }
            }
//            .alert("기간을 수정해주세요", isPresented: $showValidAlert) {
//                Button("확인") {}
//            } message: {
//                Text("종료일은 시작일보다 빠를 수 없습니다.")
//            }
        }
    }
}




#Preview {
    DatePickerView(selectedStartDate: .constant(Date()), selectedEndDate: .constant(Date()))
}
