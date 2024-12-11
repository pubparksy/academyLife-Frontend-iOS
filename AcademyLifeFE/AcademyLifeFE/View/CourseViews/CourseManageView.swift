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
                Text("강좌 관리").font(.title).bold()
                    .frame(maxWidth: .infinity).padding(.top, 20)
                    .padding(.bottom, 20)
                
                VStack {
                    Text("\(courseVM.userName) 선생님이 맡고 계신 강좌에요.").frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title2)
                        .bold()
                        .padding()
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
                        Text("현재 진행중인 강좌가 없습니다")
                            .padding()
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
            }.onAppear {
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
