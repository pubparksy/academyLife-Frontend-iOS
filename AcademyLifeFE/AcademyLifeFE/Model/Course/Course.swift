
struct CourseByUserID:Codable {
    var id: Int
    var cmDtCd: Int
    var cmDtName: String
    var courseName: String
    var courseDesc: String
    var startDate: String
    var endDate: String
    var userID: Int
    var teacherName: String
}

struct MyPage: Codable {
    var userID: Int
    var userName: String
    var profileImage: String
    var courses: [CourseByUserID]
}

struct CourseRootForUserID: Codable {
    var success: Bool
    var courses: MyPage
    var message: String
}


struct Course: Codable, Equatable {
    var id: Int
    var cmDtCd: Int
    var courseName: String
    var courseDesc: String
    var startDate: String
    var endDate: String
    var userID: Int
}

struct CourseRoot: Codable {
    var success: Bool
    var courses: [Course]
    var message: String
}

