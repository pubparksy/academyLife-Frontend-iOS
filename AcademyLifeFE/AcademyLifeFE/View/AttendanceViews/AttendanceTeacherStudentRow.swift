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
                ProfileImageView(userID: student.userID, profileImage: student.profileImage, imageSize: 30)
                VStack(alignment: .leading) {
                    Text(student.userName)
                        .font(.headline)
                    Text(student.mobile)
                        .font(.subheadline)
                }
            }
            

            Spacer()
            
            Button {
                showPushNoticeAlert = true
            } label: {
                VStack {
                    Image(systemName: "light.beacon.max.fill")
                        .foregroundStyle(.red)
                    Text("입실 안내").font(.caption)
                }
            }
            .buttonStyle(.bordered)
            .alert("정말 입실 안내 푸시를 보내시겠습니까?", isPresented: $showPushNoticeAlert) {
                Button("취소", role: .cancel) {}
                Button("확인") {
                    attendanceVM.teacherPushNoti(courseID: courseID, sID: student.userID) {
                        resultMessage = attendanceVM.entryExitMessage
                        showResultAlert = true // 결과 Alert 표시
                    }
                }
            } message: {
                Text("미입실 학생 푸시 안내")
            }

            Button {
                showForceEntryAlert = true
            } label: {
                VStack {
                    Image(systemName: "person.fill.checkmark")
                    Text("수동 출석").font(.caption)
                }
            }
            .buttonStyle(.bordered)
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
