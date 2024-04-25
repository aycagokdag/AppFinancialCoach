import SwiftUI

struct URLImageView: View {
    @ObservedObject private var imageLoader = ImageLoader()
    var url: URL

    init(url: URL) {
        self.url = url
        imageLoader.load(fromURL: url)
    }

    var body: some View {
        if let uiImage = UIImage(data: imageLoader.imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color("darkPurple").opacity(0.5), lineWidth: 10)
                )
                .cornerRadius(50)
        } else {
            Image("placeholder-image") // Provide a placeholder image in your asset catalog
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color("darkPurple").opacity(0.5), lineWidth: 10)
                )
                .cornerRadius(50)
        }
    }
}
