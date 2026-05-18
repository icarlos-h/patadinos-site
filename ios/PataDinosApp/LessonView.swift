import SwiftUI

// MARK: - Lesson View (wrapper com progresso de exercícios)
struct LessonView: View {
    let lesson: Lesson
    @EnvironmentObject var progress: UserProgress
    @Environment(\.dismiss) var dismiss

    @State private var currentExerciseIndex = 0
    @State private var hearts = 3
    @State private var xpGained = 0
    @State private var showComplete = false

    var currentExercise: Exercise {
        lesson.exercises[currentExerciseIndex]
    }

    var progressFraction: Double {
        Double(currentExerciseIndex) / Double(max(lesson.exercises.count, 1))
    }

    var body: some View {
        ZStack {
            Color("backgroundBlue").ignoresSafeArea()

            if showComplete {
                LessonCompleteView(xpGained: xpGained, onDismiss: {
                    progress.markLessonComplete(id: lesson.id)
                    dismiss()
                })
                .transition(.scale.combined(with: .opacity))
            } else {
                VStack(spacing: 0) {
                    lessonTopBar

                    ExerciseView(
                        exercise: currentExercise,
                        onCorrect: { handleCorrect() },
                        onWrong:   { handleWrong() }
                    )
                    .padding(20)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                    .id(currentExerciseIndex)

                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }

    private var lessonTopBar: some View {
        HStack(spacing: 16) {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.gray)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.gray.opacity(0.15)).frame(height: 10)
                    Capsule()
                        .fill(LinearGradient(colors: [.green.opacity(0.7), .green],
                                             startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * progressFraction, height: 10)
                        .animation(.spring(response: 0.5), value: progressFraction)
                }
            }
            .frame(height: 10)

            HStack(spacing: 2) {
                ForEach(0..<3) { i in
                    Image(systemName: i < hearts ? "heart.fill" : "heart")
                        .foregroundColor(i < hearts ? .red : .gray.opacity(0.3))
                        .font(.system(size: 18))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
    }

    private func handleCorrect() {
        xpGained += 10
        withAnimation(.spring(response: 0.4)) {
            if currentExerciseIndex < lesson.exercises.count - 1 {
                currentExerciseIndex += 1
            } else {
                showComplete = true
            }
        }
    }

    private func handleWrong() {
        withAnimation(.spring()) {
            hearts = max(0, hearts - 1)
        }
        if hearts == 0 {
            // Opcional: mostrar tela de game over
        }
    }
}

// MARK: - Exercise View
struct ExerciseView: View {
    let exercise: Exercise
    let onCorrect: () -> Void
    let onWrong: () -> Void

    @State private var selectedAnswer: String? = nil
    @State private var showFeedback = false
    @State private var isCorrect = false
    @State private var shakeWrong = false

    var body: some View {
        VStack(spacing: 24) {
            questionCard
            optionsGrid

            if selectedAnswer != nil && !showFeedback {
                checkButton
            }

            if showFeedback {
                feedbackBanner
            }

            Spacer()
        }
    }

    private var questionCard: some View {
        VStack(spacing: 16) {
            Text(exercise.question)
                .font(.custom("Nunito-ExtraBold", size: 22))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)

            if let imageName = exercise.imageName {
                Image(systemName: imageName)
                    .font(.system(size: 60))
                    .foregroundColor(Color("brandTeal"))
                    .padding()
                    .background(Color("brandTeal").opacity(0.1))
                    .clipShape(Circle())
            }

            if let hint = exercise.hint {
                Text("💡 \(hint)")
                    .font(.custom("Nunito-SemiBold", size: 13))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.yellow.opacity(0.12))
                    .cornerRadius(12)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.06), radius: 10, y: 4)
    }

    private var optionsGrid: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]

        return LazyVGrid(columns: columns, spacing: 12) {
            ForEach(exercise.options, id: \.self) { option in
                OptionButton(
                    label: option,
                    state: optionState(for: option),
                    action: { selectOption(option) }
                )
                .modifier(ShakeModifier(shake: shakeWrong && selectedAnswer == option && !isCorrect))
            }
        }
    }

    private func optionState(for option: String) -> OptionState {
        guard showFeedback else {
            return selectedAnswer == option ? .selected : .normal
        }
        if option == exercise.correctAnswer { return .correct }
        if option == selectedAnswer { return .wrong }
        return .normal
    }

    private func selectOption(_ option: String) {
        guard !showFeedback else { return }
        selectedAnswer = option
    }

    private var checkButton: some View {
        Button(action: checkAnswer) {
            Text("Verificar")
                .font(.custom("Nunito-ExtraBold", size: 17))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.blue)
                .cornerRadius(16)
                .shadow(color: .blue.opacity(0.4), radius: 8, y: 4)
        }
    }

    private var feedbackBanner: some View {
        HStack(spacing: 12) {
            Text(isCorrect ? "🎉" : "😅")
                .font(.system(size: 30))

            VStack(alignment: .leading, spacing: 2) {
                Text(isCorrect ? "Correto!" : "Ops, não foi dessa vez!")
                    .font(.custom("Nunito-ExtraBold", size: 16))
                    .foregroundColor(isCorrect ? Color(hex: "#15803D") : Color(hex: "#B91C1C"))

                if !isCorrect {
                    Text("Resposta: \(exercise.correctAnswer)")
                        .font(.custom("Nunito-SemiBold", size: 13))
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            Button(action: { isCorrect ? onCorrect() : onWrong() }) {
                Text("Continuar")
                    .font(.custom("Nunito-ExtraBold", size: 15))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(isCorrect ? Color.green : Color.red.opacity(0.8))
                    .cornerRadius(12)
            }
        }
        .padding(16)
        .background(isCorrect ? Color.green.opacity(0.12) : Color.red.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isCorrect ? Color.green.opacity(0.4) : Color.red.opacity(0.3), lineWidth: 1.5)
        )
        .cornerRadius(16)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private func checkAnswer() {
        isCorrect = selectedAnswer == exercise.correctAnswer
        withAnimation(.spring(response: 0.4)) {
            showFeedback = true
        }
        if !isCorrect {
            withAnimation(.default) { shakeWrong = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                shakeWrong = false
            }
        }
    }
}

enum OptionState { case normal, selected, correct, wrong }

struct OptionButton: View {
    let label: String
    let state: OptionState
    let action: () -> Void

    var borderColor: Color {
        switch state {
        case .normal:   return Color.gray.opacity(0.2)
        case .selected: return Color.blue
        case .correct:  return Color.green
        case .wrong:    return Color.red
        }
    }

    var bgColor: Color {
        switch state {
        case .normal:   return .white
        case .selected: return Color.blue.opacity(0.08)
        case .correct:  return Color.green.opacity(0.1)
        case .wrong:    return Color.red.opacity(0.08)
        }
    }

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.custom("Nunito-ExtraBold", size: 17))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(bgColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(borderColor, lineWidth: 2)
                )
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        }
        .scaleEffect(state == .selected ? 1.03 : 1)
        .animation(.spring(response: 0.2), value: state)
    }
}

struct ShakeModifier: ViewModifier {
    let shake: Bool

    func body(content: Content) -> some View {
        content
            .offset(x: shake ? 8 : 0)
            .animation(
                shake ? Animation.default.repeatCount(4, autoreverses: true).speed(6) : .default,
                value: shake
            )
    }
}

struct LessonCompleteView: View {
    let xpGained: Int
    let onDismiss: () -> Void

    @State private var scale = 0.5
    @State private var opacity = 0.0

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("🎉")
                .font(.system(size: 80))
                .scaleEffect(scale)
                .animation(.spring(response: 0.6, dampingFraction: 0.5), value: scale)

            VStack(spacing: 8) {
                Text("Incrível!")
                    .font(.custom("Nunito-Black", size: 36))
                    .foregroundColor(Color("brandTeal"))

                Text("Você completou a lição!")
                    .font(.custom("Nunito-Bold", size: 18))
                    .foregroundColor(.gray)
            }

            HStack(spacing: 20) {
                StatBubble(icon: "⭐", label: "XP Ganho", value: "+\(xpGained)")
                StatBubble(icon: "🎯", label: "Acurácia", value: "100%")
            }

            Spacer()

            Button(action: onDismiss) {
                Text("Continuar →")
                    .font(.custom("Nunito-ExtraBold", size: 18))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(colors: [Color("brandTeal"), Color.blue],
                                       startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(18)
                    .shadow(color: .blue.opacity(0.4), radius: 10, y: 5)
                    .padding(.horizontal, 24)
            }
            .padding(.bottom, 40)
        }
        .onAppear {
            withAnimation { scale = 1; opacity = 1 }
        }
    }
}

struct StatBubble: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 6) {
            Text(icon).font(.system(size: 30))
            Text(value)
                .font(.custom("Nunito-Black", size: 22))
                .foregroundColor(.primary)
            Text(label)
                .font(.custom("Nunito-SemiBold", size: 12))
                .foregroundColor(.gray)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.06), radius: 8, y: 3)
    }
}

#Preview {
    NavigationStack {
        LessonView(lesson: LessonStore.shared.lessons[0])
            .environmentObject(UserProgress())
    }
}
