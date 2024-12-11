import SwiftUI

struct AttendanceTeacherCourseRow: View {
    let course: AttendanceCourse

    var body: some View {
        NavigationLink(
            destination: AttendanceTeacherStudentList(
                courseID: course.courseID,
                courseName: course.courseName
            )
        ) {
            VStack(alignment: .leading) {
                Text(course.courseName)
                    .font(.headline)
            }
        }
    }
}

#Preview {
    AttendanceTeacherCourseRow(course: AttendanceCourse(courseID: 3, courseName: "제과제빵", startDate: "2024-08-01", endDate: "2024-09-01", entryStatus: false, exitStatus: false))
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationViewModel())
        .environmentObject(AttendanceViewModel())
        .environmentObject(CommonDetailCodeViewModel())
        .environmentObject(CourseViewModel())
        .environmentObject(PostViewModel())
        .environmentObject(CommentViewModel())
}
