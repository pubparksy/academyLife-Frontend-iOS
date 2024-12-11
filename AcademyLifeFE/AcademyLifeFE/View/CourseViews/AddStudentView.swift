//
//  AddStudentView.swift
//  Academy-Life
//
//  Created by SeYeong's MacBook on 11/25/24.
//

import SwiftUI

struct AddStudentView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var courseVM: CourseViewModel
    @EnvironmentObject var studentVM: StudentViewModel
    
    @AppStorage("userID") var userID: Int = 0
    @State private var isChecked: Bool = false
    var courseID: Int
    @State private var showConfirmationAlert = false
    @State private var isAllSelected: Bool = false
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Text("수강생 추가")
                    .font(.system(size: 30))
                    .foregroundStyle(Color.timiBlack)
                    .bold()
                    .padding()
                List {
                    ForEach($studentVM.studentList, id: \.userID) { $user in
                        AddStudentRowView(
                            userName: user.userName,
                            mobile: user.mobile,
                            isChecked: $user.isChecked,  // Binding<Bool>을 전달
                            onToggle: { isOn in
                                toggleSelection(isOn: isOn, userID: user.userID)
                            }
                        )
                    }
                }
                WideImageButtonView(btnText: "저장하기") {
                    showConfirmationAlert = true
                    
                }
                .alert(isPresented: $showConfirmationAlert) {
                    Alert(title: Text("수강생 추가"), message: Text("선택하신 수강생을 추가하시겠습니까?") , primaryButton: .default(Text("확인"), action: {
                        studentVM.addStudents(userID: Array(studentVM.selectedUserIDs), courseID: courseID)
                    }), secondaryButton: .cancel())
                }
                .alert("수강생 추가 완료", isPresented: $studentVM.isStudentAdded, actions: {
                    Button("확인") {
                        studentVM.isStudentAdded = false
                        dismiss()
                    }
                }, message: {
                    Text(studentVM.message)
                })
            }
        }
        .onAppear {
            if userID != 0 {
                studentVM.getStudents(teacherID: userID, courseID: courseID) {
                    checkIfAllSelected() }
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: toggleAllSelection) {
                    Text(isAllSelected ? "모두 해제" : "모두 선택")
                }
            }
        }
        
    }
    
    private func toggleSelection(isOn: Bool, userID: Int) {
        if isOn {
            if !studentVM.selectedUserIDs.contains(userID) {
                studentVM.selectedUserIDs.append(userID)
            }
        } else {
            if let index = studentVM.selectedUserIDs.firstIndex(of: userID) {
                studentVM.selectedUserIDs.remove(at: index)
            }
        }
    }
    
    
    private func toggleAllSelection() {
        isAllSelected.toggle()
        for index in studentVM.studentList.indices {
            studentVM.studentList[index].isChecked = isAllSelected
            let userID = studentVM.studentList[index].userID
            
            if isAllSelected, !studentVM.selectedUserIDs.contains(userID) {
                studentVM.selectedUserIDs.append(userID)
            } else if !isAllSelected, let userIndex = studentVM.selectedUserIDs.firstIndex(of: userID) {
                studentVM.selectedUserIDs.remove(at: userIndex)
            }
        }
    }
    
    private func checkIfAllSelected() {
        
        if studentVM.studentList.allSatisfy({ $0.isChecked == true }) {
            isAllSelected = true
        } else {
            isAllSelected = false
        }
    }
    
}

#Preview {
    AddStudentView(courseID: 1)
        .environmentObject(CourseViewModel())
        .environmentObject(StudentViewModel())
}
