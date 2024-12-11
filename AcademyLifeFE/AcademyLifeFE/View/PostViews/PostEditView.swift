import SwiftUI
import Kingfisher

struct PostEditView: View {
    @EnvironmentObject var postVM: PostViewModel
    @EnvironmentObject var commentVM: CommentViewModel
    var courseID: Int
    var postID: Int
    var cmDtCd: Int

    @State private var title: String = ""
    @State private var content: String = ""
    @State private var existingFileNames: [String] = []
    @State private var newImages: [UIImage] = []
    @State private var isImagePickerPresented: Bool = false
    @State private var showAlert: Bool = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
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

                VStack(alignment: .leading, spacing: 8) {
                    Text("사진 첨부")
                        .font(.headline)

                    ScrollView(.horizontal) {
                        HStack {
                            if newImages.isEmpty {
                                ForEach(existingFileNames, id: \.self) { fileName in
                                    if let url = commentVM.imageURL(for: fileName) {
                                        KFImage(url)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                    }
                                }
                            } else {
                                ForEach(newImages, id: \.self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    Button(action: {
                        isImagePickerPresented.toggle()
                    }) {
                        Text("사진 선택")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(images: $newImages, selectionLimit: 3)
                    }
                }
                .padding(.horizontal)

                Spacer()

                Button(action: {
                    saveChanges()
                }) {
                    Text("수정 저장")
                        .font(.headline)
    //                    .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
    //                    .background(Color.green)
                        .cornerRadius(8)
                }
                .disabled(title.isEmpty || content.isEmpty) // 비활성화 조건
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("알림"),
                        message: Text(postVM.message),
                        dismissButton: .default(Text("확인"))
                    )
                }
            }
            .padding(.vertical)
            .onAppear {
                loadPostDetails()
            }
        }

    }
    func loadPostDetails() {
        if let post = commentVM.postComments {
            title = post.title
            content = post.content
            existingFileNames = post.postImages
        }
    }
    
    func saveChanges() {
        postVM.editPost(
            postID: postID,
            title: title,
            content: content,
            existingFileNames: existingFileNames.isEmpty ? nil : existingFileNames,
            newImages: newImages.isEmpty ? nil : newImages
        ) { success in
            if success {
                showAlert = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    presentationMode.wrappedValue.dismiss()
                }
            } else {
                showAlert = true
            }
        }
    }
}
