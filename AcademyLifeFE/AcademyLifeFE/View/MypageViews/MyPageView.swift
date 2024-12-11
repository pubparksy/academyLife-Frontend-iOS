//
//  MyPageView.swift
//  Academy-Life
//
//  Created by SeYeong's MacBook on 11/22/24.
//

import SwiftUI

struct MyPageView: View {
    var today:Date = Date()
    @EnvironmentObject var postVM: PostViewModel
    @EnvironmentObject var courseVM: CourseViewModel
    @EnvironmentObject var teacherVM: TeacherViewModel
    @EnvironmentObject var studentVM: StudentViewModel
    @EnvironmentObject var userVM: UserViewModel
    @AppStorage("authCd") var authCd: String?
    @AppStorage("userID") var userID: Int?
    @State var navigateToEdit = false
    @State var navigateToSignUp = false
    @State var navigateToUploadProfileImageView = false
    
    
    
    var body: some View {
        @AppStorage("loginMethod") var loginMethod: String?
        
        NavigationView {
            VStack {
                VStack {
                    PageHeading(title: "마이페이지", bottomPaddng: 16)
                    Text(formatDate(today))
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .font(.caption)
                        .foregroundStyle(.timiBlackLight)
                        .background(Color.timiTextField)
                        .cornerRadius(20)
                        .padding(.bottom, 28)
                }
                .padding(.bottom)
                
                ScrollView {
                HStack {
                    VStack {
                        NavigationLink {
                            if userID != 0 {
                                UploadProfileImageView(navigateToUploadProfileImageView: $navigateToUploadProfileImageView, userIDGiven: userID ?? 0)
                            }
                        } label: {
                            if userID != 0 {
                                ZStack(alignment: .bottomTrailing) {
                                    ProfileImageView(userID: userID ?? 0, profileImage: courseVM.profileImage, imageSize: 50)
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                        .foregroundStyle(.white)
                                        .padding(4)
                                        .background(.accent)
                                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                        .bold()
                                }
                                .padding(.trailing, 5)
                            }
                        }
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("남부여성발전센터")
                            .font(.system(size: 14))
                            .foregroundStyle(.timiBlackLight)
                        Text(authCd == "AUTH01" ? "\(courseVM.userName) 선생님, 안녕하세요!" : "\(courseVM.userName) 님, 안녕하세요!")
                            .font(.system(size: 16))
                            .bold()
                    }
                    Spacer()
                }
                .padding()
                .background(Color.timiTextField)
                .cornerRadius(20)
                .padding(.horizontal)
                
                    VStack(alignment: .leading) {
                        HStack {
                            Text(authCd == "AUTH01" ? "담당 강좌" : "수강 중인 강좌")
                                .font(.system(size: 18))
                                .foregroundStyle(.timiBlack)
                                .bold()
                            Spacer()
                            if authCd == "AUTH01" {
                                if let id = userID {
                                    NavigationLink(destination:  CourseManageView(userID: id)) {
                                        HStack {
                                            Image(systemName: "gearshape.2.fill")
                                            Text("강좌 관리").font(.callout)
                                        }
                                        .padding(.trailing)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 10)
                        ScrollView(.horizontal, showsIndicators: false) {
                            if courseVM.courses.isEmpty {
                                VStack(alignment: .center) {
                                    Text("등록된 강좌가 없습니다.")
                                        .foregroundStyle(.timiBlackLight)
                                }
                            } else {
                                HStack {
                                    ForEach(courseVM.courses, id: \.id) { course in
                                        NavigationLink(
                                            destination: MyPageCoursePosts(courseID: course.id, courseName: course.courseName)
                                        ) {
                                            MyPageCourseView(courseName: course.courseName, startDate: course.startDate, endDate: course.endDate)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.leading)
                    .padding(.vertical)
                    
                    
                    VStack(alignment: .leading) {
                        Text("나의 정보 관리")
                            .font(.system(size: 18))
                            .bold()
                            .foregroundStyle(.timiBlack)
                        
                        NavigationLink {
                            EditProfileView()
                        } label: {
                            MyPageRowView(systemName: "person.text.rectangle.fill", title: "프로필 변경")
                        }
                        
                        // 소셜 로그인 회원에게는 비밀번호 변경 메뉴가 가려지게 하기
                        if loginMethod == "timiLogin" {
                            NavigationLink {
                                EditPasswordView()
                            } label: {
                                MyPageRowView(systemName: "key.fill", title: "비밀번호 변경")
                            }
                        }
                    }.padding()
                    
                    if authCd == "AUTH01" {
                        VStack(alignment: .leading) {
                            Text("기타")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.timiBlack)
                            
                            Button {
                                navigateToSignUp = true
                            } label: {
                                MyPageRowView(systemName: "person.2.badge.plus.fill", title: "다른 선생님 추가하기")
                            }
                            .navigationDestination(isPresented: $navigateToSignUp) {
                                SignUpView(isTeacher: true, navigateToSignUp: $navigateToSignUp)
                            }
                        }.padding()
                    }
                    
                    
                    VStack(alignment: .leading) {
                        Text("애플리케이션 설정")
                            .font(.system(size: 18))
                            .bold()
                            .foregroundStyle(.timiBlack)
                        
                        NavigationLink {
                            AppSettingsView()
                        } label: {
                            MyPageRowView(systemName: "text.document.fill", title: "약관")
                        }
                        
                        
                        Button {
                            UserDefaults.standard.removeObject(forKey: "isLoggedIn")
                            UserDefaults.standard.removeObject(forKey: "userID")
                            userVM.images = []
                        } label: {
                            MyPageRowView(systemName: "rectangle.portrait.and.arrow.forward", title: "로그아웃")
//                            Text("로그아웃")
//                                .font(.system(size: 18))
//                                .bold()
//                                .foregroundStyle(.timiBlackLight)
//                                .frame(maxWidth: .infinity)
//                                .padding(.vertical, 16)
//                                .background(.timiTextField)
                        }
                    }.padding()
                    
                    
                }
            }
            .onAppear(perform: {
                if let id = userID {
                    courseVM.getCourse(userID: id)
                }
            })
        }
    }
}

func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEE"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    return dateFormatter.string(from: date)
}


#Preview {
    MyPageView()
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationViewModel())
        .environmentObject(AttendanceViewModel())
        .environmentObject(CommonDetailCodeViewModel())
        .environmentObject(CourseViewModel())
        .environmentObject(PostViewModel())
        .environmentObject(CommentViewModel())
        .environmentObject(TeacherViewModel())
        .environmentObject(StudentViewModel())
        .environmentObject(UserViewModel())
}
