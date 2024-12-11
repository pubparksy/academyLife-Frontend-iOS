//
//  EditProfileView.swift
//  Academy-Life
//
//  Created by 서희재 on 11/25/24.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var userVM: UserViewModel
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focusedField: Field?
    enum Field {
        case userName, nickname, mobile
    }
    
    var body: some View {
        VStack {
            PageHeading(title: "프로필 변경")
            ScrollView{
                VStack(spacing: 20) {
                    CustomTextField(placeholder: "이메일", label: "이메일", text: $userVM.email, isDisabled: true)
                    CustomTextField(placeholder: "이름을 입력해주세요", label: "이름", text: $userVM.userName)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .userName)
                        .onSubmit {
                            focusedField = .nickname
                        }
                    CustomTextField(placeholder: "닉네임을 입력해주세요", label: "닉네임", text: $userVM.nickname)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .nickname)
                        .onSubmit {
                            focusedField = .mobile
                        }
                    CustomTextField(placeholder: "전화번호를 입력해주세요", label: "전화번호", text: $userVM.mobile)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .mobile)
                }.padding(.bottom, 28)
                VStack(spacing: 16) {
                    WideButton(title: "저장하기", bgColor: .accentDefault) {
                        userVM.isEditSucceeded = false
                        if userVM.userName.isEmpty || userVM.nickname.isEmpty || userVM.mobile.isEmpty {
                            userVM.message = "모든 항목을 입력해주세요."
                            userVM.showEditProfileAlert = true
                        } else if userVM.mobile.count < 10 {
                            userVM.message = "전화번호를 10자 이상 입력해주세요."
                            userVM.showEditProfileAlert = true
                        } else {
                            userVM.editProfile(userName: userVM.userName, nickname: userVM.nickname, mobile: userVM.mobile)
                        }
                    }
                    .alert("프로필 변경", isPresented: $userVM.showEditProfileAlert) {
                        Button("확인") {
                            if userVM.isEditSucceeded {
                                userVM.showEditProfileAlert = false
                                userVM.isEditSucceeded = false
                                dismiss()
                            }
                        }
                    } message: {
                        Text(userVM.message)
                    }
                    .padding(.bottom, 40)
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .onAppear {
                userVM.getUserInfo(userIDGiven: nil)
            }
        }
    }
    
}

#Preview {
    EditProfileView()
        .environmentObject(UserViewModel())
}
