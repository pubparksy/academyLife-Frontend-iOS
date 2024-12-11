//
//  Teacher.swift
//  Academy-Life
//
//  Created by SeYeong's MacBook on 11/30/24.
//

struct Teacher: Codable {
    var userName: String
    var userID: Int
}

struct TeacherRoot: Codable {
    var success: Bool
    var teachers: [Teacher]
    var message: String
}
