import SwiftUI

struct AttendanceStudentList: View {
    @EnvironmentObject var attendanceVM: AttendanceViewModel
    @Binding var refreshView: Bool
    
    var body: some View {
        VStack {
            PageHeading(title: "출석체크", bottomPaddng: 16)
            DateDisplay()
            
            VStack {
                if(attendanceVM.attendanceCourses.count > 0) {
                    VStack(alignment: .leading) {
                        PageSubheading(text: "강의실 근처로 이동해\n입실/퇴실 버튼을 눌러주세요.")
                            .padding(.leading)
                        ScrollView {
                            ForEach (attendanceVM.attendanceCourses) { course in
                                AttendanceStudentRow(course: course)
                            }
                        }
                    }
                } else {
                    if let noCourse = attendanceVM.studentCourseMessage {
                        Text(noCourse)
                            .foregroundStyle(.timiBlack)
                    }
                }
            }
            .frame(maxHeight: .infinity)
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
