import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("개인정보 처리방침")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 10)
                
                Group {
                    Text("1. 개인정보의 수집 및 이용")
                        .font(.headline)
                        .bold()
                    
                    Text("""
                    회사는 다음과 같은 목적으로 최소한의 개인정보를 수집하고 이용합니다:
                    - 회원가입: 이름, 이메일, 전화번호, 비밀번호 (회원탈퇴 시까지 보유)
                    - 서비스 제공: IP 주소, 기기 정보 (서비스 이용 중 수집)
                    - 법적 의무 준수 및 서비스 개선
                    """)
                    
                    Text("2. 만 14세 미만 아동의 개인정보 처리")
                        .font(.headline)
                        .bold()
                    
                    Text("""
                    회사는 만 14세 미만 아동의 개인정보를 수집하지 않습니다. 만약 만 14세 미만의 아동이 서비스에 가입하려면 법정대리인의 동의가 필요합니다.
                    """)
                }
                
                Group {
                    Text("3. 개인정보의 보유 및 이용 기간")
                        .font(.headline)
                        .bold()
                    
                    Text("""
                    회사는 다음과 같은 기간 동안 개인정보를 보유 및 이용합니다:
                    - 회원탈퇴 시 즉시 삭제
                    - 관련 법령에 따라 보유가 필요한 경우, 해당 기간 동안 보관
                      예: 계약 및 청약철회 기록(5년), 대금결제 및 재화 공급 기록(5년), 소비자 불만 및 분쟁처리 기록(3년)
                    """)
                    
                    Text("4. 개인정보의 제3자 제공 및 공유")
                        .font(.headline)
                        .bold()
                    
                    Text("""
                    회사는 원칙적으로 이용자의 개인정보를 외부에 제공하지 않습니다. 다만, 다음과 같은 경우 예외로 합니다:
                    - 사용자가 사전에 동의한 경우
                    - 법적 요구가 있는 경우
                    """)
                    
                    Text("5. 개인정보 보호를 위한 조치")
                        .font(.headline)
                        .bold()
                    
                    Text("""
                    회사는 개인정보 보호를 위해 다음과 같은 기술적, 관리적 조치를 취하고 있습니다:
                    - 개인정보를 암호화하여 안전하게 저장
                    - 개인정보 접근 권한의 최소화 및 정기적인 내부 교육
                    - 개인정보 처리 시스템의 접근 기록을 최소 6개월 이상 보관 및 관리
                    """)
                }
                
                Group {
                    Text("6. 이용자 권리")
                        .font(.headline)
                        .bold()
                    
                    Text("""
                    이용자는 언제든지 다음과 같은 권리를 행사할 수 있습니다:
                    - 개인정보 열람, 수정, 삭제 요청
                    - 동의 철회 및 처리 정지 요청
                    요청은 고객 지원 이메일(timi.swu@gmail.com)을 통해 가능합니다.
                    """)
                    
                    Text("7. 개인정보 파기 절차 및 방법")
                        .font(.headline)
                        .bold()
                    
                    Text("""
                    회사는 개인정보 보유 기간이 종료되거나 처리 목적이 달성되었을 때 지체 없이 해당 정보를 파기합니다.
                    - 전자적 정보: 복구 불가능한 방식으로 삭제
                    - 문서 형태: 분쇄 또는 소각
                    """)
                    
                    Text("8. 개인정보 보호 책임자")
                        .font(.headline)
                        .bold()
                    
                    Text("""
                    개인정보 보호 책임자:  
                    이름: Timi 지원팀  
                    이메일: timi.swu@gmail.com  
                    """)
                }
                
                Group {
                    Text("9. 권익 침해 구제 방법")
                        .font(.headline)
                        .bold()
                    
                    Text("""
                    개인정보 침해와 관련된 상담 및 피해구제를 위해 아래 기관에 문의할 수 있습니다:
                    - 개인정보 침해신고센터: 118 (www.118.or.kr)
                    - 개인정보 분쟁조정위원회: 1833-6972 (www.kopico.go.kr)
                    - 대검찰청 사이버범죄수사단: 1301 (www.spo.go.kr)
                    - 경찰청 사이버안전국: 182 (https://cyberbureau.police.go.kr)
                    """)
                    
                    Text("10. 고지의 의무")
                        .font(.headline)
                        .bold()
                    
                    Text("""
                    이 개인정보 처리방침은 2024년 12월 9일부터 시행됩니다. 회사는 관련 법령이나 정책에 따라 변경될 경우, 최소 7일 전에 서비스 내 공지사항을 통해 안내합니다.
                    """)
                }
            }
            .padding()
        }
        .navigationTitle("개인정보 처리방침")
    }
}

#Preview {
    PrivacyPolicyView()
}
