import SwiftUI

@main
struct AprendaBrincandoApp: App {
    @StateObject private var progress = UserProgress()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(progress)
        }
    }
}

/*
 ╔══════════════════════════════════════════════════════════════╗
 ║          CONFIGURAÇÃO DO PROJETO NO XCODE                   ║
 ╠══════════════════════════════════════════════════════════════╣
 ║                                                              ║
 ║  1. CRIAR PROJETO                                            ║
 ║     File → New → Project → App (iOS)                        ║
 ║     • Product Name: AprendaBrincando                        ║
 ║     • Interface: SwiftUI                                    ║
 ║     • Language: Swift                                       ║
 ║                                                              ║
 ║  2. ESTRUTURA DE PASTAS                                      ║
 ║     Crie grupos no Xcode:                                    ║
 ║     📁 Models/                                               ║
 ║        • Models.swift                                        ║
 ║        • LessonStore.swift                                   ║
 ║     📁 Views/                                                ║
 ║        • HomeView.swift                                      ║
 ║        • LessonView.swift                                    ║
 ║     • AprendaBrincandoApp.swift (este arquivo)               ║
 ║                                                              ║
 ║  3. CORES (Assets.xcassets → New Color Set)                  ║
 ║     Crie estas cores no Assets.xcassets:                     ║
 ║                                                              ║
 ║     backgroundBlue  → #F0F8FF                                ║
 ║     brandTeal       → #2DD4BF                                ║
 ║     brandOrange     → #FF8C42                                ║
 ║     brandYellow     → #FFD93D                                ║
 ║     lessonBlue      → #3B82F6                                ║
 ║     lessonPurple    → #8B5CF6                                ║
 ║     lessonOrange    → #F97316                                ║
 ║     lessonGreen     → #22C55E                                ║
 ║     lessonYellow    → #EAB308                                ║
 ║                                                              ║
 ║  4. FONTE NUNITO (opcional, mas recomendado)                 ║
 ║     • Baixe em fonts.google.com/specimen/Nunito              ║
 ║     • Adicione os .ttf ao projeto                            ║
 ║     • No Info.plist adicione:                                ║
 ║       "Fonts provided by application" → cada arquivo .ttf   ║
 ║     • Ou substitua por .system(.body, design: .rounded)      ║
 ║                                                              ║
 ║  5. RODAR                                                    ║
 ║     Selecione iPhone 15 simulator → ▶ Run                    ║
 ║                                                              ║
 ╚══════════════════════════════════════════════════════════════╝
*/
