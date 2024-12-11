import SwiftUI

struct AttendanceTeacherStudentList: View {
    @EnvironmentObject var attendanceVM: AttendanceViewModel
    let courseID: Int
    let courseName: String

    var body: some View {
        VStack {
            Text("미입실 학생 목록")
                .font(.headline)

            if attendanceVM.attendanceNotEntries.isEmpty {
                Text(attendanceVM.teacherCourseStudentMessage)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(attendanceVM.attendanceNotEntries) { student in
                    AttendanceTeacherStudentRow(student: student, courseID: courseID)
                }
            }
        }
        .onAppear {
            attendanceVM.fetchTeacherStudents(cID: courseID)
        }
        .navigationTitle("\(courseName) 강좌")
    }
}

#Preview {
    AttendanceTeacherStudentList(courseID: 3, courseName: "iOS")
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationViewModel())
        .environmentObject(AttendanceViewModel())
        .environmentObject(CommonDetailCodeViewModel())
        .environmentObject(CourseViewModel())
        .environmentObject(PostViewModel())
        .environmentObject(CommentViewModel())
}
