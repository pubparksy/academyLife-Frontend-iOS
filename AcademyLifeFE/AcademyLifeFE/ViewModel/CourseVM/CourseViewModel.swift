//
//  CourseViewModel.swift
//  Academy-Life
//
//  Created by SeYeong's MacBook on 11/24/24.
//

import SwiftUI
import Alamofire
import SVProgressHUD

class CourseViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var message: String = ""
    @Published var courses: [CourseByUserID] = []
    @Published var profileImage: String = ""
    
    @Published var isCourseAdded: Bool = false
    @Published var addCourseError: Bool = false
    @Published var isCourseDeleted: Bool = false
    @Published var isCourseUpdated: Bool = false
    
    @AppStorage("token") var token: String?
    @AppStorage("userID") var userID: Int?
    let host = AppConfig.baseURL
    
    // 강좌 목록 가져오기
    func getCourse(userID: Int) {
        SVProgressHUD.show()
        guard let token else { return }
        let url = "\(host)/courses/\(userID)"
        let headers : HTTPHeaders  = ["Authorization": "\(token)"]
        AF.request(url, method: .get, headers: headers).responseDecodable(of: CourseRootForUserID.self) { response in
            SVProgressHUD.dismiss()
            DispatchQueue.main.async {
                switch response.result {
                case .success(let root):
                    
                    self.profileImage = root.courses.profileImage
                    self.userName = root.courses.userName
                    
                    if !root.courses.courses.isEmpty {
                        self.courses = root.courses.courses
                    } else {
                        self.courses = []
                    }
                    
                 case .failure(let error):
                    self.message = error.localizedDescription
                }
            }
            
        }
    }
    
    
    
    // 강좌 삭제하기
    func deleteCourse(courseID: Int) {
        SVProgressHUD.show()
       
        guard let token else { return }
        let url = "\(host)/courses/\(courseID)"
        let headers: HTTPHeaders = [
            "Authorization" : "\(token)",
            "Content-Type" : "application/json"
        ]

            AF.request(url, method: .delete, headers: headers).responseData(completionHandler: { response in
                SVProgressHUD.dismiss()
               
                switch response.result {
                case .success:
                    self.isCourseDeleted = true
                    self.message = "강좌가 삭제되었습니다."
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        
     
    }
    
    
    // 강좌 추가하기
    func addCourse(cmDtCd: Int, courseName: String, courseDesc:String, startDate:Date, endDate:Date, teacherID userID: Int){
        SVProgressHUD.show()
        guard let token else { return }
        
        let url = "\(host)/courses"
        let params: Parameters = [
            "courseName": courseName,
            "cmDtCd": cmDtCd,
            "courseDesc": courseDesc,
            "startDate": dateFormatter.string(from: startDate),
            "endDate": dateFormatter.string(from: endDate),
            "userID": userID
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "\(token)",
            "Content-Type": "application/json"
        ]
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers )
            .response { response in
                SVProgressHUD.dismiss()
                
                DispatchQueue.main.async {
                    switch response.result {
                    case .success:
                        self.isCourseAdded = true
                    case .failure(let error):
                        print("강좌 추가 실패")
                        self.addCourseError = true
                        self.message = error.localizedDescription
                    }
                }
            }
    }
    
    // 강좌 수정하기
    func updateCourse(courseID:Int, cmDtCd: Int, courseName: String, courseDesc:String, startDate:Date, endDate:Date, teacherID userID: Int) {
        SVProgressHUD.show()
       
        guard let token else { return }
        
        let url = "\(host)/courses/\(courseID)"
        let params: Parameters = [
            "courseName": courseName,
            "cmDtCd": cmDtCd,
            "courseDesc": courseDesc,
            "startDate": dateFormatter.string(from: startDate),
            "endDate": dateFormatter.string(from: endDate),
            "userID": userID
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "\(token)",
            "Content-Type": "application/json"
        ]
        
        
        AF.request(url, method: .put, parameters: params,encoding: JSONEncoding.default, headers: headers)
            .response { response in
                SVProgressHUD.dismiss()
                DispatchQueue.main.async {
                    
                
                switch response.result {
                case .success:
                    if let index = self.courses.firstIndex(where: { $0.id == courseID }) {
                                            // 수정된 강좌 정보를 배열에 반영
                                            self.courses[index] = CourseByUserID(
                                                id: courseID,
                                                cmDtCd: cmDtCd,
                                                cmDtName: self.courses[index].cmDtName, // 변경하지 않은 값 그대로 사용
                                                courseName: courseName,
                                                courseDesc: courseDesc,
                                                startDate: dateFormatter.string(from: startDate),
                                                endDate: dateFormatter.string(from: endDate),
                                                userID: userID,
                                                teacherName: self.courses[index].teacherName // 변경하지 않은 값 그대로 사용
                                            )
                                        }
                    self.isCourseUpdated = true
                    
                    print("강좌 수정 성공")
                case .failure(let error):
                    self.message = error.localizedDescription
                }
                }
            }
    }
    
    
}
