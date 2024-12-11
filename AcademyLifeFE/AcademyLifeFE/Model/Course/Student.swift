//
//  Student.swift
//  Academy-Life
//
//  Created by SeYeong's MacBook on 11/30/24.
//
struct Student: Codable, Equatable {
   
    var id: Int
    var courseID: Int
    var userID: Int
    var createdAt: String
    var updatedAt: String
    var User: UserInfo
    
}

struct StudentForCourseID: Codable {
    var students: [Student]
}

struct StudentList {
    var userID:Int
    var userName: String
    var mobile: String
    var isChecked:Bool
}

struct StudentInfo: Codable {
    var userID: Int
    var courseID: Int
}

struct UserInfo: Codable, Equatable {
    var userID: Int
    var userName: String
    var mobile: String
}

//get students by teacher 할 때
struct StudentRoot: Codable {
    var success: Bool
    var users: [UserInfo]
    var students: [StudentInfo]
    var message: String
}

