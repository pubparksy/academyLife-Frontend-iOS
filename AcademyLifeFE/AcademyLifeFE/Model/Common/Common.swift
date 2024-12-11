import Foundation

/** 권한 모델 */
struct AuthCode: Codable{
    let authID: String
    let authName: String
}


/** 공통코드 모델  */
struct CommonCodeRoot: Codable {
    let success: Bool
    let documents: CommonCode
    let message : String
}

struct CommonCode: Codable {
    let cmCd : String
    let cmName: String
    let cmDts : [CommonDetailCode]
}

struct CommonDetailCode: Codable, Identifiable {
    var id: Int { cmDtCd }
    let cmDtCd : Int
    let cmDtName: String
}


/** 오류 모델 */
struct APIError: Codable {
    let message: String
}
