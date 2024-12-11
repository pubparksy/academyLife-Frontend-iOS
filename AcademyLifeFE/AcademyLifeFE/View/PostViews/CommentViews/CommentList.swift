import SwiftUI

struct CommentList: View {
    @EnvironmentObject var postVM: PostViewModel
    @State var comments: [PostComment]?
    var onEditButtonTapped: (PostComment) -> Void // 댓글 수정 버튼 클릭 시 처리

    var body: some View {
        if let comments {
            VStack(alignment: .leading) {
                Text("댓글").font(.title3).bold().padding(10)
                ForEach(comments) { comment in
                    CommentRow(comment: comment, onEditButtonTapped: onEditButtonTapped)
                }
            }
        }
    }
}

#Preview {
    CommentList(onEditButtonTapped: { _ in })
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationViewModel())
        .environmentObject(AttendanceViewModel())
        .environmentObject(CommonDetailCodeViewModel())
        .environmentObject(CourseViewModel())
        .environmentObject(PostViewModel())
        .environmentObject(CommentViewModel())
}
