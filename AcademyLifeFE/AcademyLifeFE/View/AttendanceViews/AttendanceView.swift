import SwiftUI

struct AttendanceView: View {
    @EnvironmentObject var attendanceVM: AttendanceViewModel
    @State private var refreshView = false
    
    @AppStorage("authCd") private var userAuthCd: String?

    var body: some View {
        NavigationStack {
            VStack {
                if userAuthCd == "AUTH02" {
                    // 학생 화면
                    AttendanceStudentList(refreshView: $refreshView)
                } else if userAuthCd == "AUTH01" {
                    // 선생님 화면
                    AttendanceTeacherCourseList(refreshView: $refreshView)
                } else {
                    // 권한이 없거나 잘못된 경우
                    Text("권한을 확인할 수 없습니다. 다시 로그인해주세요.")
                        .foregroundColor(.red)
                        .font(.headline)
                }
            }
        }
    }
    
}

#Preview {
    AttendanceView()
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationViewModel())
        .environmentObject(AttendanceViewModel())
        .environmentObject(CommonDetailCodeViewModel())
        .environmentObject(CourseViewModel())
        .environmentObject(PostViewModel())
        .environmentObject(CommentViewModel())
}
