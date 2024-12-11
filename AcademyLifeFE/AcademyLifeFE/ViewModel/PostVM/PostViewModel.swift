import SwiftUI
import Alamofire
import SVProgressHUD

class PostViewModel: ObservableObject {
    @EnvironmentObject var commentVM: CommentViewModel
    @Published var viewTitle:String = ""
    @Published var coursePosts:[CoursePost] = []
    
    // 예전엔 옵셔널로 했지만 그땐 기존에 담긴거 날리고 새로 가져온거 담았기 때문이지만,
    // 이번엔 무한스크롤할거라 옵셔널로 안함. 받아온 걸 현재 Array에 추가 시켜야 쌓이기 때문에 빈 배열 만듦.
    @Published var message = "" // 데이터가 없을 때 alert로 보여주기 위한 message 변수
    
    // Swift는 상황에 따른 여러 alert를 띄우려면 여러 변수를 주구장창 만들어야한다고.. alert 띄우냐 마냐 조건 변수들
    @Published var isFetchError = false      //
    @Published var isAddShowing = false  // addPost함수에서 쓸거
    @Published var isPostDeleted = false    // delete 함수에서 성공,실패 alert를 보여주기 위한 변수
    
    // 스크롤 내리는 도중에 또 로딩하면 안되니까 그걸 막는 변수
    private var isLoading = false
    private var page = 1

    
    
    
    @AppStorage("token") var token:String?
    @AppStorage("userID") var userID:String?
    @AppStorage("authCd") var authCd: String?

    // 게시글 조회 (게시글들만 조회, 댓글까지 NO)
    func fetchPosts(cID:Int, cmDtCd:Int, size:Int = 10) {
        SVProgressHUD.show()
        guard !isLoading else { return } // fetchSales의 로딩이 동작중이면 fetchSales 동작 중단.
        isLoading = true // fetchSales의 로딩이 시작한다. 나중에 fetchSales의 로딩이 끝나면 false로 해서 빠져나가게 만들어야함.
        
        let endPoint = "\(AppConfig.baseURL)/posts"
        guard let token = self.token,
              let userID = self.userID,
              let authCd = self.authCd
            else { return }
        
        let params:Parameters = ["courseID": "\(cID)", "cmDtCd": "\(cmDtCd)", "userID":userID, "page":self.page, "size":size,]
        let headers:HTTPHeaders = [
            "Authorization":"\(token)",
            "AUTHCD" : authCd,
            "Content-Type":"application/json"
        ] // 이미 Bearer 추가
        
        AF.request(endPoint, method: .get, parameters: params, headers: headers)
            .responseDecodable(of: CoursePostsRoot.self) { response in
                    switch response.result {
                        case .success(let result):
                            self.viewTitle = "\(result.documents.courseName) - \(result.documents.cmDtName)"

//                          self.coursePosts.append(contentsOf: result.documents.coursePosts)
//                          (원랜 배열은 반복문 담기인데...) contentsOf: 배열 그자체 통으로,,, 근데 여기서 append해버리면 계속 더하기만 됨. 그냥 초기화.
                            self.coursePosts = result.documents.coursePosts

                            self.page += 1
                        
                            if self.coursePosts.isEmpty {
                                self.isFetchError = true
                                self.message = "등록된 글이 없습니다."
                            }
                        case .failure(let error):
                            self.isFetchError = true
                            self.message = error.localizedDescription
                }
                self.isLoading = false // fetchSales의 로딩이 끝났다. < 라고 해주는 것
                SVProgressHUD.dismiss()
            }
        
    }
    
    
    // 게시글 등록
    func addPost(cID: Int, cmDtCd: Int, title: String?, content: String?, images: [UIImage], completion: @escaping (Bool, String?) -> Void) {
        SVProgressHUD.show()
        guard let token,
              let userID,
              let title,
              let content
        else {
            completion(false, "유효하지 않은 요청입니다.")
            return
        }

        let endpoint = "\(AppConfig.baseURL)/posts"
        let headers: HTTPHeaders = [
            "Authorization": "\(token)",
            "Content-Type": images.isEmpty ? "application/json" : "multipart/form-data"
        ]

        if images.isEmpty {
            // JSON 전송
            let parameters: [String: Any] = [
                "courseID": cID,
                "cmDtCd": cmDtCd,
                "userID": userID,
                "title": title,
                "content": content
            ]

            AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .response { response in
                    SVProgressHUD.dismiss()
                    DispatchQueue.main.async {
                        if let statusCode = response.response?.statusCode, statusCode >= 200 && statusCode < 300 {
                            completion(true, "게시글이 성공적으로 등록되었습니다.")
                        } else {
                            completion(false, "게시글 등록에 실패했습니다.")
                        }
                    }
                }
        } else {
            // Multipart 전송
            let formData = MultipartFormData()
            formData.append("\(cID)".data(using: .utf8)!, withName: "courseID")
            formData.append("\(cmDtCd)".data(using: .utf8)!, withName: "cmDtCd")
            formData.append(userID.data(using: .utf8)!, withName: "userID")
            formData.append(title.data(using: .utf8)!, withName: "title")
            formData.append(content.data(using: .utf8)!, withName: "content")

            for image in images {
                if let imageData = image.jpegData(compressionQuality: 0.5) {
                    formData.append(imageData, withName: "images", fileName: "image.jpg", mimeType: "image/jpeg")
                }
            }

            AF.upload(multipartFormData: formData, to: endpoint, headers: headers)
                .response { response in
                    SVProgressHUD.dismiss()
                    DispatchQueue.main.async {
                        if let statusCode = response.response?.statusCode, statusCode >= 200 && statusCode < 300 {
                            completion(true, "게시글이 성공적으로 등록되었습니다.")
                        } else {
                            completion(false, "게시글 등록에 실패했습니다.")
                        }
                    }
                }
        }
    }
    
    
    
    // 게시글 수정
    func editPost(postID: Int, title: String, content: String, existingFileNames: [String]?, newImages: [UIImage]?, completion: @escaping (Bool) -> Void) {
        SVProgressHUD.show()
        guard let token
            else {
            completion(false)
            return
        }
        
        let endPoint = "\(AppConfig.baseURL)/posts/\(postID)"
        let headers: HTTPHeaders = ["Authorization": token]
        
        
        
        let formData = MultipartFormData()
        // 텍스트 데이터 추가
        formData.append(title.data(using: .utf8)!, withName: "title")
        formData.append(content.data(using: .utf8)!, withName: "content")
        // 기존 파일 이름 추가
        if let existingFileNames = existingFileNames, !existingFileNames.isEmpty {
            let fileNamesString = existingFileNames.joined(separator: ",")
            formData.append(fileNamesString.data(using: .utf8)!, withName: "fileName")
        }
        // 새로 추가된 이미지 데이터를 멀티파트로 추가
        if let newImages = newImages {
            for (index, image) in newImages.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    formData.append(imageData, withName: "fileName", fileName: "image\(index).jpg", mimeType: "image/jpeg")
                }
            }
        }
        
        AF.upload(multipartFormData: formData, to: endPoint, method: .put, headers: headers)
            .responseDecodable(of: PostSuccessFailure.self) { response in
                switch response.result {
                    case .success(let result):
                        DispatchQueue.main.async {
                            self.message = result.message
                            completion(true)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.message = "게시글 수정 실패: \(error.localizedDescription)"
                            completion(false)
                        }
                }
        }
        SVProgressHUD.dismiss()
    }
    
    

    
    // 게시글 삭제
    func deletePost(postID: Int, completion: @escaping (String) -> Void) {
        SVProgressHUD.show()
        guard let token else {
            completion("권한이 없습니다.")
            return
        }

        let endPoint = "\(AppConfig.baseURL)/posts/\(postID)"
        let headers: HTTPHeaders = ["Authorization": token]

        AF.request(endPoint, method: .delete, headers: headers)
            .responseDecodable(of: PostSuccessFailure.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let result):
                        if result.success {
                            self.isPostDeleted = true
                        } else {
                            self.isPostDeleted = false
                        }
                        completion(result.message)
                    case .failure(let error):
                        self.isPostDeleted = false
                        completion("게시글 삭제 실패: \(error.localizedDescription)")
                    }
                    SVProgressHUD.dismiss()
                }
            }
    }
    
    
    
    
}
