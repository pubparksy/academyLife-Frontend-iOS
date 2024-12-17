import SwiftUI

struct AttendanceTeacherStudentRow: View {
    @EnvironmentObject var attendanceVM: AttendanceViewModel
    let student: AttendanceNotEntry
    let courseID: Int
    @State private var showPushNoticeAlert = false
    @State private var showForceEntryAlert = false
    @State private var showResultAlert = false
    @State private var resultMessage: String?

    var body: some View {
        HStack {
            HStack {
                ProfileImageView(userID: student.userID, profileImage: student.profileImage, imageSize: 34)
                    .padding(.trailing, 4)
                VStack(alignment: .leading, spacing: 4) {
                    Text(student.userName)
                        .font(.system(size: 16))
                    Text(student.mobile)
                        .font(.system(size: 14))
                        .foregroundStyle(.timiBlackLight)
                        .contextMenu { // 꾹 눌렀을 때 메뉴 표시
                            // 1. "복사" 버튼
                            Button(action: {
                                UIPasteboard.general.string = student.mobile
                            }) {
                                Label("복사", systemImage: "doc.on.doc") // 복사 아이콘
                            }
                            
                            // 2. "전화" 버튼
                            Button(action: {
                                if let phoneURL = URL(string: "tel://\(student.mobile)"),
                                   UIApplication.shared.canOpenURL(phoneURL) {
                                    UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                                }
                            }) {
                                Label("전화", systemImage: "phone") // 전화 아이콘
                            }
                        }
                }
            }

            Spacer()
            
            SmallImageButtonView(btnText: "입실 알림", action: {
                showPushNoticeAlert = true
            }, strSystemImage: "light.beacon.max.fill", iconColor: .timiRed)
            .alert("정말 입실 알림 푸시를 보내시겠습니까?", isPresented: $showPushNoticeAlert) {
                Button("취소", role: .cancel) {}
                Button("확인") {
                    attendanceVM.teacherPushNoti(courseID: courseID, sID: student.userID) {
                        resultMessage = attendanceVM.entryExitMessage
                        showResultAlert = true // 결과 Alert 표시
                    }
                }
            } message: {
                Text("미입실 학생 푸시 알림")
            }
            
            HorizontalDivider()

            SmallImageButtonView(btnText: "수동 출석", action: {
                showForceEntryAlert = true
            }, strSystemImage: "person.fill.checkmark", iConManualPosition: 4)
            .alert("정말 수동 출석 처리하시겠습니까?", isPresented: $showForceEntryAlert) {
                Button("취소", role: .cancel) {}
                Button("확인") {
                    attendanceVM.teacherForceEntry(courseID: courseID, sID: student.userID) {
                        resultMessage = attendanceVM.entryExitMessage
                        showResultAlert = true // 결과 Alert 표시
                    }
                }
            } message: {
                Text("수동 출석 처리 진행")
            }
        }
        .alert(resultMessage ?? "", isPresented: $showResultAlert) {
            Button("확인") {
                // Alert 닫힌 후 데이터 갱신
                attendanceVM.fetchTeacherStudents(cID: courseID)
            }
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.timiTextField)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal)
    }
}

#Preview {
    AttendanceTeacherStudentRow(student: AttendanceNotEntry(courseID: 3, userID: 1, userName: "홍길동", profileImage: "person.fill", mobile: "010-1234-5678"), courseID: 3)
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationViewModel())
        .environmentObject(AttendanceViewModel())
        .environmentObject(CommonDetailCodeViewModel())
        .environmentObject(CourseViewModel())
        .environmentObject(PostViewModel())
        .environmentObject(CommentViewModel())
}
