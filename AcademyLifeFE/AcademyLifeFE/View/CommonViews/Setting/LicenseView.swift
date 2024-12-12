import SwiftUI

struct LicenseView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("라이선스")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 10)
                
                // Frontend
                Text("1. Frontend")
                    .font(.headline)
                    .bold()
                
                Text("""
                사용된 패키지:
                - Alamofire (5.10.2): HTTP 네트워킹 라이브러리
                  - License: MIT
                  - https://github.com/Alamofire/Alamofire
                
                - KakaoOpenSDK (2.23.0): 카카오 로그인 및 소셜 기능 라이브러리
                  - License: MIT
                  - https://developers.kakao.com/
                
                - Kingfisher (8.1.1): 이미지 다운로드 및 캐싱 라이브러리
                  - License: MIT
                  - https://github.com/onevcat/Kingfisher
                
                - SVProgressHUD (2.3.1): 로딩 인디케이터 라이브러리
                  - License: MIT
                  - https://github.com/SVProgressHUD/SVProgressHUD
                
                추가 기능:
                - Background Modes: 위치 업데이트, Bluetooth LE
                - Push Notifications: 푸시 알림 기능 활성화
                - Sign in with Apple: Apple ID 로그인 지원
                """)

                // Backend
                Text("2. Backend")
                    .font(.headline)
                    .bold()
                
                Text("""
                사용된 패키지:
                - Express (4.21.1): Node.js 웹 프레임워크
                  - License: MIT
                  - https://expressjs.com/
                
                - Sequelize (6.37.5): ORM(Object Relational Mapping) 라이브러리
                  - License: MIT
                  - https://sequelize.org/
                
                - JSON Web Token (jsonwebtoken 9.0.2): 인증 및 토큰 생성
                  - License: MIT
                  - https://github.com/auth0/node-jsonwebtoken
                
                - bcryptjs (2.4.3): 비밀번호 암호화 라이브러리
                  - License: MIT
                  - https://github.com/dcodeIO/bcrypt.js
                
                - @azure/storage-blob (12.25.0): Azure Blob Storage와의 통합
                  - License: MIT
                  - https://github.com/Azure/azure-sdk-for-js
                
                - Multer (1.4.5-lts.1): 파일 업로드 처리 라이브러리
                  - License: MIT
                  - https://github.com/expressjs/multer
                
                - Swagger-UI-Express (5.0.1): API 문서화 도구
                  - License: Apache 2.0
                  - https://github.com/scottie1984/swagger-ui-express
                
                - CORS (2.8.5): 교차 출처 리소스 공유를 허용
                  - License: MIT
                  - https://github.com/expressjs/cors

                - YAML.js (0.3.0): YAML 파일의 파싱 및 변환
                  - License: MIT
                  - https://github.com/jeremyfa/yaml.js
                
                기타 사용된 라이브러리는 `package.json` 파일에서 확인할 수 있습니다.
                """)

                // CI/CD
                Text("3. Azure")
                    .font(.headline)
                    .bold()
                
                
                Text("""
                배포 환경:
                - App Service: Azure에서 호스팅 및 관리되는 애플리케이션 서비스
                  - Staging Slot: 스테이징 환경에서 테스트 및 검증을 위한 추가 슬롯 구성
                - Azure Database for PostgreSQL: 데이터베이스
                - Storage Account: 파일 및 Blob 저장소 관리
                - Blob Storage: 이미지 및 파일 저장
                - Azure Container Registry: Docker 이미지 관리 및 배포
                - GitHub Actions: CI/CD 워크플로 자동화
                - Docker: 컨테이너 기반 애플리케이션 배포

                사용된 요금제:
                - App Service Plan (Production 및 Staging 슬롯 사용)

                프로젝트 관리 도구:
                - Notion: WBS(작업 분류 체계) 관리 및 프로젝트 협업

                Microsoft 제품 사용권 계약(EULA)에 따라 Azure 서비스를 사용합니다:
                - https://azure.microsoft.com/
                """)
                
                // 참고 정보
                Text("4. 아이콘")
                    .font(.headline)
                    .bold()
                
                Text("""
                출석체크:
                - https://www.flaticon.com/kr/free-icons/
                """)
                
                Text("5. 참고 정보")
                    .font(.headline)
                    .bold()
                
                Text("""
                본 앱에서 사용된 모든 라이브러리의 라이선스 전문은 해당 라이브러리의 GitHub 페이지 또는 공식 문서를 통해 확인할 수 있습니다.
                """)
            }
            .padding()
        }
        .navigationTitle("라이센스")
    }
}

#Preview {
    LicenseView()
}
