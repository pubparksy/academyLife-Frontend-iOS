import SwiftUI
import Kingfisher

struct PostDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var postVM: PostViewModel
    @EnvironmentObject var commentVM: CommentViewModel
    @State private var isCommentInputPresented: Bool = false
    @State private var isCommentEditPresented: Bool = false
    @State private var selectedCommentID: Int? = nil // 수정할 댓글 ID
    @State private var selectedCommentContent: String = "" // 수정할 댓글 내용
    @State private var navigateToEdit = false
    @State private var navigateToDelete = false
    @State private var showEditAlert = false
    
    @State private var isDeleteAlert = false
    @State private var isPostDeleted = false
    @State private var showDeleteAlert = false
    @State private var showDeleteMessage = ""

    // 사진 저장 util
    @State private var isSavePhotoAlertPresented: Bool = false
    @State private var savePhotoMessage: String = ""

    var courseID: Int
    var postID: Int
    var cmDtCd: Int

    @AppStorage("userID") var userID: Int?
    @AppStorage("authCd") var authCd: String?

    var body: some View {
        ZStack {
            // PostDetail 메인 콘텐츠
            ScrollView {
                VStack(spacing: 20) {
                    // 게시글 제목 및 작성 정보
                    if let postComments = commentVM.postComments {
                        HStack {
                            Text(postComments.title)
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                        }

                        HStack {
                            if postComments.cmDtCd == 1 {
                                
                                HStack {
                                    ProfileImageView(userID: postComments.writerID, profileImage: postComments.profileImage, imageSize: 30)
                                    Text(postComments.writerNm)
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                }
                            } else {
                                
                                HStack {
                                    ProfileImageView(userID: postComments.writerID, profileImage: postComments.profileImage, imageSize: 30)
                                    Text(postComments.nickname)
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                }
                            }
                            
                            Spacer()
                            Text(postComments.createdAt)
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                        }
                
                        // 게시글 내용 및 사진
                        VStack(alignment: .leading, spacing: 10) {
                            Text(postComments.content)
                                .font(.body)
                                .frame(maxWidth: .infinity, alignment: .leading) // 부모의 전체 너비를 채우고 왼쪽 정렬

                            if !postComments.postImages.isEmpty {
                                ForEach(postComments.postImages, id: \.self) { imageName in
                                    if let imageURL = commentVM.imageURL(for: imageName) {
                                        KFImage(imageURL)
                                            .resizable()
                                            .scaledToFit()
                                            .contextMenu {
                                                Button(action: {
                                                    saveImageToPhotos(imageURL: imageURL)
                                                }) {
                                                    Label("사진 앱에 저장", systemImage: "square.and.arrow.down")
                                                }
                                            }
                                            .alert(isPresented: $isSavePhotoAlertPresented) {
                                                Alert(
                                                    title: Text("사진 저장"),
                                                    message: Text(savePhotoMessage),
                                                    dismissButton: .default(Text("확인"))
                                                )
                                            }
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity, alignment: .leading) // 부모 VStack과 ScrollView에서도 정렬 유지
                        
                        
                        
                        
                        // 사용자와 작성자가 동일할 때만 '수정' 버튼 표시
                        if let userID, userID == postComments.writerID {
                            HStack {
                                Spacer()
                                Button("수정") {
                                    showEditAlert = true
                                }
                                .alert(isPresented: $showEditAlert) {
                                    Alert(
                                        title: Text("게시글을 수정하시겠습니까?"),
                                        primaryButton: .default(Text("확인")) {
                                            commentVM.fetchPostComments(courseID: courseID, postID: postID, cmDtCd: cmDtCd) {
                                                
                                                navigateToEdit = true
                                            }
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                                
                                Text("|")
                                
                                
                                
                                
                                
                                Button(action: {
                                    isDeleteAlert = true
                                }) {
                                    Text("삭제")
                                        .foregroundColor(.red)
                                }
                                .alert(isPresented: $isDeleteAlert) {
                                    Alert(
                                        title: Text("정말 삭제하시겠습니까?"),
                                        message: nil,
                                        primaryButton: .destructive(Text("확인")) {
                                            // 삭제 로직 실행
                                            postVM.deletePost(postID: postID) { message in
                                                DispatchQueue.main.async {
                                                    // 삭제 결과에 따른 alert 표시
                                                    isDeleteAlert = false // 기존 alert 해제
                                                    showDeleteResultAlert(message: message)
                                                }
                                            }
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                                
                                
                                
                                
                                
                                
                            }
                        }
                        
                        
                        
                        
                        
                        
                        
                        

                        // 댓글 리스트
                        if !postComments.comments.isEmpty {
                            CommentList(comments: postComments.comments) { comment in
                                // '수정' 버튼을 눌렀을 때 처리
                                selectedCommentContent = comment.content
                                selectedCommentID = comment.commentID
                                isCommentEditPresented = true
                            }
                        }

                        // 댓글 작성 버튼
                        if let authCd, authCd == "AUTH01" && postComments.cmDtCd == 2 {
                            Button(action: {
                                isCommentInputPresented = true
                            }) {
                                Text("댓글 작성")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.accentColor)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()
            }

            // 댓글 작성 뷰
            if isCommentInputPresented {
                ZStack {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isCommentInputPresented = false
                            }
                        }

                    CommentInputView(
                        isPresented: $isCommentInputPresented,
                        courseID: courseID,
                        postID: postID,
                        cmDtCd: cmDtCd
                    ) { commentText in
                        commentVM.addComment(courseID: courseID, postID: postID, content: commentText, cmDtCd: cmDtCd)
//                        commentVM.fetchPostComments(courseID: courseID, postID: postID, cmDtCd: cmDtCd)
                        isCommentInputPresented = false
                    }
                }
                .zIndex(2)
            }

            // 댓글 수정 화면
            if isCommentEditPresented {
                ZStack {
                    Color.black.opacity(0.5) // 반투명 배경
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isCommentEditPresented = false // 배경 클릭 시 닫기
                            }
                        }

                    if let selectedCommentID {
                        CommentEditView(
                            courseID: courseID,
                            postID: postID,
                            commentID: selectedCommentID,
                            content: selectedCommentContent
                        ) { _ in
                            commentVM.fetchPostComments(courseID: courseID, postID: postID, cmDtCd: cmDtCd) {
                                isCommentEditPresented = false
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                    }
                }
                .zIndex(3)
            }

            // Navigation to PostEdit
            NavigationLink(
                destination: PostEditView(courseID: courseID, postID: postID, cmDtCd: cmDtCd),
                isActive: $navigateToEdit
            ) {
                EmptyView()
            }
        }
        .onAppear {
            commentVM.fetchPostComments(courseID: courseID, postID: postID, cmDtCd: cmDtCd)
        }
        .onChange(of: commentVM.isCommentAdded) { isCommentAfter in
            if isCommentAfter {
                commentVM.fetchPostComments(courseID: courseID, postID: postID, cmDtCd: cmDtCd)
                commentVM.isCommentAdded = false // 상태 초기화
            }
        }
    }

    private func saveImageToPhotos(imageURL: URL) {
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: imageURL)
                if let image = UIImage(data: data) {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    DispatchQueue.main.async {
                        savePhotoMessage = "사진이 성공적으로 저장되었습니다."
                        isSavePhotoAlertPresented = true
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    savePhotoMessage = "사진 저장에 실패했습니다."
                    isSavePhotoAlertPresented = true
                }
            }
        }
    }
    
    
    // 삭제 결과 alert 표시 함수
    private func showDeleteResultAlert(message: String) {
        let alert = UIAlertController(
            title: "알림",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            if postVM.isPostDeleted {
                presentationMode.wrappedValue.dismiss() // 삭제 성공 시 PostList로 이동
            }
        }))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}

#Preview {
    PostDetailView(courseID: 1, postID: 11, cmDtCd: 2)
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationViewModel())
        .environmentObject(AttendanceViewModel())
        .environmentObject(CommonDetailCodeViewModel())
        .environmentObject(CourseViewModel())
        .environmentObject(PostViewModel())
        .environmentObject(CommentViewModel())
}
