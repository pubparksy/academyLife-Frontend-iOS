import Foundation

struct AttendanceRoot: Codable {
    let success: Bool
    let documents: AttendanceUserCourses
    let message: String
}

struct AttendanceUserCourses: Codable {
    let userID: Int
    let userName: String
    let courses: [AttendanceCourse]
}

struct AttendanceCourse: Codable, Identifiable{
    var id: Int { courseID }
    let courseID:Int
    let courseName: String
    let startDate : String?
    let endDate : String?
    let isCourseDateToday: Bool
    let entryStatus: Bool?
    let exitStatus: Bool?
}

struct EntryExitRoot:Codable {
    let success: Bool
    let message: String
}

struct AttendanceNotEntryRoot: Codable {
    let success: Bool
    let documents: [AttendanceNotEntry]
    let message: String
}

struct AttendanceNotEntry: Codable, Identifiable {
    var id : Int { courseID + userID }
    let courseID: Int
    let userID: Int
    let userName: String
    let profileImage: String
    let mobile: String
}

