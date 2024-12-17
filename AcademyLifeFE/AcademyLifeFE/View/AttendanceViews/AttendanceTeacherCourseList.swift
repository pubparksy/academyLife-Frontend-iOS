import SwiftUI

struct AttendanceTeacherCourseList: View {
    @EnvironmentObject var attendanceVM: AttendanceViewModel
    @Binding var refreshView: Bool
    
    var body: some View {
        VStack {
            PageHeading(title: "출석체크", bottomPaddng: 16)
            DateDisplay()
            
            VStack {
                if(attendanceVM.attendanceCourses.count > 0) {
                    VStack(alignment: .leading) {
                        PageSubheading(text: "미입실 학생을 조회할 강좌를 선택하세요.")
                            .padding(.leading)
                        ScrollView {
                            ForEach(attendanceVM.attendanceCourses) { course in
                                AttendanceTeacherCourseRow(course: course)
                            }
                        }
                    }
                } else {
                    if let noCourse = attendanceVM.teacherCourseMessage {
                        Text(noCourse)
                            .foregroundStyle(.timiBlack)
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .onAppear {
            attendanceVM.attendanceCourses = [] // [qa] cache 잔여 이슈로 초기화
            attendanceVM.fetchTeacherCourses()
        }
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
