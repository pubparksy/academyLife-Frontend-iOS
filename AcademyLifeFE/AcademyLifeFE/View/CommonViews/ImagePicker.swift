import SwiftUI
import PhotosUI

// Coordinator class to manage PHPickerViewControllerDelegate
class ImagePickerCoordinator: NSObject, PHPickerViewControllerDelegate {
    let parent: ImagePicker

    init(parent: ImagePicker) {
        self.parent = parent
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        parent.images.removeAll() // Clear previous images
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        if let uiImage = image as? UIImage {
                            self.parent.images.append(uiImage) // Add new images
                        }
                    }
                }
            }
        }
        picker.dismiss(animated: true)
    }
}

// Struct for ImagePicker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage] // Incase multiple images
    var selectionLimit: Int

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = selectionLimit
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> ImagePickerCoordinator {
        ImagePickerCoordinator(parent: self)
    }
}

struct ImagePickerView: View {
    @State private var isPickerPresented: Bool = false
    @State private var selectedImages: [UIImage] = [] // Multiple selected images

    var body: some View {
        VStack {
            // Show selected images in a horizontal scroll view
            if !selectedImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                                .clipped()
                        }
                    }
                    .padding()
                }
            } else {
                Text("이미지를 선택하세요.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding()
            }

            Button(action: {
                isPickerPresented.toggle()
            }) {
                Text("사진 선택")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .sheet(isPresented: $isPickerPresented) {
                ImagePicker(images: $selectedImages, selectionLimit: 3)
            }
        }
        .padding()
    }
}

#Preview {
    ImagePickerView()
}
