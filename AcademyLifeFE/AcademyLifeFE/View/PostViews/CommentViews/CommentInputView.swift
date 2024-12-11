import SwiftUI

struct CommentInputView: View {
    @Binding var isPresented: Bool
    @State private var commentText: String = ""
    var courseID: Int
    var postID: Int
    var cmDtCd: Int
    var onAddComment: (String) -> Void

    var body: some View {
        VStack {
            TextField("댓글을 입력하세요...", text: $commentText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                onAddComment(commentText)
                isPresented = false
            }) {
                Text("댓글 등록")
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
            }
            .disabled(commentText.isEmpty)
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .padding(16)
        .frame(width: UIScreen.main.bounds.width * 0.9)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}


#Preview {
    CommentInputView(
        isPresented: .constant(true), // Binding으로 테스트 가능한 값
        courseID: 1,                 // 임의의 정수값
        postID: 11,                  // 임의의 정수값
        cmDtCd: 2,                   // 임의의 정수값
        onAddComment: { comment in   // 예제 클로저
//            print("Added Comment: \(comment)")
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
