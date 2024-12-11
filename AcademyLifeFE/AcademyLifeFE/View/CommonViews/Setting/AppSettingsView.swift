import SwiftUI

struct AppSettingsView: View {
    var body: some View {
        List {
            NavigationLink("이용 약관") {
                TermsOfServiceView()
            }
            NavigationLink("개인정보 처리방침") {
                PrivacyPolicyView()
            }
            NavigationLink("라이선스") {
                LicenseView()
            }
        }
        .navigationTitle("애플리케이션 설정")
        .listStyle(.grouped)
    }
}

#Preview {
    AppSettingsView()
}
