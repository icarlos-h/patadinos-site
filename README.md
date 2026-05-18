# PataDinos (SwiftUI)

Aplicativo em SwiftUI para o universo infantil educativo PataDinos.

## Objetivo

Migrar a experiência de landing page para uma interface nativa iOS com navegação por lições, progresso e componentes visuais infantis.

## Estrutura

- `ios/PataDinosApp/HomeView.swift`: tela principal em SwiftUI com:
  - cabeçalho com badges de streak e estrelas;
  - barra de progresso da trilha;
  - lista de lições com estados ativo/concluído/bloqueado;
  - barra de navegação inferior.

## Componentes principais

- `HomeView`
- `BadgeView`
- `ActiveLessonCard`
- `LockedLessonCard`
- `BottomNavBar`
- `Color(hex:)` (extensão utilitária)

## Dependências de modelo

O arquivo utiliza tipos esperados no app:

- `UserProgress`
- `LessonStore`
- `Lesson`
- `LessonView`

## Tecnologias

- Swift 5+
- SwiftUI

## Status

Em desenvolvimento.


## Arquivos Swift adicionados

- `ios/PataDinosApp/Models.swift`: modelos `Lesson`, `Exercise`, `UserProgress` e `LessonStore`.
- `ios/PataDinosApp/LessonView.swift`: tela placeholder da lição para navegação.

- `ios/PataDinosApp/AprendaBrincandoApp.swift`: ponto de entrada do app com `@main` e injeção de `UserProgress` no ambiente.
