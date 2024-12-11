//
//  StudentViewModel.swift
//  Academy-Life
//
//  Created by SeYeong's MacBook on 11/30/24.
//

import SwiftUI
import Alamofire
import SVProgressHUD

class StudentViewModel: ObservableObject {
    @Published var message: String = ""
    @Published var students: [StudentInfo] = []
    @Published var studentsForCourse: [Student] = []
    @Published var users: [UserInfo] = []
    @Published var studentList:[StudentList] = []
    @Published var selectedUserIDs: [Int] = []
    @Published var isStudentAdded: Bool = false
    
    @AppStorage("token") var token: String?
    @AppStorage("userID") var userID: Int?
    let host = AppConfig.baseURL
    
    
    // 학생 목록 가져오기
    func getStudents(teacherID userID: Int, courseID: Int, completion: @escaping () -> Void) {
        SVProgressHUD.show()
        guard let token else { return }
        let url = "\(host)/teacher/\(userID)/\(courseID)/students"
        let headers: HTTPHeaders = ["Authorization": "\(token)"]
        
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: StudentRoot.self) { response in
               SVProgressHUD.dismiss()
               switch response.result {
                case .success(let root):
                    var updatedStudentList: [StudentList] = []
                    self.users = root.users
                    self.students = root.students
                    self.selectedUserIDs = self.students.map{ student in
                        student.userID
                    }
                    
                    self.users.forEach { user in
                        let isChecked = self.selectedUserIDs.contains(user.userID)
                        let studentlist = StudentList(userID: user.userID, userName: user.userName, mobile: user.mobile, isChecked: isChecked)
                        updatedStudentList.append(studentlist)
                    }
                    self.studentList = updatedStudentList
                   completion()
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
    }
    
    // 학생 추가하기
    func addStudents(userID: [Int], courseID: Int){
            guard let token else { return }
            let url = "\(host)/teacher/save/students"
            let headers: HTTPHeaders = ["Authorization": "\(token)", "Content-Type": "application/json"]
            let students: [[String:Int]] = userID.map { ["userID": $0] }
            let params: Parameters = ["courseID": courseID, "students": students]
            
            AF.request(url, method: .post, parameters: params , encoding: JSONEncoding.default ,headers: headers)
                .response { response in
                    switch response.result {
                    case .success:
                        if self.selectedUserIDs.isEmpty {
                            
                        }
                        self.isStudentAdded = true
                        self.message = "수강생 정보가 저장되었습니다."
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
        }
    
    
    // 강좌 수강중인 학생 가져오기
    func getStudentsForCourse(courseID: Int, completion: @escaping (Bool) -> Void){
        guard let token else { return }
        let url = "\(host)/student/course/\(courseID)"
        let headers: HTTPHeaders = [ "Authorization" : "\(token)" ]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: StudentForCourseID.self) { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let root):
                    
                    if !root.students.isEmpty {
                        self.message = "수강중인 학생이 있습니다."
                        self.studentsForCourse = root.students
                        print(self.studentsForCourse)
                        completion(true)
                    } else {
                        self.studentsForCourse = []
                        print(self.studentsForCourse)
                        completion(false)
              
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(true)
                }
            }
       
        }
    }
}
