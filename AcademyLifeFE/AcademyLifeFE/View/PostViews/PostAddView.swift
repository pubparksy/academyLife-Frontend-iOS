import SwiftUI

struct PostAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var postVM: PostViewModel
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var images: [UIImage] = []
    @State private var isImagePickerPresented: Bool = false
    @State private var showAlert: Bool = false // 알림 상태
    @State private var alertMessage: String = "" // 글 등록 성공 메시지

    var courseID: Int
    var cmDtCd: Int

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 제목 입력 필드
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("제목")
                        Text("*").foregroundStyle(.red)
                    }
                        .font(.headline)
                    TextField("제목을 입력하세요.", text: $title)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                // 내용 입력 필드
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("내용")
                        Text("*").foregroundStyle(.red)
                    }
                        .font(.headline)
                    TextEditor(text: $content)
                        .frame(height: 200)
                        .padding(4)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                }
                .padding(.horizontal)

                // 사진 선택 및 미리보기
                VStack(alignment: .leading, spacing: 8) {
                    Text("사진 첨부")
                        .font(.headline)
                    if !images.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(images, id: \.self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(8)
                                        .clipped()
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        Text("선택된 사진이 없습니다.")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }

                    Button(action: {
                        isImagePickerPresented.toggle()
                    }) {
                        Text("사진 선택 (최대 3개)")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(images: $images, selectionLimit: 3)
                    }
                }
                .padding(.horizontal)

                Spacer()

                // 글 등록 버튼
                Button(action: {
                    postVM.addPost(cID: courseID, cmDtCd: cmDtCd, title: title, content: content, images: images) { success, message in
                        DispatchQueue.main.async {
                            if success {
                                alertMessage = "글 등록을 성공했습니다."
                            } else {
                                alertMessage = message ?? "글 등록에 실패했습니다."
                            }
                            showAlert = true
                        }
                    }
                }) {
                    Text("글 등록")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .cornerRadius(8)
                }
                .disabled(title.isEmpty || content.isEmpty) // 비활성화 조건
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(alertMessage),
                        dismissButton: .default(Text("확인"), action: {
                            if alertMessage == "글 등록을 성공했습니다." {
                                postVM.fetchPosts(cID: courseID, cmDtCd: cmDtCd) // 목록 새로고침
                                presentationMode.wrappedValue.dismiss()
                            }
                        })
                    )
                }
            }
            .padding(.vertical)
            .background(
                Color.white
                    .ignoresSafeArea(edges: .bottom)
            )
        }
    }
}

#Preview {
    PostAddView(courseID: 1, cmDtCd: 2)
        .environmentObject(PostViewModel())
}
