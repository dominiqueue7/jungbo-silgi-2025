import Foundation
import SwiftData

@Model
final class ExamQuestion {
    @Attribute(.externalStorage) var imageData: Data?
    var answer: String

    init(imageData: Data? = nil, answer: String = "") {
        self.imageData = imageData
        self.answer = answer
    }
}
