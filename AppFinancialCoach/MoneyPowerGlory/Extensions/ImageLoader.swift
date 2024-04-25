import Foundation
import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var imageData = Data()
    private var cancellables = Set<AnyCancellable>()

    func load(fromURL url: URL) {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .replaceError(with: Data())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.imageData = $0 }
            .store(in: &cancellables)
    }
}
