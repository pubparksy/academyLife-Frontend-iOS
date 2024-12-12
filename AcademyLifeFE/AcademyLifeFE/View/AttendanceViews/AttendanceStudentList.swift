import SwiftUI

struct AttendanceStudentList: View {
    @EnvironmentObject var attendanceVM: AttendanceViewModel
    @Binding var refreshView: Bool
    
    var body: some View {
        VStack {
            PageHeading(title: "출석체크")
            DateDisplay()
            Spacer()
//            Text("출석체크")
//                .font(.headline)
            
            if(attendanceVM.attendanceCourses.count > 0) {
                List(attendanceVM.attendanceCourses) { course in
                    AttendanceStudentRow(course: course)
                }
                
            } else {
                if let noCourse = attendanceVM.studentCourseMessage {
                    Text(noCourse)
                }
            }
            Spacer()
        }
        .onAppear {
            attendanceVM.attendanceCourses = []
            attendanceVM.fetchStudentCoursesStatus()
        }
    }
}

#Preview {
    AttendanceStudentList(refreshView: .constant(false))
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationViewModel())
        .environmentObject(AttendanceViewModel())
        .environmentObject(CommonDetailCodeViewModel())
        .environmentObject(CourseViewModel())
        .environmentObject(PostViewModel())
        .environmentObject(CommentViewModel())
}
