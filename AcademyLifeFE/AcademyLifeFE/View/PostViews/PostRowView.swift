import SwiftUI

let sampleCoursePost = CoursePost(
     courseID: 1,
     cmDtCd: 2,
     postID: 11,
     title: "제목",
     content: "내용",
     writerID: 11,
     writerNm: "이영록",
     profileImage: "profileimage string",
     createdAt: "2024-10-11 00:34"
)



struct PostRowView: View {
    var coursePost: CoursePost
    
    
    
    var body: some View {
        VStack(alignment:.leading, spacing: 10) {
//            HStack {
//                Image(systemName: "person.circle.fill").foregroundStyle(.blue)
//                Text(coursePost.writerNm)
//                    .font(.subheadline)
//            }
            HStack {
                Text("\(coursePost.title)")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                Spacer()
                Text(formattedDate(from: coursePost.createdAt)).font(.caption)
            }
            Text("\(coursePost.content)").lineLimit(1).font(.caption).foregroundStyle(.timiBlackLight)
        }
    }
    
    /// 날짜 문자열을 "2024-10-11" 형식으로 변환하는 함수
    private func formattedDate(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm" // 입력 날짜 포맷

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd" // 출력 날짜 포맷

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString // 변환 실패 시 원본 반환
        }
    }
}

#Preview {
    PostRowView(coursePost: sampleCoursePost)
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationViewModel())
        .environmentObject(AttendanceViewModel())
        .environmentObject(CommonDetailCodeViewModel())
        .environmentObject(CourseViewModel())
        .environmentObject(PostViewModel())
        .environmentObject(CommentViewModel())
}
