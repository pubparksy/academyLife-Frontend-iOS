import SwiftUI

struct AttendanceStudentRow: View {
    @EnvironmentObject var attendanceVM: AttendanceViewModel
    let course: AttendanceCourse
    @State private var showEntryAlert = false
    @State private var showExitAlert = false
    @State private var showResultAlert = false
    @State private var resultMessage: String?

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(course.courseName)
                    .font(.headline)
                Text("\(course.startDate ?? "") ~ \(course.endDate ?? "")")
                    .font(.subheadline)
            }

            Spacer()

            if attendanceVM.showEntryButton && !(course.entryStatus ?? false) && !(course.exitStatus ?? false) {
                Button {
                    showEntryAlert = true
                } label: {
                    VStack {
                        Image(systemName: "person.badge.shield.checkmark.fill")
                        Text("입실").font(.caption)
                    }
                }
                .buttonStyle(.bordered)
                .alert("정말 입실하시겠습니까?", isPresented: $showEntryAlert) {
                    Button("취소", role: .cancel) {}
                    Button("확인") {
                        attendanceVM.studentEntry(cID: course.courseID) {
                            resultMessage = attendanceVM.entryExitMessage
                            showResultAlert = true
                        }
                    }
                }
            }

            if attendanceVM.showExitButton && course.entryStatus ?? false && !(course.exitStatus ?? false) {
                Button {
                    showExitAlert = true
                } label: {
                    VStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("퇴실").font(.caption)
                    }
                }
                .buttonStyle(.bordered)
                .alert("정말 퇴실하시겠습니까?", isPresented: $showExitAlert) {
                    Button("취소", role: .cancel) {}
                    Button("확인") {
                        attendanceVM.studentExit(cID: course.courseID) {
                            resultMessage = attendanceVM.entryExitMessage
                            showResultAlert = true
                        }
                    }
                }
            }
        }
        .alert(resultMessage ?? "", isPresented: $showResultAlert) {
            Button("확인") {
                attendanceVM.fetchStudentCoursesStatus()
            }
        }
    }
}

#Preview {
    AttendanceStudentRow(course: AttendanceCourse(courseID: 1, courseName: "iOS", startDate: "2024-08-01", endDate: "2024-09-01", entryStatus: false, exitStatus: false))
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationViewModel())
        .environmentObject(AttendanceViewModel())
        .environmentObject(CommonDetailCodeViewModel())
        .environmentObject(CourseViewModel())
        .environmentObject(PostViewModel())
        .environmentObject(CommentViewModel())
}
