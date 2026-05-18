import Foundation
import SwiftUI
import Combine

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
@MainActor
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

// MARK: - Central Data Store
final class LessonStore: ObservableObject {
    static let shared = LessonStore()

    let lessons: [Lesson] = [
        Lesson(
            title: "Letras",
            subtitle: "Conheça as letras do alfabeto",
            emoji: "🔤",
            color: "lessonBlue",
            exercises: [
                Exercise(type: .tapCorrectLetter, question: "Qual é a letra A?", options: ["A", "B", "C", "D"], correctAnswer: "A", imageName: "character.cursor.ibeam", hint: "É a primeira letra do alfabeto!"),
                Exercise(type: .matchImageToWord, question: "Que animal começa com A?", options: ["Abelha", "Bola", "Casa", "Dado"], correctAnswer: "Abelha", imageName: "hare", hint: "Esse animal faz mel 🍯"),
                Exercise(type: .fillBlank, question: "_belha", options: ["A", "B", "C", "E"], correctAnswer: "A", hint: "A primeira letra!")
            ],
            isUnlocked: true
        ),
        Lesson(
            title: "Números",
            subtitle: "Aprenda a contar brincando",
            emoji: "🔢",
            color: "lessonPurple",
            exercises: [
                Exercise(type: .tapCorrectLetter, question: "Qual é o número 3?", options: ["1", "2", "3", "4"], correctAnswer: "3", hint: "Vem depois do 2!"),
                Exercise(type: .matchImageToWord, question: "Quantas estrelas você vê? ⭐⭐⭐", options: ["1", "2", "3", "4"], correctAnswer: "3", imageName: "star.fill", hint: "Conte devagar...")
            ],
            isUnlocked: false
        ),
        Lesson(
            title: "Cores",
            subtitle: "Descubra as cores do arco-íris",
            emoji: "🎨",
            color: "lessonOrange",
            exercises: [
                Exercise(type: .tapCorrectLetter, question: "O céu é qual cor?", options: ["Verde", "Azul", "Rosa", "Amarelo"], correctAnswer: "Azul", imageName: "cloud.sun.fill", hint: "Olha lá fora! ☁️")
            ],
            isUnlocked: false
        ),
        Lesson(
            title: "Animais",
            subtitle: "Conheça os animais e seus sons",
            emoji: "🐶",
            color: "lessonGreen",
            exercises: [
                Exercise(type: .listenAndChoose, question: "Qual animal faz AU AU?", options: ["🐱 Gato", "🐶 Cachorro", "🐮 Vaca", "🐸 Sapo"], correctAnswer: "🐶 Cachorro", imageName: "pawprint.fill", hint: "Melhor amigo do homem!")
            ],
            isUnlocked: false
        ),
        Lesson(
            title: "Formas",
            subtitle: "Aprenda sobre formas e figuras",
            emoji: "🔷",
            color: "lessonYellow",
            exercises: [
                Exercise(type: .tapCorrectLetter, question: "Qual é o círculo?", options: ["○", "□", "△", "◇"], correctAnswer: "○", imageName: "circle.fill", hint: "Redondo como uma bola!")
            ],
            isUnlocked: false
        )
    ]
}
