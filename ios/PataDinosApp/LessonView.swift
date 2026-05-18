import SwiftUI

struct LessonView: View {
    let lesson: Lesson

    var body: some View {
        Text(lesson.title)
            .font(.title)
            .navigationTitle("Lição")
    }
}
