//  Created by soyoung Park on 11/24/24.

import SwiftUI

struct MyPageCoursePosts: View {
    @EnvironmentObject var postVM: PostViewModel
    @EnvironmentObject var courseVM: CourseViewModel
    @StateObject var commonDetailVM = CommonDetailCodeViewModel()
    @EnvironmentObject var studentVM: StudentViewModel
    
    var courseID: Int // Receive course ID
    var courseName: String // Receive course name
  
    @AppStorage("userID") var userID: Int?
    @AppStorage("authCd") var authCd: String?

    var body: some View {
        VStack {
            if commonDetailVM.cmDts.isEmpty {
                Spacer()
                Text("Loading...")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                VStack(spacing: 12) {
                    Text(authCd == "AUTH01" ? "담당 강좌" : "수강 중인 강좌")
                        .font(.system(size: 20))
                        .padding(.vertical, 10)

                    ForEach(commonDetailVM.cmDts) { detail in
                        if detail.cmDtCd != 3 {
                            NavigationLink(
                                destination: PostListView(courseID: courseID, cmDtCd: detail.cmDtCd).environmentObject(postVM)
                                    .navigationBarTitleDisplayMode(.inline)
                            ) {
                                Text(detail.cmDtName)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else {
                            NavigationLink(
                                // '수강생 추가' View로 바꿔줘야함
                                destination: AddStudentView(courseID: courseID)
                            ) {
                                Text(detail.cmDtName)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        if authCd == "AUTH02" {
                            
                     //       TextField("강좌 상세 정보", text: <#T##Binding<String>#>)
                        }
                    }
                }
                .padding(.horizontal)
            }
            Spacer()
        }
        .onAppear {
            commonDetailVM.getCmDtNms(number: 2)
          
            
        }
        .navigationTitle(courseName)
    }
}
#Preview {
    NavigationView {
        MyPageCoursePosts(courseID: 1, courseName: "iOS 개발자 과정")
            .environmentObject(AuthViewModel())
            .environmentObject(NotificationViewModel())
            .environmentObject(AttendanceViewModel())
            .environmentObject(CommonDetailCodeViewModel())
            .environmentObject(CourseViewModel())
            .environmentObject(PostViewModel())
            .environmentObject(CommentViewModel())
            .environmentObject(StudentViewModel())
    }
}
