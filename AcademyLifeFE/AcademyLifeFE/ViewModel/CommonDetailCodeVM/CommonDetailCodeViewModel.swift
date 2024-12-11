import SwiftUI
import Alamofire

class CommonDetailCodeViewModel: ObservableObject {
    @Published var cmDts: [CommonDetailCode] = []
    @Published var cmDtNames: [String] = []
    
    @AppStorage("token") var token: String?
    @AppStorage("authCd") var authCd: String?
    
    func getCmDtNms(number: Int) { // CMCD0 + number = CMCD01
        let host = AppConfig.baseURL
        let url = "\(host)/common/\(number)"
        
        guard let token,
              let authCd
            else { return }
        let headers: HTTPHeaders = ["Authorization": "\(token)", "AUTHCD" : authCd]
        
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: CommonCodeRoot.self) { response in
                switch response.result {
                    case .success(let result):
                        if result.success {
                            self.cmDts = result.documents.cmDts
                            
//                          상세코드 이름만 String으로 모은 배열
//                          self.cmDtNames = result.documents.cmDts.map { $0.cmDtName }
                        } else {
                            print(result.message)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                }
        }
    }
}

/**   View, ViewModel에서 사용 예시 소스

1.  cmDtCd를 받아서 사용해야하는 ViewModel
class SampleViewModel: ObservableObject {
    // 굳이 변수 선언 안해도 되고, 함수 인자로만 받아도 됨.

    func saveData(courseNm: String, courseDesc: String, selectedCmDtCd: Int) {
        // 서버로 데이터 전송 로직 구현
        print("강좌: \(courseNm), 설명: \(courseDesc), 상세코드: \(selectedCmDtCd)")
    }
}


2. View
struct SampleView: View {
    @StateObject var cmDtVM = CmDtViewModel() // 공통코드 ViewModel
    @StateObject var sampleVM = SampleViewModel()   // 가져다 사용할 Sample VM
    @State private var selectedDetail: CommonDetailCode? = nil  // Picker 선택값  (@State Optional에 nil 안쓰면 컴파일러오류)
     
    @State private var courseNm: String = ""    // 사용자 입력값 바인딩
    @State private var courseDesc: String = "" // 사용자 입력값 바인딩

    var body: some View {
        VStack {
        Picker("강좌 카테고리 선택", selection: $selectedDetail) { // 선택한 detail 객체를 selectedDetail에 바인딩
            ForEach(cmCdVM.cmDts) { detail in   // detail 1 : {1, "조리"}, detail 2 : {2, "정보통신"} ...
                Text(detail.cmDtName) // 사용자에게 보이는 글자
                    .tag(Optional(detail)) // 사용자가 선택한 객체를 태그로 설정
                }
        } .pickerStyle(MenuPickerStyle()) // 스타일 선택

        TextField("이름", text: $courseNm)
        TextField("설명", text: $courseDesc)

        Button("저장") {
            if let selectedDetail { // Optional Unrapping
                // print("전송할 상세코드: \(selectedDetail.cmDtCd)") // 서버로 전송할 값
                sampleVM.saveData(courseNm: "iOS",
                               courseDesc: courseDesc,
                               selectedDetail: selectedDetail.cmDtCd)
                               //  선택된 상세코드를 함수 인자에 추가해서 넘김
                }
            }
        }
        .onAppear {
            // 화면이 처음 나타날 때, CMCD02 상세코드 목록을 가져옴
            cmDtVM.getCmDtNms(number: 2)
        }
    }
}
*/
