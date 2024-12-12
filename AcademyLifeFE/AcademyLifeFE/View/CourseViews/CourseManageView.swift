//
//  CourseManageView.swift
//  Academy-Life
//
//  Created by SeYeong's MacBook on 11/16/24.
//

import SwiftUI

struct CourseManageView: View {
    @EnvironmentObject var courseVM: CourseViewModel
    @EnvironmentObject var cmDtCdVM: CommonDetailCodeViewModel
    @EnvironmentObject var teacherVM: TeacherViewModel
    @EnvironmentObject var studentVM: StudentViewModel

    @AppStorage("userID") var userID: Int = 0
    @State private var isCourseReisterViewActive = false
    
    var body: some View {
        NavigationStack {
            VStack{
                
                PageHeading(title: "강좌 관리", bottomPaddng: 36)
                
                VStack {
                    Text("\(courseVM.userName) 선생님이 맡고 계신 강좌에요.").frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.timiBlack)
                        .font(.system(size: 18))
                        .bold()
                        .padding(.horizontal)
                        .padding(.bottom)
                    if !courseVM.courses.isEmpty {
                        
                    
                    ScrollView {
                       
                            ForEach(courseVM.courses, id: \.id) { course in
                                NavigationLink {
                                    CourseDetailView(course: course)
                                } label: {
                                    CourseRowView(courseName: course.courseName, startDate: course.startDate, endDate: course.endDate, courseID: course.id) { id in
                                        courseVM.deleteCourse(courseID: id)
                                    }
                                }
                            }
                    
                     
                    }
                    } else {
                        Spacer()
                        Text("현재 맡고 계신 강좌가 없어요.")
                            .padding()
                            .font(.system(size: 16))
                            .foregroundStyle(.timiBlackLight)
                        Spacer()
                    }
                    NavigationLink(
                        destination: CourseRegisterView(),
                        isActive: $isCourseReisterViewActive
                    ) {
                        WideImageButtonView(btnText: "신규 강좌 개설하기", strImageName: "plus", action:{
                            isCourseReisterViewActive = true
                        }).padding(.vertical)
                    }

                }
                Spacer()
            }
            .onAppear {
                if userID != 0 {
                    courseVM.getCourse(userID: userID)
                }
            }
        }
        
        
    }
}

#Preview {
    CourseManageView()
        .environmentObject(CourseViewModel())
        .environmentObject(CommonDetailCodeViewModel())
        .environmentObject(TeacherViewModel())
        .environmentObject(StudentViewModel())
}
