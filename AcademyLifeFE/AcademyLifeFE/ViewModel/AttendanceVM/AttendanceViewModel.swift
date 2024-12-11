import SwiftUI
import Alamofire
import Foundation
import CoreLocation
import SVProgressHUD

class AttendanceViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var isBeaconInRange: Bool = false // Beacon 영역 내 여부
    @Published var showEntryButton: Bool = false // '입실' 버튼 상태
    @Published var showExitButton: Bool = false // '퇴실' 버튼 상태

    @Published var attendanceCourses: [AttendanceCourse] = []      // 학생, 강사가 속한 '강좌 목록'
    @Published var attendanceNotEntries: [AttendanceNotEntry] = [] // 미입실 '학생 목록'
    @Published var entryExitMessage: String?
    @Published var studentCourseMessage: String?
    @Published var teacherCourseMessage: String?
    @Published var teacherCourseStudentMessage: String = ""
    
    @AppStorage("token") var token: String?
    @AppStorage("userID") var userID: Int?
    @AppStorage("authCd") var authCd: String?
    
    var locationManager: CLLocationManager?
    let beaconUUID = UUID(uuidString: "e2c56db5-dffb-48d2-b060-d0f5a71096e0")!
    let beaconMajor: CLBeaconMajorValue = 40011
    let beaconMinor: CLBeaconMinorValue = 43793
    let beaconRegionIdentifier = "AttendanceBeacon"
    

    override init() {
        super.init()
        print("AttendanceViewModel.setupLocationManager - init")
        setupLocationManager()
    }
    
    // CLLocationManager 초기화
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        // 권한 상태 확인 로그
        if let manager = locationManager {
            print("Location authorization status: \(manager.authorizationStatus.rawValue)")
            /**
            0 (notDetermined)             : 사용자가 아직 위치 권한을 요청받지 않았거나, 요청 후 승인을 하지 않은 상태.
                                requestAlwaysAuthorization() 또는 requestWhenInUseAuthorization()을 호출하여 권한을 요청
            1 (restricted)                      : 사용자의 위치 서비스 접근이 제한된 상태
                                기기 사용자가 위치 서비스 사용을 제한(예: 자녀 보호 설정)했거나, MDM(모바일 기기 관리) 정책에 의해 제한된 경우.
            2 (denied)                          : 사용자가 권한 요청을 받았을 때 '허용 안 함'을 선택한 경우.
            3 (authorizedAlways)        : 사용자가' '항상 위치 사용 권한'을 부여. 앱이 백그라운드와 포그라운드 모두에서 위치 서비스 사용 가능.
            4 (authorizedWhenInUse) : 사용자가 '앱 사용 중 위치 사용 권한'을 부여. 앱이 포그라운드에서만 위치 서비스 사용 가능.
            */
        } else {
            print("LocationManager가 초기화되지 않았습니다.")
        }
    }

    // Beacon 모니터링 시작
    func startMonitoring() {
        print("Beacon is startMonitoring")
        guard let locationManager = locationManager else { return }
        let beaconRegion = CLBeaconRegion(uuid: beaconUUID, major: beaconMajor, minor: beaconMinor, identifier: beaconRegionIdentifier)
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
    }

    // Beacon 모니터링 중단
    func stopMonitoring() {
        print("Beacon is stopMonitoring")
        guard let locationManager = locationManager else { return }
        let beaconRegion = CLBeaconRegion(uuid: beaconUUID, major: beaconMajor, minor: beaconMinor, identifier: beaconRegionIdentifier)
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
    }

 
    // CLLocationManagerDelegate - Beacon 감지
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        // 수정된 코드
        print("Beacon didRange 감지")
        print("Beacon 개수: \(beacons.count)")
        
        // 가장 가까운 Beacon의 상태 확인
        if let nearestBeacon = beacons.first {
            print("Beacon detected: \(nearestBeacon), rssi: \(nearestBeacon.rssi)")
            // 신호 강도(rssi) 기준으로 판단
            if nearestBeacon.rssi < 0 && nearestBeacon.rssi > -80 { // 0 ~ -80 dBm 이상이면 Beacon 범위 내로 판단
                isBeaconInRange = true
            } else {
                isBeaconInRange = false
            }
        } else {
            print("Beacon not detected")
            isBeaconInRange = false
        }
        updateButtonStates()
    }
    
    // Beacon 모니터링이 시작되었을 때 호출
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
//        print("Started monitoring for region: \(region.identifier)")
    }
    
    

    // 버튼 상태 업데이트
    private func updateButtonStates() {
        print("Beacon is updateButtonStates ")
        
        // Beacon이 범위 안에 있을 때만 버튼 활성화
        if isBeaconInRange {
            showEntryButton = true
            showExitButton = true
        } else {
            showEntryButton = false
            showExitButton = false
        }
    }

    
    
    
    
    
    
    
    
    // 학생 화면 - 속한 강좌와 입퇴실 현황 목록 조회
    func fetchStudentCoursesStatus() {
//        SVProgressHUD.show()
        guard let sID = userID, let token = token else { return }
        let endPoint = "\(AppConfig.baseURL)/attendances/student/\(sID)"
        let headers: HTTPHeaders = ["Authorization": "\(token)"]

        AF.request(endPoint, method: .get, headers: headers)
            .responseDecodable(of: AttendanceRoot.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let result):
//                        SVProgressHUD.dismiss()
                        if(result.documents.courses.count > 0) {
                            self.attendanceCourses = result.documents.courses
                            if let status = self.locationManager ,
                               status.authorizationStatus != .denied {
                                self.updateButtonStates() // 버튼 상태 업데이트
                            }
                        } else {
                            self.studentCourseMessage = result.documents.userName + " 님은 현재 속한 강좌가 없습니다."
                        }
                    case .failure(let error):
//                        SVProgressHUD.dismiss()
                        print("Error fetching courses: \(error.localizedDescription)")
                    }
                }
            }
        
    }

    
    // 학생 화면 - '입실' 버튼 눌렀을 때
    func studentEntry(cID: Int?, completion: @escaping () -> Void) {
        guard let cID = cID, let sID = userID, let token = token else { return }
        let endPoint = "\(AppConfig.baseURL)/attendances/student/\(sID)/entry/\(cID)"
        let headers: HTTPHeaders = ["Authorization": "\(token)"]

        AF.request(endPoint, method: .post, headers: headers)
            .responseDecodable(of: EntryExitRoot.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let result):
                        self.entryExitMessage = result.message
                    case .failure(let error):
                        self.entryExitMessage = "Error: \(error.localizedDescription)"
                    }
                    completion()
                }
            }
    }

    
    
    // 학생 화면 - '퇴실' 버튼 눌렀을 때

    func studentExit(cID: Int?, completion: @escaping () -> Void) {
        guard let cID = cID, let sID = userID, let token = token else { return }
        let endPoint = "\(AppConfig.baseURL)/attendances/student/\(sID)/exit/\(cID)"
        let headers: HTTPHeaders = ["Authorization": "\(token)"]

        AF.request(endPoint, method: .put, headers: headers)
            .responseDecodable(of: EntryExitRoot.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let result):
                        self.entryExitMessage = result.message
                    case .failure(let error):
                        self.entryExitMessage = "Error: \(error.localizedDescription)"
                    }
                    completion()
                }
            }
    }
    
    
    // 선생님 화면 - 속한 강좌 목록
    func fetchTeacherCourses() {
//        SVProgressHUD.show()
        guard let tID = userID
            else { return }
        let endPoint = "\(AppConfig.baseURL)/attendances/teacher/\(tID)/courses"
        guard let token = token else { return }
        let headers:HTTPHeaders = ["Authorization":"\(token)"] // 이미 Bearer 포함

        AF.request(endPoint, method: .get, headers: headers)
            .responseDecodable(of: AttendanceRoot.self) { response in
                switch response.result {
                    case .success(let result):
//                        SVProgressHUD.dismiss()
                        if(result.documents.courses.count > 0) {
                            self.attendanceCourses = result.documents.courses
                        } else {
                            self.teacherCourseMessage = result.documents.userName + " 님은 현재 속한 강좌가 없습니다."
                        }
                    case .failure(let error):
//                        SVProgressHUD.dismiss()
                        print("Failed to fetch course status: \(error.localizedDescription)")
                    }
            }
        
    }
    
    // 선생님 화면 - 미입실 학생 목록 조회
    func fetchTeacherStudents(cID: Int) {
//        SVProgressHUD.show()
        guard let tID = userID,
              let token
            else { return }
        
        let endPoint = "\(AppConfig.baseURL)/attendances/teacher/\(tID)/unCheck/\(cID)"
        let headers: HTTPHeaders = ["Authorization": "\(token)"]

        AF.request(endPoint, method: .get, headers: headers)
            .responseDecodable(of: AttendanceNotEntryRoot.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let result):
//                        SVProgressHUD.dismiss()
                        self.attendanceNotEntries = result.documents
                        self.teacherCourseStudentMessage = result.message
                        if self.attendanceNotEntries.isEmpty {
                            self.objectWillChange.send()
                        }
/**
 objectWillChange와 send()는
    SwiftUI에서 ObservableObject 프로토콜을 사용하는 데이터 모델이 UI와의 상태 동기화를 강제로 트리거하기 위해 제공하는 도구.
 @Published가 아닌 프로퍼티를 변경하거나, 배열 요소를 직접 수정하는 경우에는 objectWillChange가 자동으로 호출되지 않음.
 예를 들어, isEmpty 체크나 배열 요소 수정이 SwiftUI에 변경을 알리지 못함.
 objectWillChange는 Combine의 Publisher로, SwiftUI와 데이터 변경 이벤트를 연결하는 역할
 send()를 호출하면 “데이터가 변경된다”는 이벤트가 발생
 */
                    case .failure(let error):
//                        SVProgressHUD.dismiss()
                        if let data = response.data, let serverResponse = String(data: data, encoding: .utf8) {
                            print("Server error response: \(serverResponse)")
                        }
                        print("Failed to fetch course status: \(error.localizedDescription)")
                    }
                }
            }
        
    }
    
    /**
     자동 호출 (추천) : @Published를 사용하면 objectWillChange를 수동으로 호출할 필요가 없음:
        @Published var items: [String] = []
        func addItem(_ item: String) {
            items.append(item) // UI가 자동으로 업데이트됨.
        }
     강제 호출 (필요한 경우에만)  :  @Published를 사용하지 않는 경우나 배열의 요소를 직접 수정해야 할 때:
        class MyViewModel: ObservableObject {
            var items: [String] = []
            func addItem(_ item: String) {
                objectWillChange.send() // 변경 사항을 강제로 알림.
                items.append(item)
            }
        }
     */

    
    
    
    // 선생 화면 - '수동 출석' 버튼 눌렀을 때
    func teacherForceEntry(courseID: Int?, sID: Int?, completion: @escaping () -> Void) {
        guard let cID = courseID, let sID, let tID = userID, let token = token else { return }
        let endPoint = "\(AppConfig.baseURL)/attendances/teacher/\(tID)/force/\(sID)/course/\(cID)"
        let headers: HTTPHeaders = ["Authorization": "\(token)"]

        AF.request(endPoint, method: .post, headers: headers)
            .responseDecodable(of: EntryExitRoot.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let result):
                        self.entryExitMessage = result.message
                    case .failure(let error):
                        self.entryExitMessage = "Error: \(error.localizedDescription)"
                    }
                    completion()
                }
            }
    }
    
    
    // 선생 화면 - 미입실 '푸시 알림' 버튼 눌렀을 때
    func teacherPushNoti(courseID: Int?, sID: Int?, completion: @escaping () -> Void) {
        guard let cID = courseID,
              let sID,
              let token
        else { return }
        
        let endPoint = "\(AppConfig.baseURL)/apns/entry/\(cID)/\(sID)"
        let headers: HTTPHeaders = ["Authorization": "\(token)"]

        AF.request(endPoint, method: .post, headers: headers)
            .responseDecodable(of: EntryExitRoot.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                        case .success(let result):
                            self.entryExitMessage = result.message
                        case .failure(let error):
                            self.entryExitMessage = "Error: \(error.localizedDescription)"
                    }
                    completion()
                }
            }
    }
    
}


extension AttendanceViewModel {
    func locationAuthorizationStatus() -> CLAuthorizationStatus {
        return locationManager?.authorizationStatus ?? .notDetermined
    }
    
    // 권한 확인 함수
    func checkAndRequestLocationAuthorization(completion: @escaping (String?) -> Void) {
        guard let manager = locationManager else { return }
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            completion(nil)
        case .denied:
            completion("위치 권한이 필요합니다. 설정에서 위치 권한을 허용해주세요.")
        case .restricted:
            completion("위치 서비스가 제한되어 있습니다. 기기 설정을 확인해주세요.")
        case .notDetermined:
            setupLocationManager()
            completion(nil)
        @unknown default:
            completion("알 수 없는 권한 상태입니다.")
        }
    }
}
