import SwiftUI

struct AttendanceTeacherStudentList: View {
    @EnvironmentObject var attendanceVM: AttendanceViewModel
    let courseID: Int
    let courseName: String
    let isCourseDateToday: Bool

    var body: some View {
        VStack {
            PageHeading(title: "미입실 학생 목록", bottomPaddng: 16)
            Text("\(courseName) 강좌")
                .foregroundStyle(.accent)
                .padding(.bottom)
            
            Spacer()
            if !isCourseDateToday {
                Text("오늘은 강좌 기간에 해당되지 않습니다.")
                    .foregroundColor(.gray)
                    .padding()
            } else if isCourseDateToday && attendanceVM.attendanceNotEntries.isEmpty {
                VStack {
                    Image("AttendanceIcon")
                    Text(attendanceVM.teacherCourseStudentMessage)
                        .foregroundColor(.gray)
                        .padding()
                    
                }
            } else if isCourseDateToday && !attendanceVM.attendanceNotEntries.isEmpty {
                ScrollView {
                    ForEach(attendanceVM.attendanceNotEntries) { student in
                        AttendanceTeacherStudentRow(student: student, courseID: courseID)
                    }
                }
            }
            Spacer()
        }
        .onAppear {
            attendanceVM.fetchTeacherStudents(cID: courseID)
        }
    }
}

#Preview {
    AttendanceTeacherStudentList(courseID: 3, courseName: "iOS", isCourseDateToday:true)
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationViewModel())
        .environmentObject(AttendanceViewModel())
        .environmentObject(CommonDetailCodeViewModel())
        .environmentObject(CourseViewModel())
        .environmentObject(PostViewModel())
        .environmentObject(CommentViewModel())
}
