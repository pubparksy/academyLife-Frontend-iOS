import SwiftUI
import KakaoSDKCommon

@main
struct AcademyLifeFEApp: App {
    // 전역 environment object로 instancing해 중복 코드 제거
    @StateObject var authVM = AuthViewModel()
    @StateObject var notiVM = NotificationViewModel()
    @StateObject var attendanceVM = AttendanceViewModel()
    @StateObject var commonVM = CommonDetailCodeViewModel()
    @StateObject var courseVM = CourseViewModel()
    @StateObject var postVM = PostViewModel()
    @StateObject var commentVM = CommentViewModel()
    @StateObject var socialAuthVM = SocialAuthViewModel()
    @StateObject var teacherVM = TeacherViewModel()
    @StateObject var studentVM = StudentViewModel()
    @StateObject var userVM = UserViewModel()
    @StateObject var openAIVM = OpenAIViewModel()
    @StateObject var chatbotVM = ChatbotViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var isLoading = true

    var body: some Scene {
        WindowGroup {
            if isLoading {
                SplashScreenView()
                    .onAppear {
                        // 로딩 시간 제어 (예: API 호출, 초기 설정)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    }
            } else {
                ContentView()
                    .environmentObject(authVM)
                    .environmentObject(notiVM)
                    .environmentObject(attendanceVM)
                    .environmentObject(commonVM)
                    .environmentObject(courseVM)
                    .environmentObject(postVM)
                    .environmentObject(commentVM)
                    .environmentObject(socialAuthVM)
                    .environmentObject(teacherVM)
                    .environmentObject(studentVM)
                    .environmentObject(userVM)
                    .environmentObject(openAIVM)
                    .environmentObject(chatbotVM)
            }
        }
    }
}


/** 1차 안 */
//struct SplashScreenView: View {
//    var body: some View {
//        ZStack {
//            Color.white
//                .edgesIgnoringSafeArea(.all)
//            Image("LaunchLogo") // LaunchLogo는 Assets에 추가된 이미지 이름
//                .resizable()
//                .scaledToFit()
//                .frame(width: 200, height: 200) // 크기 조정
//        }
//    }
//}

/** 2차 안 */
struct SplashScreenView: View {
//    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0

    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            Image("LaunchLogo") // LaunchLogo는 Assets에 추가된 이미지 이름
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200) // 크기 조정
//                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.5)) {
//                        scale = 1.0
                        opacity = 1.0
                    }
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // 카카오 로그인
        KakaoSDK.initSDK(appKey: AppConfig.apiKeyKakao)
        
        // Push Notification
        UNUserNotificationCenter.current().delegate = self
        requestNotificationPermission()  // 이거 호출해서 '알림 권한' 허용하도록 요청
        return true
    }
    
    
    // 1. 알림 권한 허용 받기
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("AcademyLife - 사용자한테서 알림 권한이 허용되었습니다.")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications() // 등록을 요청
                }
            } else {
                print("AcademyLife - 사용자한테서 알림 권한이 거부되었습니다.")
            }
        }
    }
    
    // 2. 허용 받는 순간 deviceToken 가져오기
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // OS가 deviceToken을 가지고 옴...
        var token:String = ""
        // Data타입은 byte 타입이 나열된 형태. for문 돌려서 1byte씩 가져올거임.  1byte는 = hex 2자리로 바꿀 수 있음.
        for i in 0..<deviceToken.count {
                            // hex 문자열로 바꿔서 +=로 붙임. 걍 강사님이 적어준 format 그대로 쓰기..
            token += String(format:"%02.2hhx", deviceToken[i] as CVarArg)
        }
        // Data타입 token이 아닌 String타입 token 완성
        
        print("AcademyLife APNS token : \(token)")
        UserDefaults.standard.set(token, forKey: "deviceToken")
        // 우리 최종플젝에선 > 사용자가 로그인할 때 userId,deviceToken랑 같이 세트로 db에 update?
    }
    
    // 3. 알림 보낸 후
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // willPresent 인자에선 notification가 넘어왔지만
        // didReceive  인자에선 response 가 넘어옴. (didReceive는 Remote 아님 Local 용임)
        let info = response.notification.request.content.userInfo
        print("AcademyLife didReceive >> ", info["name"] ?? "") // 이 뒤에 수행해야할게 있다면 로직 추가
        completionHandler()
    }
    
    //  3. 알림 보낸 후
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let info = notification.request.content.userInfo
        print("AcademyLife willPresent >> ", info["name"] ?? "") // 이 뒤에 수행해야할게 있다면 로직 추가
        completionHandler([.banner, .sound])
    }
    
    
    
    
}
