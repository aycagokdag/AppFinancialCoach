import SwiftUI

struct SettingsView: View {
    @Binding var userProfile: UserProfileInfoModel
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?

    var body: some View {
        Form {
            Section(header: Text("User Info")) {
                HStack {
                    if let inputImage = inputImage {
                        Image(uiImage: inputImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .onTapGesture {
                                showingImagePicker = true
                            }
                    } else {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 60, height: 60)
                            .onTapGesture {
                                showingImagePicker = true
                            }
                    }

                    VStack(alignment: .leading) {
                        TextField("Name", text: $userProfile.personalInfo.name)
                        TextField("Job Title", text: $userProfile.personalInfo.profession)
                        Text("Email: \(userProfile.personalInfo.email)")
                            .foregroundColor(.gray) // Display the email as non-editable
                    }
                }
            }
            
            // Additional sections can be here for other editable attributes

        }
        .navigationTitle("Settings")
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: $inputImage)
        }
    }
    
    func loadImage() {
        // Handle the image loading logic
    }
}

// ImagePicker component for selecting images from the photo library
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }

            picker.dismiss(animated: true)
        }
    }
}
