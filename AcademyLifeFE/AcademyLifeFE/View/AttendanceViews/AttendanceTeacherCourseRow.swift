import SwiftUI

struct AttendanceTeacherCourseRow: View {
    let course: AttendanceCourse

    var body: some View {
        NavigationLink(
            destination:
                AttendanceTeacherStudentList(
                courseID: course.courseID,
                courseName: course.courseName,
                isCourseDateToday: course.isCourseDateToday
                
            )
        ) {
            VStack(alignment: .leading, spacing: 10) {
                Text(course.courseName)
                    .font(.system(size: 16))
                    .bold()
                    .foregroundStyle(.timiBlack)
                if let startDate = course.startDate,
                   let endDate = course.endDate {
                    Text("\(startDate) ~ \(endDate)")
                        .font(.system(size: 14))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.timiTextField)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal)
        }
    }
}

#Preview {
    AttendanceTeacherCourseRow(course: AttendanceCourse(courseID: 3, courseName: "제과제빵", startDate: "2024-08-01", endDate: "2024-09-01", isCourseDateToday: true, entryStatus: false, exitStatus: false))
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationViewModel())
        .environmentObject(AttendanceViewModel())
        .environmentObject(CommonDetailCodeViewModel())
        .environmentObject(CourseViewModel())
        .environmentObject(PostViewModel())
        .environmentObject(CommentViewModel())
}
