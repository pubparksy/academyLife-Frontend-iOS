import SwiftUI

struct CommentEditView: View {
    let courseID: Int
    let postID: Int
    let commentID: Int
    @State var content: String
    var onEditComplete: (String) -> Void // 클로저 파라미터 추가
    @EnvironmentObject var commentVM: CommentViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            TextField("댓글을 입력하세요", text: $content)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("수정 완료") {
                commentVM.editComment(postID: postID, commentID: commentID, content: content) { message in
                    DispatchQueue.main.async {
                        // PostDetailView를 업데이트
                        onEditComplete(content) // 수정된 내용 전달
//                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .disabled(content.isEmpty)
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}


#Preview {
    CommentEditView(
        courseID: 1,                 // 임의의 정수값
        postID: 11,                  // 임의의 정수값
        commentID: 100,              // 임의의 정수값
        content: "예제 댓글",        // 초기 댓글 내용
        onEditComplete: { updatedContent in // 수정 완료 클로저
//            print("Updated Comment Content: \(updatedContent)")
        }
    )
    .environmentObject(AuthViewModel())
    .environmentObject(NotificationViewModel())
    .environmentObject(AttendanceViewModel())
    .environmentObject(CommonDetailCodeViewModel())
    .environmentObject(CourseViewModel())
    .environmentObject(PostViewModel())
    .environmentObject(CommentViewModel())
}
