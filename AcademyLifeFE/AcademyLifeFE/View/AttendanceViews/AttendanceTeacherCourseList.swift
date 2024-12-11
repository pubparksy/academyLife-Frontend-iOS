import SwiftUI

struct AttendanceTeacherCourseList: View {
    @EnvironmentObject var attendanceVM: AttendanceViewModel
    @Binding var refreshView: Bool

    var body: some View {
        VStack {
            Text("출석체크 - 선생님")
                .font(.headline)
            
            if(attendanceVM.attendanceCourses.count > 0) {
                List(attendanceVM.attendanceCourses) { course in
                    AttendanceTeacherCourseRow(course: course)
                }
            } else {
                if let noCourse = attendanceVM.teacherCourseMessage {
                    Text(noCourse)
                }
            }
        }
        .onAppear {
            attendanceVM.attendanceCourses = [] // [qa] cache 잔여 이슈로 초기화
            attendanceVM.fetchTeacherCourses()
        }
        .navigationTitle("강좌 목록")
    }
}

#Preview {
    AttendanceTeacherCourseList(refreshView: .constant(false))
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationViewModel())
        .environmentObject(AttendanceViewModel())
        .environmentObject(CommonDetailCodeViewModel())
        .environmentObject(CourseViewModel())
        .environmentObject(PostViewModel())
        .environmentObject(CommentViewModel())
}
