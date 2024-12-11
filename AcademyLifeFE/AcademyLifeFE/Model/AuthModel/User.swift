//
//  User.swift
//  Academy-Life
//
//  Created by 서희재 on 11/20/24.
//

import Foundation

struct User: Codable {
    var userID: Int = 0
    var email: String = ""
    var authCd: String = ""
    var userName: String = ""
    var nickname: String = ""
    var mobile: String = ""
    var kakao: String?
    var apple: String?
    var profileImage: String?
}

struct LoginResult: Codable {
    let token: String
    let user: User
}

struct UserResult: Codable {
    let user: User
}

struct SocialAuthResult: Codable {
    let token: String?
    let user: User?
    let loginMethod: String
    let socialID: String
}

struct ProfileImageUploadResult: Codable {
    let profileImage: String?
}

enum LoginMethod: String {
    case kakao = "kakao"
    case apple = "apple"
    case timi = "timi"
    
    static func message(for loginMethod: LoginMethod) -> String {
        return loginMethod.rawValue
    }
}
