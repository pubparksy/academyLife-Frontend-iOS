import SwiftUI

struct CommentRow: View {
    @EnvironmentObject var commentVM: CommentViewModel
    @State private var showDeleteAlert = false
    @State private var showDeleteMessage = ""
    var comment: PostComment
    var onEditButtonTapped: (PostComment) -> Void // 댓글 수정 버튼 클릭 시 처리

    @AppStorage("userID") var userID: Int? // 현재 로그인된 사용자 ID 저장

    var body: some View {
        VStack(alignment: .leading) {
            // 댓글 작성자 이름과 작성 시간
            HStack {
                ProfileImageView(userID: comment.teacherID, profileImage: comment.profileImage, imageSize: 30)
                Text("\(comment.teacherNm)")
                    .font(.headline)
                    .foregroundStyle(.timiBlack)
                Spacer()
                Text("\(comment.createdAt)").font(.subheadline)
                    .foregroundStyle(.timiGray)
            }
            // 댓글 내용
            Text("\(comment.content)")
                .font(.subheadline)
                .foregroundStyle(.timiBlackLight)
//                .lineLimit(3)

            // 수정/삭제 버튼 (작성자만 표시)
            if let userID, userID == comment.teacherID {
                HStack {
                    Spacer()
                    Button("수정") {
                        onEditButtonTapped(comment) // 수정 버튼 클릭 시 처리
                    }

                    Text("|")

                    Button("삭제") {
                        commentVM.deleteComment(postID: comment.postID, commentID: comment.commentID) { message in
                            DispatchQueue.main.async {
                                showDeleteAlert = true
                                showDeleteMessage = message
                            }
                        }
                    }
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(
                            title: Text("댓글을 삭제하시겠습니까?"),
                            primaryButton: .default(Text("확인")) {
                                commentVM.fetchPostComments(
                                    courseID: comment.courseID,
                                    postID: comment.postID,
                                    cmDtCd: comment.cmDtCd
                                )
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
        }
        .padding()
        .background(.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    CommentRow(comment: PostComment(
        courseID: 1, postID: 11, cmDtCd: 2, commentID: 1, 
        teacherID: 11, teacherNm: "이영록",
        profileImage: "",
        content: "병원 진단서 제출해주세요", createdAt: "2024-10-11"
    ), onEditButtonTapped: { _ in })
        .environmentObject(CommentViewModel())
}
