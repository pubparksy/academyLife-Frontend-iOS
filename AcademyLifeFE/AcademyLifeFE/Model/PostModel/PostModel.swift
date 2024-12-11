import Foundation

struct CoursePostsRoot: Codable{
    let success: Bool
    let documents: CoursePosts
    let message: String
}

struct CoursePosts: Codable, Identifiable, Equatable {
    var id: Int { courseID + cmDtCd}
    let courseID: Int
    let courseName: String
    let cmDtCd: Int
    let cmDtName: String
    let coursePosts: [CoursePost]
}

struct CoursePost: Codable, Identifiable, Equatable {
    var id: Int { postID }
    let courseID: Int
    let cmDtCd: Int
    let postID: Int
    let title: String
    let content: String
    let writerID: Int
    let writerNm: String
    let profileImage: String
    let createdAt: String
}

/** 게시글 등록수정삭제 - 성공/실패  모델 */
struct PostSuccessFailure: Codable {
    let success: Bool
    let message: String
}



/** 상세글 조회 onAppear 때 CommentVM.fetchPostComments 호출 -  글 1개, 댓글 여러개(Optional) */
struct PostCommentsRoot: Codable{
    let success: Bool
    let documents: PostComments
    let message: String
}

struct PostComments: Codable {
    let courseID: Int
    let courseNm: String
    let cmDtCd: Int
    let cmDtNm: String
    let postID: Int
    var title: String
    var content: String
//    let photo: String?
    var postImages: [String]
    let writerID: Int
    let writerNm: String
    let nickname: String
    let profileImage: String
    let createdAt: String
    var comments: [PostComment]
}

/** 댓글 모델 */
struct PostComment: Codable, Identifiable, Equatable {
    var id: Int { postID + commentID }
    let courseID: Int
    let postID: Int
    let cmDtCd: Int
    let commentID: Int
    let teacherID: Int
    let teacherNm: String
    let profileImage: String
    let content: String
    let createdAt: String
}


/** 댓글 등록수정삭제 - 성공/실패  모델 */
struct CommentSuccessFailure: Codable {
    let success: Bool
    let message: String
}
