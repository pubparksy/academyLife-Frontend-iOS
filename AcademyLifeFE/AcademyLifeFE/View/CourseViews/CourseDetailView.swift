//
//  CourseDetailView.swift
//  Academy-Life
//
//  Created by SeYeong's MacBook on 11/27/24.
//

import SwiftUI

struct CourseDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var courseVM: CourseViewModel
    @EnvironmentObject var teacherVM: TeacherViewModel
    @EnvironmentObject var cmDtCdVM: CommonDetailCodeViewModel
    @EnvironmentObject var studentVM: StudentViewModel
    
    @AppStorage("userID") var userID: Int = 0
    @State private var selectedStartDate: Date = Date()
    @State private var selectedEndDate: Date = Date()
    
    @State private var showValidationAlert = false
    @State private var showConfirmationAlert = false
    @State private var showDeleteConfirmationAlert = false
    @State private var navigateToAddStudentView = false

    @State private var isFormValid = true
    
    
    @State var course: CourseByUserID
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Text(course.courseName.isEmpty ? "강좌 상세" : course.courseName).font(.title).bold()
                    .frame(maxWidth: .infinity).padding(.top, 20)
                    .padding(.bottom, 20)
                
                VStack {
                    CourseRegisterPickerView(title: "강좌 분류", selectedCmDtCd: $course.cmDtCd, selectedCmDtName: $course.cmDtName, selectedTeacherID: $course.userID, selectedTeacherName: $course.teacherName , isCategory: true)
                    CourseRegisterTextfieldView(title: "강좌명", placeholder: "강좌명을 입력해주세요.", text: $course.courseName)
                    CourseRegisterTextView(title: "기간", startDate: $selectedStartDate, endDate: $selectedEndDate, dateFormatter: dateFormatter)
                    CourseRegisterTextfieldView(title: "상세 정보", placeholder: "강좌명을 입력해주세요.", text: $course.courseDesc)
                    CourseRegisterPickerView(title: "담당자", selectedCmDtCd: $course.cmDtCd, selectedCmDtName: $course.courseName, selectedTeacherID: $course.userID, selectedTeacherName: $course.teacherName, isCategory: false)
                    
                }
                .padding()
                Spacer()
                WideImageButtonView(btnText: "수정") {
                    
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
                    Text("모든 항목을 올바르게 입력해주세요.")
                }
                .alert(isPresented: $showConfirmationAlert) {
                    Alert(title: Text("강좌 수정"), message: Text("정말 강좌를 수정하시겠습니까?") , primaryButton: .default(Text("확인"), action: {
                        courseVM.updateCourse(courseID: course.id ,cmDtCd: course.cmDtCd, courseName: course.courseName, courseDesc: course.courseDesc, startDate: selectedStartDate, endDate: selectedEndDate, teacherID: course.userID)
                        
                    }), secondaryButton: .cancel())
                }.onAppear(perform: {
                    print("alert", selectedStartDate, selectedEndDate)
                })
                .alert("강좌 수정 완료", isPresented: $courseVM.isCourseUpdated, actions: {
                    Button("확인") {
                        courseVM.isCourseUpdated = false
                        courseVM.getCourse(userID: course.userID)
                        dismiss()
                    }
                }, message: {
                    Text("강좌가 개설되었습니다.")
                })
                
                
                
            }.onAppear {
                selectedStartDate =  formatStringToDate(course.startDate)
                selectedEndDate = formatStringToDate(course.endDate)
            }
            .navigationDestination(isPresented: $navigateToAddStudentView, destination: {
                AddStudentView(courseID: course.id)
            })
            
        }
       
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "person.badge.plus") {
                    navigateToAddStudentView = true
                }
                }
        }
       
        
    }
    
    private func validateForm() -> Bool {
        guard !course.courseName.isEmpty,
              !course.courseDesc.isEmpty,
              course.cmDtName != "강좌 분류를 선택해주세요",
              course.teacherName != "강사를 선택해주세요",
              selectedStartDate <= selectedEndDate else {
            return false
        }
        return true
    }
    
}

//#Preview {
//
//    CourseDetailView(course: course)
//        .environmentObject(CourseViewModel())
//        .environmentObject(TeacherViewModel())
//        .environmentObject(CommonDetailCodeViewModel())
//        .environmentObject(StudentViewModel())
//}
