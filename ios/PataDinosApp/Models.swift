import Foundation
import SwiftUI

// MARK: - Lesson Model
struct Lesson: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let emoji: String
    let color: String
    let exercises: [Exercise]
    var isUnlocked: Bool

    init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String,
        emoji: String,
        color: String,
        exercises: [Exercise],
        isUnlocked: Bool
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.emoji = emoji
        self.color = color
        self.exercises = exercises
        self.isUnlocked = isUnlocked
    }
}

// MARK: - Exercise Model
enum ExerciseType {
    case tapCorrectLetter
    case listenAndChoose
    case matchImageToWord
    case fillBlank
}

struct Exercise: Identifiable {
    let id: UUID
    let type: ExerciseType
    let question: String
    let options: [String]
    let correctAnswer: String
    let imageName: String?
    let audioName: String?
    let hint: String?

    init(
        id: UUID = UUID(),
        type: ExerciseType,
        question: String,
        options: [String],
        correctAnswer: String,
        imageName: String? = nil,
        audioName: String? = nil,
        hint: String? = nil
    ) {
        self.id = id
        self.type = type
        self.question = question
        self.options = options
        self.correctAnswer = correctAnswer
        self.imageName = imageName
        self.audioName = audioName
        self.hint = hint
    }
}

// MARK: - User Progress
final class UserProgress: ObservableObject {
    @Published var stars: Int {
        didSet { UserDefaults.standard.set(stars, forKey: "stars") }
    }

    @Published var streakDays: Int {
        didSet { UserDefaults.standard.set(streakDays, forKey: "streakDays") }
    }

    @Published var completedLessonIDs: Set<String> {
        didSet {
            UserDefaults.standard.set(Array(completedLessonIDs), forKey: "completedLessons")
        }
    }

    @Published var currentLesson: Int {
        didSet { UserDefaults.standard.set(currentLesson, forKey: "currentLesson") }
    }

    @Published var lastPlayedDate: Date? {
        didSet { UserDefaults.standard.set(lastPlayedDate, forKey: "lastPlayedDate") }
    }

    init() {
        self.stars = UserDefaults.standard.integer(forKey: "stars")
        self.streakDays = UserDefaults.standard.integer(forKey: "streakDays")
        self.currentLesson = UserDefaults.standard.integer(forKey: "currentLesson")
        let stored = UserDefaults.standard.stringArray(forKey: "completedLessons") ?? []
        self.completedLessonIDs = Set(stored)
        self.lastPlayedDate = UserDefaults.standard.object(forKey: "lastPlayedDate") as? Date
    }

    func addStars(_ amount: Int) {
        stars += amount
    }

    func markLessonComplete(id: String) {
        completedLessonIDs.insert(id)
        currentLesson += 1
        addStars(10)
    }
}

// MARK: - Sample Store / Placeholder
final class LessonStore {
    static let shared = LessonStore()

    let lessons: [Lesson] = [
        Lesson(
            id: "lesson-1",
            title: "Letra A",
            subtitle: "Primeiros sons",
            emoji: "🦕",
            color: "brandBlue",
            exercises: [
                Exercise(
                    type: .tapCorrectLetter,
                    question: "Qual é a letra A?",
                    options: ["A", "B", "C"],
                    correctAnswer: "A",
                    hint: "A letra começa a palavra Abelha"
                )
            ],
            isUnlocked: true
        )
    ]
}
