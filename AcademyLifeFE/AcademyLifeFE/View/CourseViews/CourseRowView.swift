//
//  CourseRowView.swift
//  timi-not-pull-ver
//
//  Created by SeYeong's MacBook on 11/16/24.
//

import SwiftUI

struct CourseRowView: View {
    @EnvironmentObject var courseVM: CourseViewModel
    @EnvironmentObject var teacherVM: TeacherViewModel
    @EnvironmentObject var studentVM: StudentViewModel
    
    var courseName: String
    var startDate: String
    var endDate: String
    var courseID: Int
    
    @State var isEditButtonActive = false
    @State var showDeleteConfirmationAlert = false
    @State var showStudentCheckAlert = false
    var onDelete: (Int) -> Void
    @AppStorage("userID") var userID: Int?
    
    
    var body: some View {
        HStack(spacing: 50) {
            VStack(alignment: .leading, spacing: 4) {
                Text(courseName)
                    .foregroundStyle(.timiBlack)
                    .bold()
                    .font(.system(size: 16))
                    .lineLimit(1)
                Text("\(startDate) ~ \(endDate)")
                    .font(.system(size: 14))
                    .foregroundStyle(.timiBlackLight)
            }
            Spacer()
            
            SmallImageButtonView(btnText: "삭제", action:{
                studentVM.getStudentsForCourse(courseID: courseID) { hasStudents in
                    if hasStudents{
                        showStudentCheckAlert = true
                    } else {
                        showDeleteConfirmationAlert = true
                    }
                }
                
            }, strSystemImage: "trash.fill")
            .alert("삭제 불가", isPresented: $showStudentCheckAlert) {
                Button("확인") {}
            } message: {
                Text("수강생이 존재합니다.")
            }
            .alert(isPresented: $showDeleteConfirmationAlert) {
                
                Alert(title: Text("강좌 삭제"), message: Text("정말 강좌를 삭제하시겠습니까?") , primaryButton: .default(Text("확인"), action: {
                    onDelete(courseID)
                    
                }), secondaryButton: .cancel())
            }
            .alert("강좌 삭제", isPresented: $courseVM.isCourseDeleted) {
                Button("확인") {
                    if let teacherID = userID {
                        courseVM.getCourse(userID: teacherID)
                    }
                }
            } message: {
                Text(courseVM.message)
            }
            
            
        }
        
        .padding(.leading, 20)
        .padding(.vertical)
        .background(.timiTextField)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal)
        
    }
    
}


#Preview {
    CourseRowView(courseName: "iOS Course",startDate: "2024-11-07", endDate: "2024-12-31", courseID: 1, onDelete: {_ in })
        .environmentObject(CourseViewModel())
        .environmentObject(TeacherViewModel())
        .environmentObject(StudentViewModel())
}
