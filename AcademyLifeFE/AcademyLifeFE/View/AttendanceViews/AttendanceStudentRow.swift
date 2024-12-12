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
            VStack(alignment: .leading, spacing: 4) {
                Text(course.courseName)
                    .font(.system(size: 16))
                    .bold()
                    .foregroundStyle(.timiBlack)
                Text("\(course.startDate ?? "") ~ \(course.endDate ?? "")")
                    .font(.system(size: 14))
                    .foregroundStyle(.timiBlackLight)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                if attendanceVM.showEntryButton
                    && course.isCourseDateToday
                    && !(course.entryStatus ?? false)
                    && !(course.exitStatus ?? false) {
                    SmallImageButtonView(btnText: "입실", action: {
                        showEntryAlert = true
                    }, strSystemImage: "person.badge.shield.checkmark.fill")
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
                
                if attendanceVM.showExitButton
                    && course.isCourseDateToday
                    && course.entryStatus ?? false
                    && !(course.exitStatus ?? false) {
                    HorizontalDivider()
                    
                    SmallImageButtonView(btnText: "퇴실", action: {
                        showExitAlert = true
                    }, strSystemImage: "rectangle.portrait.and.arrow.right", iconColor: .timiRed, iConManualPosition: 4)
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
        .frame(height: 80)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.timiTextField)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal)
    }
    
}

#Preview {
    AttendanceStudentRow(course: AttendanceCourse(courseID: 1, courseName: "iOS", startDate: "2024-08-01", endDate: "2024-09-01", isCourseDateToday: true, entryStatus: false, exitStatus: false))
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationViewModel())
        .environmentObject(AttendanceViewModel())
        .environmentObject(CommonDetailCodeViewModel())
        .environmentObject(CourseViewModel())
        .environmentObject(PostViewModel())
        .environmentObject(CommentViewModel())
}
