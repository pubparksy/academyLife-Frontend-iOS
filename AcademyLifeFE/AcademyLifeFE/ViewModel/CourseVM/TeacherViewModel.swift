//
//  TeacherViewModel.swift
//  Academy-Life
//
//  Created by SeYeong's MacBook on 11/27/24.
//

import SwiftUI
import Alamofire

class TeacherViewModel: ObservableObject {
    @Published var message: String = ""
    @Published var teachers: [Teacher] = []
    @Published var isFetchError: Bool = false

    @AppStorage("token") var token: String?
    @AppStorage("userID") var userID: Int?
    let host = AppConfig.baseURL
    
   
    // 선생님 목록 가져오기
    func getTeachers(){
        guard let token else { return }
        let url = "\(host)/teacher/num/1"
        let headers: HTTPHeaders = [
                "Authorization": "\(token)"
            ]
        
        AF.request(url, method: .get, headers: headers)
                .responseDecodable(of: TeacherRoot.self) { response in
                    switch response.result {
                    case .success(let root):
                        self.teachers = root.teachers
                    case .failure(let error):
                        self.isFetchError = true
                        self.message = error.localizedDescription
                    }
                }
        }
    
}
