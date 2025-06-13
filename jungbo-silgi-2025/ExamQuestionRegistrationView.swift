import SwiftUI
import PhotosUI
import SwiftData
#if canImport(UIKit)
import UIKit
typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
typealias PlatformImage = NSImage
#endif

struct ExamQuestionRegistrationView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var pickerItems: [PhotosPickerItem] = []
    @State private var images: [PlatformImage] = []
    @State private var answers: [String] = []

    var body: some View {
        VStack {
            PhotosPicker("이미지 선택", selection: $pickerItems, maxSelectionCount: 100, matching: .images)
                .onChange(of: pickerItems) { newItems in
                    images = []
                    answers = Array(repeating: "", count: newItems.count)
                    for (index, item) in newItems.enumerated() {
                        Task {
                            if let data = try? await item.loadTransferable(type: Data.self),
                               let image = platformImage(from: data) {
                                if images.count <= index { images.append(image) }
                            }
                        }
                    }
                }
                .padding()

            List {
                ForEach(images.indices, id: \.self) { index in
                    HStack {
                        Image(platformImage: images[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        TextField("정답 입력", text: Binding(
                            get: { answers[index] },
                            set: { answers[index] = $0 }
                        ))
                    }
                }
            }

            Button("저장") {
                for (index, image) in images.enumerated() {
                    if let data = jpegData(from: image) {
                        let question = ExamQuestion(imageData: data, answer: answers[index])
                        modelContext.insert(question)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("기출문제 등록")
    }
}

private extension Image {
    init(platformImage: PlatformImage) {
#if canImport(UIKit)
        self.init(uiImage: platformImage)
#elseif canImport(AppKit)
        self.init(nsImage: platformImage)
#else
        self.init(systemName: "photo")
#endif
    }
}

private func platformImage(from data: Data) -> PlatformImage? {
#if canImport(UIKit)
    UIImage(data: data)
#elseif canImport(AppKit)
    NSImage(data: data)
#else
    nil
#endif
}

private func jpegData(from image: PlatformImage) -> Data? {
#if canImport(UIKit)
    image.jpegData(compressionQuality: 0.8)
#elseif canImport(AppKit)
    guard let tiff = image.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiff) else { return nil }
    return bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.8])
#else
    nil
#endif
}

#Preview {
    ExamQuestionRegistrationView()
}
