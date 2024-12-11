import SwiftUI
import Alamofire
import SVProgressHUD

class CommentViewModel: ObservableObject {
    @Published var postComments:PostComments?
    @Published var comments:[PostComment] = []
    @Published var postImages:[String] = []
    
    @Published var message = "" // 데이터가 없을 때 alert로 보여주기 위한 message 변수
    
    // Swift는 상황에 따른 여러 alert를 띄우려면 여러 변수를 주구장창 만들어야한다고 함ㅋㅋㅋ
    // alert 띄우냐 마냐 조건 변수들...
    @Published var isFetchError = false      //
    @Published var isShowingSales = false    // addSale 함수에서 성공,실패 alert를 보여주기 위한 변수
    
    // 스크롤 내리는 도중에 또 로딩하면 안되니까 그걸 막는 변수
    private var isLoading = false
    private var page = 1

    @Published var isCommentAdded: Bool = false // 댓글 신규 작성 여부
    
    @AppStorage("token") var token:String? // UserDefault를 쓰느냐, @AppStorage를 쓰느냐.. 큰 차이는 없고,,, 2개 다 써야하는 경우도 있음...
    @AppStorage("userID") var userID: Int?
    @AppStorage("authCd") var authCd: String?

    // 1개 게시글 정보 & 댓글들 조회
    func fetchPostComments(courseID: Int, postID: Int, cmDtCd: Int, completion: (() -> Void)? = nil) {
        SVProgressHUD.show()
        guard !isLoading else { return } // fetchSales의 로딩이 동작중이면 fetchSales 동작 중단.
        isLoading = true // fetchSales의 로딩이 시작한다. 나중에 fetchSales의 로딩이 끝나면 false로 해서 빠져나가게 만들어야함.
        
        self.comments = []
        self.postComments = nil
        
        let endPoint = "\(AppConfig.baseURL)/post/\(postID)/comments"
        guard let token = self.token else { return } // 이 라인에서 guard let 하는 순간 UserDefault의 key 값을 읽어서 언래핑
        
        let params:Parameters = ["courseID":courseID,"postID":postID, "cmDtCd":cmDtCd]
        let headers:HTTPHeaders = ["Authorization":"\(token)"] // 이미 Bearer 포함
        
        AF.request(endPoint, method: .get, parameters: params, headers: headers)
            .responseDecodable(of: PostCommentsRoot.self) { response in
                    switch response.result {
                    case .success(let result):
                        self.postComments = result.documents
                        self.comments = result.documents.comments
                        self.postImages = result.documents.postImages
                        completion?() // 데이터 로드 성공 시 completion 호출
                        
                    case .failure(let error):
                        self.isFetchError = true
                        self.message = "Error \(error.localizedDescription): 데이터 로드 실패"
                        completion?() // 실패 시에도 호출
                    }
                self.isLoading = false
            }
        SVProgressHUD.dismiss()
    }
    
    // 파일명으로 storage blob container url 가져오는 함수
    func imageURL(for document: String) -> URL? {
        SVProgressHUD.show()
        let imageUrlString = "https://\(AppConfig.blobContainerDomain)/academylife/\(document)"
//        print("\(document) > ", imageUrlString) // 왜 2번 호출되쥐..?
        SVProgressHUD.dismiss()
        return URL(string: imageUrlString)
    }

    
    // 댓글 신규 작성
    func addComment(courseID: Int, postID: Int, content: String, cmDtCd: Int) {
        SVProgressHUD.show()
        guard let token,
              let userID
        else { return }

        let endpoint = "\(AppConfig.baseURL)/post/\(postID)/comment"
        let params: [String: Any] = ["courseID": courseID, "postID": postID, "userID": userID, "content": content ]
        let headers: HTTPHeaders = ["Authorization": token]

        AF.request(endpoint, method: .post, parameters: params, headers: headers)
            .responseDecodable(of: CommentSuccessFailure.self) { response in
                switch response.result {
                case .success:
                    DispatchQueue.main.async {
                        self.isCommentAdded = true // 댓글 상태를 설정
                    }
                    SVProgressHUD.dismiss()
                case .failure(let error):
                    print("댓글 등록 실패: \(error.localizedDescription)")
                    SVProgressHUD.dismiss()
                }
            }
    }
    
    
    // 댓글 수정
    func editComment(postID: Int, commentID: Int, content: String, completion: @escaping (String) -> Void) {
        SVProgressHUD.show()
        guard let token,
              let userID
            else {
            completion("권한이 없습니다.")
            return
        }

        let endPoint = "\(AppConfig.baseURL)/post/\(postID)/comment/\(commentID)"
        let headers: HTTPHeaders = ["Authorization": token]
        let parameters: Parameters = [ "content": content, "userID": userID ]
        
        AF.request(endPoint, method: .put, parameters: parameters, headers: headers)
            .responseDecodable(of: CommentSuccessFailure.self) { response in
                switch response.result {
                    case .success(let result):
                        DispatchQueue.main.async {
                            self.message = result.message
                            completion(self.message)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.message = "댓글 삭제 실패: \(error.localizedDescription)"
                            completion(self.message)
                        }
                }
        }
        SVProgressHUD.dismiss()
    }
    
    
    
    // 댓글 삭제
    func deleteComment(postID: Int, commentID: Int, completion: @escaping (String) -> Void) {
        SVProgressHUD.show()
        guard let token,
              let userID
            else {
            completion("권한이 없습니다.")
            return
        }

        let endPoint = "\(AppConfig.baseURL)/post/\(postID)/comment/\(commentID)/\(userID)"
        let headers: HTTPHeaders = ["Authorization": token]
        
        AF.request(endPoint, method: .delete, headers: headers)
            .responseDecodable(of: CommentSuccessFailure.self) { response in
                switch response.result {
                    case .success(let result):
                        DispatchQueue.main.async {
                            completion(self.message)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.message = "댓글 삭제 실패: \(error.localizedDescription)"
                            completion(self.message)
                        }
                }
        }
        SVProgressHUD.dismiss()
    }
    
    
    
    
}
