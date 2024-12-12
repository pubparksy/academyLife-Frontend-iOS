//
//  CourseRegisterPickerView.swift
//  Academy-Life
//
//  Created by SeYeong's MacBook on 11/17/24.
//

import SwiftUI

struct CourseRegisterPickerView: View {
    @EnvironmentObject var cmDtCdVM: CommonDetailCodeViewModel
    @EnvironmentObject var teacherVM: TeacherViewModel
    @EnvironmentObject var courseVM: CourseViewModel
    @EnvironmentObject var studentVM: StudentViewModel
    
    var title: String
    @Binding var selectedCmDtCd: Int
    @Binding var selectedCmDtName: String
      
    @Binding var selectedTeacherID: Int
    @Binding var selectedTeacherName: String
      
    var isCategory:Bool = true
    
    var body: some View {
        VStack {
            
            if isCategory {
                VStack(alignment: .leading) {
                    Text(title)
                    Picker("강좌 분류", selection: $selectedCmDtName) {
                        Text("강좌 분류를 선택해주세요").tag("강좌 분류를 선택해주세요" as String)
                        ForEach(cmDtCdVM.cmDts, id: \.cmDtCd) { item in
                            Text(item.cmDtName).tag(item.cmDtName)
                                .font(.system(size: 15))
                        }
                    }
                    .onChange(of: selectedCmDtCd) { newValue in
                        // selectedCmDtCd 값이 변경될 때마다 selectedCmDtName을 업데이트
                        if let selectedCategory = cmDtCdVM.cmDts.first(where: { $0.cmDtCd == newValue }) {
                            selectedCmDtName = selectedCategory.cmDtName
                        }
                    }
                    .onChange(of: selectedCmDtName) { newName in
                        print("pickerView", selectedCmDtName)
                        if let selectedCategory = cmDtCdVM.cmDts .first(where:{$0.cmDtName == newName}){
                            print("카테고리", selectedCategory)
                            selectedCmDtCd = selectedCategory.cmDtCd
                            
                        }
                    }
                    
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(.timiTextField)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            } else {
                VStack(alignment: .leading) {
                    Text(title)
                    Picker("담당자", selection: $selectedTeacherName) {
                        Text("강사를 선택해주세요").tag("강사를 선택해주세요" as String)
                        ForEach(teacherVM.teachers, id: \.userID) { teacher in
                            Text(teacher.userName).tag(teacher.userName)
                                .font(.system(size: 15))
                        }
                    }.onChange(of: selectedTeacherName) { newName in
                        if let selectedTeacher = teacherVM.teachers.first(where:{$0.userName == newName}){
                            selectedTeacherID = selectedTeacher.userID
                        }
                    }
                    .onChange(of: selectedTeacherID) { newValue in
                        if let selectedTeacher = teacherVM.teachers.first(where:{$0.userID == newValue}){
                            selectedTeacherName = selectedTeacher.userName
                        }
                    }
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            }
        }.onAppear {
            cmDtCdVM.getCmDtNms(number: 1)
            teacherVM.getTeachers()
            

        }
    }
    
}

#Preview {
    CourseRegisterPickerView(title: "강좌 분류", selectedCmDtCd:.constant(2) , selectedCmDtName: .constant("정보통신"), selectedTeacherID: .constant(11),selectedTeacherName: .constant("이영록"), isCategory: true)
        .environmentObject(CommonDetailCodeViewModel())
        .environmentObject(CourseViewModel())
        .environmentObject(TeacherViewModel())
        .environmentObject(StudentViewModel())
}
