import SwiftUI

struct PostListView: View {
    @EnvironmentObject var commentDetailVM: CommonDetailCodeViewModel
    @EnvironmentObject var postVM: PostViewModel
    @EnvironmentObject var commentVM: CommentViewModel

    var courseID: Int
    var cmDtCd: Int

    @AppStorage("authCd") var authCd: String?

    var body: some View {
        NavigationView {
            List {
                if postVM.coursePosts.isEmpty {
                    Text("게시글이 없습니다.")
                        .padding()
                } else {
                    ForEach(postVM.coursePosts) { coursePost in
                        PostRowLink(coursePost: coursePost, cmDtCd: cmDtCd)
                            .onAppear {
                                if coursePost == postVM.coursePosts.last {
                                    postVM.fetchPosts(cID: courseID, cmDtCd: cmDtCd)
                                }
                            }
                    }
                }
            }
            .onAppear {
                postVM.fetchPosts(cID: courseID, cmDtCd: cmDtCd) // 초기 데이터 로드
            }
            .alert("게시판 목록", isPresented: $postVM.isFetchError) {
                Button("확인") {}
            } message: {
                Text(postVM.message)
            }
        }
        .navigationTitle(postVM.viewTitle)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if shouldShowAddButton() {
                    NavigationLink(destination: {
                        PostAddView(courseID: courseID, cmDtCd: cmDtCd)
                            .navigationBarTitle("게시글 등록")
                            .navigationBarTitleDisplayMode(.inline)
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    private func shouldShowAddButton() -> Bool {
        if authCd == "AUTH01", // 선생님 권한은 항상 표시
           cmDtCd == 1 { // 상세 코드가 1일 때만 표시
            return true
        }

        if authCd == "AUTH02", // 학생 권한이면서
           cmDtCd == 2 { // 상세 코드가 2일 때만 표시
            return true
        }

        return false // 기본값
    }
}

struct PostRowLink: View {
    var coursePost: CoursePost
    var cmDtCd: Int

    var body: some View {
        NavigationLink(
            destination: PostDetailView(
                courseID: coursePost.courseID,
                postID: coursePost.postID,
                cmDtCd: cmDtCd
            ).navigationBarTitleDisplayMode(.inline)
        ) {
            PostRowView(coursePost: coursePost)
        }
    }
}

#Preview {
    PostListView(courseID: 1, cmDtCd: 1)
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationViewModel())
        .environmentObject(AttendanceViewModel())
        .environmentObject(CommonDetailCodeViewModel())
        .environmentObject(CourseViewModel())
        .environmentObject(PostViewModel())
        .environmentObject(CommentViewModel())
}
