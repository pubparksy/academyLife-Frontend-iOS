//
//  CourseRegisterView.swift
//  Academy-Life
//
//  Created by SeYeong's MacBook on 11/17/24.
//

import SwiftUI


struct CourseRegisterView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var courseVM: CourseViewModel
    @EnvironmentObject var cmDtCdVM: CommonDetailCodeViewModel
    @EnvironmentObject var teacherVM: TeacherViewModel
    @EnvironmentObject var studentVM: StudentViewModel
    
    @State var courseName: String = ""
    @State var courseDesc: String = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var selectedTeacherID: Int = 0
    @State var selectedCmDtCd: Int = 0
    @State private var selectedCmDtName: String = "강좌 분류를 선택해주세요"
    @State private var selectedTeacherName: String = "강사를 선택해주세요"
    @State private var validMessages: [String] = []
    
    
    
    @State private var showValidationAlert = false
    @State private var showConfirmationAlert = false
    @State private var isFormValid = true
    
    var isCategory: Bool = true
    
    var body: some View {
        
        VStack {
            
            Text("강좌 추가").font(.title).bold()
                .frame(maxWidth: .infinity).padding(.top, 20)
                .padding(.bottom, 20)
            
            VStack {
                CourseRegisterPickerView(title: "강좌 분류", selectedCmDtCd: $selectedCmDtCd, selectedCmDtName: $selectedCmDtName, selectedTeacherID: $selectedTeacherID, selectedTeacherName: $selectedTeacherName, isCategory: true)
                CourseRegisterTextfieldView(title: "강좌명", placeholder: "강좌명을 입력해주세요.", text: $courseName)
                CourseRegisterTextView(title: "기간", startDate: $startDate, endDate: $endDate, dateFormatter: dateFormatter)
                CourseRegisterTextfieldView(title: "상세정보", placeholder: "시간, 요일, 강사 등 강좌의 상세 정보를 입력해주세요.", text: $courseDesc)
                CourseRegisterPickerView(title: "담당자", selectedCmDtCd: $selectedCmDtCd, selectedCmDtName: $selectedCmDtName, selectedTeacherID: $selectedTeacherID, selectedTeacherName: $selectedTeacherName, isCategory: false)
            }.padding()
            Spacer()
            
            WideImageButtonView(btnText: "개설") {
                
                isFormValid = validateForm()
                if isFormValid {
                    
                    showConfirmationAlert = true
                } else {
                    showValidationAlert = true
                }
                
                
            }
            .alert("입력 오류", isPresented: $showValidationAlert) {
                Button("확인", action: {})
            } message : {
                Text(validMessages.joined(separator: "\n"))
            }
            
            .alert(isPresented: $showConfirmationAlert) {
                Alert(title: Text("강좌 개설"), message: Text("정말 강좌를 개설하시겠습니까?") , primaryButton: .default(Text("확인"), action: {
                    courseVM.addCourse(cmDtCd: selectedCmDtCd, courseName: courseName, courseDesc: courseDesc, startDate: startDate, endDate: endDate, teacherID: selectedTeacherID)
                }), secondaryButton: .cancel())
            }
            .alert("강좌 개설 완료", isPresented: $courseVM.isCourseAdded, actions: {
                Button("확인") {
                    courseVM.isCourseAdded = false
                    courseVM.getCourse(userID: selectedTeacherID)
                    dismiss()
                }
            }, message: {
                Text("강좌가 개설되었습니다.")
            })
            
        }
    }
    
    private func validateForm() -> Bool {
        
        validMessages = []
        
        if courseName.isEmpty && courseDesc.isEmpty && selectedCmDtName == "강좌 분류를 선택해주세요" && selectedTeacherName == "강사를 선택해주세요" {
            validMessages.append("모든 항목을 올바르게 입력해주세요.")
        } else {
            
            // 각 항목에 대해 유효성 검사를 하고 오류 메시지를 추가
            if courseName.isEmpty {
                validMessages.append("강좌명을 입력해주세요.")
            }
            if courseDesc.isEmpty {
                validMessages.append("강좌의 상세 정보를 입력해주세요.")
            }
            if selectedCmDtName == "강좌 분류를 선택해주세요" {
                validMessages.append("강좌 분류를 선택해주세요.")
            }
            if selectedTeacherName == "강사를 선택해주세요" {
                validMessages.append("강사를 선택해주세요.")
            }
        }
        
        
        guard !courseName.isEmpty,
              !courseDesc.isEmpty,
              selectedCmDtName != "강좌 분류를 선택해주세요",
              selectedTeacherName != "강사를 선택해주세요",
              startDate <= endDate else {
            
            return false
        }
        return true
    }
    
}

#Preview {
    CourseRegisterView()
        .environmentObject(CourseViewModel())
        .environmentObject(CommonDetailCodeViewModel())
        .environmentObject(TeacherViewModel())
        .environmentObject(StudentViewModel())
}
