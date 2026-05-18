import SwiftUI

struct HomeView: View {
    @EnvironmentObject var progress: UserProgress
    let lessons = LessonStore.shared.lessons

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color("backgroundBlue")
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    headerSection

                    progressSection
                        .padding(.horizontal, 16)
                        .padding(.top, 12)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            sectionLabel("Módulos de Hoje")
                                .padding(.top, 8)

                            lessonsStack
                                .padding(.bottom, 100)
                        }
                        .padding(.horizontal, 16)
                    }
                }

                BottomNavBar()
            }
            .navigationBarHidden(true)
        }
    }

    private var headerSection: some View {
        HStack {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: [Color("brandOrange"), Color("brandYellow")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                        .shadow(color: Color("brandOrange").opacity(0.4), radius: 8, y: 4)

                    Text("🌟")
                        .font(.system(size: 22))
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text("Aprenda")
                        .font(.custom("Nunito-Black", size: 16))
                        .foregroundColor(Color("brandTeal"))
                    Text("Brincando")
                        .font(.custom("Nunito-Black", size: 16))
                        .foregroundColor(Color("brandOrange"))
                }
            }

            Spacer()

            HStack(spacing: 8) {
                BadgeView(icon: "🔥", value: "\(progress.streakDays) dias", bgColor: Color.red.opacity(0.1), borderColor: .red.opacity(0.4), textColor: .red)
                BadgeView(icon: "⭐", value: "\(progress.stars)", bgColor: Color.yellow.opacity(0.15), borderColor: .yellow.opacity(0.6), textColor: Color(red: 0.8, green: 0.6, blue: 0))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color.white)
    }

    private var progressSection: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Lição \(progress.currentLesson + 1) de \(lessons.count)")
                    .font(.custom("Nunito-Bold", size: 15))
                    .foregroundColor(.primary)
                Spacer()
                Text("🎁")
                    .font(.system(size: 22))
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 12)

                    Capsule()
                        .fill(LinearGradient(
                            colors: [Color.green.opacity(0.8), Color.green],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(
                            width: geo.size.width * CGFloat(progress.currentLesson) / CGFloat(max(lessons.count, 1)),
                            height: 12
                        )
                        .animation(.spring(response: 0.6), value: progress.currentLesson)
                }
            }
            .frame(height: 12)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.06), radius: 8, y: 3)
    }

    private var lessonsStack: some View {
        HStack(alignment: .top, spacing: 0) {
            stepLine

            VStack(spacing: 10) {
                ForEach(Array(lessons.enumerated()), id: \.offset) { index, lesson in
                    if index == progress.currentLesson {
                        ActiveLessonCard(lesson: lesson)
                    } else {
                        LockedLessonCard(lesson: lesson, isCompleted: index < progress.currentLesson)
                    }
                }
            }
            .padding(.leading, 12)
        }
    }

    private var stepLine: some View {
        VStack(spacing: 0) {
            ForEach(0..<lessons.count, id: \.self) { index in
                VStack(spacing: 0) {
                    ZStack {
                        Circle()
                            .fill(index == progress.currentLesson ? Color.blue : index < progress.currentLesson ? Color.green : Color.white)
                            .frame(width: 28, height: 28)
                            .overlay(
                                Circle()
                                    .stroke(index == progress.currentLesson ? Color.blue : index < progress.currentLesson ? Color.green : Color.gray.opacity(0.3), lineWidth: 2)
                            )

                        if index < progress.currentLesson {
                            Text("✓").font(.system(size: 12, weight: .bold)).foregroundColor(.white)
                        } else {
                            Text("\(index + 1)")
                                .font(.custom("Nunito-ExtraBold", size: 12))
                                .foregroundColor(index == progress.currentLesson ? .white : .gray)
                        }
                    }

                    if index < lessons.count - 1 {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 2, height: 80)
                    }
                }
            }
        }
        .padding(.top, 26)
    }

    private func sectionLabel(_ text: String) -> some View {
        HStack {
            Text(text.uppercased())
                .font(.custom("Nunito-Bold", size: 12))
                .foregroundColor(.gray)
                .kerning(1)
            Spacer()
        }
        .padding(.bottom, 6)
    }
}

struct BadgeView: View {
    let icon: String
    let value: String
    let bgColor: Color
    let borderColor: Color
    let textColor: Color

    var body: some View {
        HStack(spacing: 4) {
            Text(icon).font(.system(size: 14))
            Text(value)
                .font(.custom("Nunito-ExtraBold", size: 13))
                .foregroundColor(textColor)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(bgColor)
        .overlay(Capsule().stroke(borderColor, lineWidth: 1.5))
        .clipShape(Capsule())
    }
}

struct ActiveLessonCard: View {
    let lesson: Lesson

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .frame(width: 52, height: 52)
                        .shadow(color: .black.opacity(0.1), radius: 6, y: 3)
                    Text(lesson.emoji).font(.system(size: 28))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(lesson.title)
                        .font(.custom("Nunito-Black", size: 18))
                        .foregroundColor(Color(hex: "#1E40AF"))
                    Text(lesson.subtitle)
                        .font(.custom("Nunito-SemiBold", size: 13))
                        .foregroundColor(Color(hex: "#3B82F6"))
                }
                Spacer()
            }

            HStack {
                HStack(spacing: 8) {
                    Text("A")
                        .font(.custom("Nunito-Black", size: 36))
                        .foregroundColor(Color("brandTeal"))
                    Text("🐝")
                        .font(.system(size: 24))
                    Text("**A**belha")
                        .font(.custom("Nunito-Bold", size: 16))
                        .foregroundColor(.primary)
                }
                Spacer()

                NavigationLink(destination: LessonView(lesson: lesson)) {
                    HStack(spacing: 4) {
                        Text("Continuar")
                        Image(systemName: "arrow.right")
                    }
                    .font(.custom("Nunito-ExtraBold", size: 15))
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .background(LinearGradient(colors: [Color(hex: "#3B82F6"), Color(hex: "#2563EB")], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(14)
                }
            }
            .padding(14)
            .background(Color.white)
            .cornerRadius(14)
        }
        .padding(16)
        .background(LinearGradient(colors: [Color(hex: "#E0F2FE"), Color(hex: "#DBEAFE")], startPoint: .topLeading, endPoint: .bottomTrailing))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color(hex: "#93C5FD"), lineWidth: 2))
        .cornerRadius(22)
    }
}

struct LockedLessonCard: View {
    let lesson: Lesson
    let isCompleted: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.08))
                    .frame(width: 50, height: 50)
                Text(lesson.emoji).font(.system(size: 26))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(lesson.title)
                    .font(.custom("Nunito-ExtraBold", size: 16))
                    .foregroundColor(isCompleted ? .primary : Color.gray.opacity(0.7))
                Text(lesson.subtitle)
                    .font(.custom("Nunito-SemiBold", size: 12))
                    .foregroundColor(.gray.opacity(0.6))
            }

            Spacer()

            Image(systemName: isCompleted ? "checkmark.circle.fill" : "chevron.right")
                .foregroundColor(isCompleted ? .green : .gray.opacity(0.4))
                .font(.system(size: 18, weight: .bold))
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(18)
        .opacity(isCompleted ? 1 : 0.65)
    }
}

struct BottomNavBar: View {
    @State private var selected = 0

    var body: some View {
        HStack {
            navItem(icon: "house.fill", label: "Início", index: 0)
            navItem(icon: "book.fill", label: "Atividades", index: 1)
            navItem(icon: "chart.bar.fill", label: "Progresso", index: 2)
            navItem(icon: "face.smiling", label: "Perfil", index: 3)
        }
        .padding(.horizontal, 8)
        .padding(.top, 10)
        .padding(.bottom, 24)
        .background(Color.white)
    }

    private func navItem(icon: String, label: String, index: Int) -> some View {
        Button(action: { selected = index }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(selected == index ? Color.blue : .gray.opacity(0.5))
                Text(label)
                    .font(.custom("Nunito-Bold", size: 11))
                    .foregroundColor(selected == index ? .blue : .gray.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(selected == index ? Color.blue.opacity(0.08) : Color.clear)
            .cornerRadius(12)
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    HomeView()
        .environmentObject(UserProgress())
}
