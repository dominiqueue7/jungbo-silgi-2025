import SwiftUI
import PhotosUI
import SwiftData
import UIKit

struct ExamQuestionRegistrationView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var pickerItems: [PhotosPickerItem] = []
    @State private var images: [UIImage] = []
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
                               let uiImage = UIImage(data: data) {
                                if images.count <= index { images.append(uiImage) }
                            }
                        }
                    }
                }
                .padding()

            List {
                ForEach(images.indices, id: \.self) { index in
                    HStack {
                        Image(uiImage: images[index])
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
                    if let data = image.jpegData(compressionQuality: 0.8) {
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

#Preview {
    ExamQuestionRegistrationView()
}
