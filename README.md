# 🎯 FocusFlow

> **Master your productivity with the power of S.M.A.R.T Goals and the Eisenhower Matrix.**

FocusFlow is a mobile productivity application built with Flutter that guides users in setting structured goals using the SMART framework and managing daily tasks through the Eisenhower Priority Matrix.

---

## 📸 Preview

| Welcome | Onboarding | Home | Tasks | Priority | Analytics |
|:---:|:---:|:---:|:---:|:---:|:---:|
| Welcome Screen | SMART Goal Setup | Command Center | Kanban Board | Eisenhower Matrix | Weekly Insights |

---

## 👥 Tim Pengembang

| Nama | GitHub | Role |
|------|--------|------|
| **Hamid** | [@hamid](https://github.com/) | Core, Home, Shared Widgets |
| **Louis** | [@louis](https://github.com/) | Onboarding Flow |
| **Raja** | [@raja](https://github.com/) | Tasks Feature |
| **Octaf** | [@octaf](https://github.com/) | Priority Board & Analytics |

---

## ✨ Fitur Utama

- **SMART Goal Onboarding** — 5-step guided flow untuk mendefinisikan tujuan yang Specific, Measurable, Achievable, Relevant, dan Time-bound
- **Command Center** — Dashboard utama dengan ringkasan goal, progress, dan Focus Score harian
- **Task Management** — Kanban board (TODO / IN PROGRESS / DONE) dengan search dan tagging
- **Eisenhower Matrix** — Auto-classification task ke 4 kuadran: Do It Now, Schedule, Delegate, Drop
- **Analytics** — Weekly briefing, deep work hours, distribusi kuadran, dan activity heatmap

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart) |
| State Management | Riverpod |
| Navigation | GoRouter |
| Charts | fl_chart |
| Fonts | Plus Jakarta Sans (google_fonts) |
| Icons | flutter_svg |

---

## 🎨 Design System

| Token | Value |
|-------|-------|
| Primary | `#1B2A5E` (Dark Navy) |
| Secondary | `#D32F2F` (Red) |
| Tertiary | `#2E7D32` (Green) |
| Neutral | `#475569` |
| Background | `#EEF0F8` (Light Blue-Grey) |
| Font | Plus Jakarta Sans |
| Border Radius Cards | `12px` |
| Border Radius Inputs | `8px` |
| Border Radius Buttons | `24px` |

---

## 📁 Struktur Folder

```
focusflow/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── core/                          # [HAMID]
│   │   ├── theme/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_typography.dart
│   │   │   └── app_theme.dart
│   │   ├── constants/
│   │   │   └── app_constants.dart
│   │   └── router/
│   │       └── app_router.dart
│   │
│   ├── features/
│   │   ├── onboarding/                # [LOUIS]
│   │   │   ├── screens/
│   │   │   │   ├── welcome_screen.dart
│   │   │   │   ├── onboarding_specific_screen.dart
│   │   │   │   ├── onboarding_measurable_screen.dart
│   │   │   │   ├── onboarding_achievable_screen.dart
│   │   │   │   ├── onboarding_relevant_screen.dart
│   │   │   │   ├── onboarding_timebound_screen.dart
│   │   │   │   └── goal_summary_screen.dart
│   │   │   └── widgets/
│   │   │       ├── onboarding_progress_bar.dart
│   │   │       ├── onboarding_step_header.dart
│   │   │       ├── smart_badge.dart
│   │   │       └── goal_summary_card.dart
│   │   │
│   │   ├── home/                      # [HAMID]
│   │   │   ├── screens/
│   │   │   │   └── home_screen.dart
│   │   │   └── widgets/
│   │   │       ├── current_goal_card.dart
│   │   │       ├── focus_flow_list.dart
│   │   │       ├── momentum_section.dart
│   │   │       ├── focus_score_card.dart
│   │   │       └── bottom_nav_bar.dart
│   │   │
│   │   ├── tasks/                     # [RAJA]
│   │   │   ├── screens/
│   │   │   │   ├── tasks_screen.dart
│   │   │   │   ├── create_task_screen.dart
│   │   │   │   └── task_detail_screen.dart
│   │   │   └── widgets/
│   │   │       ├── task_card.dart
│   │   │       ├── task_section_header.dart
│   │   │       ├── task_status_stepper.dart
│   │   │       ├── matrix_assessment_slider.dart
│   │   │       ├── predicted_placement_chip.dart
│   │   │       └── add_task_fab.dart
│   │   │
│   │   └── analytics_priority/        # [OCTAF]
│   │       ├── screens/
│   │       │   ├── priority_board_screen.dart
│   │       │   └── analytics_screen.dart
│   │       └── widgets/
│   │           ├── eisenhower_quadrant_card.dart
│   │           ├── quadrant_task_item.dart
│   │           ├── analytics_header_card.dart
│   │           ├── weekly_briefing_card.dart
│   │           ├── eisenhower_pie_chart.dart
│   │           └── activity_heatmap.dart
│   │
│   └── shared/                        # [HAMID]
│       └── widgets/
│           ├── app_button.dart
│           ├── app_text_field.dart
│           ├── app_tag_chip.dart
│           ├── progress_bar.dart
│           └── section_title.dart
│
├── assets/
│   └── fonts/
│       └── PlusJakartaSans/
│
└── pubspec.yaml
```

---

## 🗺️ User Flow

```
Welcome Screen
    └──▶ Onboarding Step 1: Specific Goal
             └──▶ Step 2: Measurable
                      └──▶ Step 3: Achievable
                               └──▶ Step 4: Relevant
                                        └──▶ Step 5: Time-bound
                                                 └──▶ Goal Summary Preview
                                                          └──▶ Home (Command Center)
                                                                   ├──▶ Tasks (Kanban)
                                                                   │        ├──▶ Create Task
                                                                   │        └──▶ Task Detail
                                                                   ├──▶ Priority Board (Eisenhower)
                                                                   └──▶ Analytics
```

---

## 🚀 Cara Menjalankan Project

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio / VS Code dengan Flutter plugin

### Installation

```bash
# 1. Clone repository
git clone https://github.com/<org>/focusflow.git
cd focusflow

# 2. Install dependencies
flutter pub get

# 3. Jalankan aplikasi
flutter run
```

---

## 🌿 Git Workflow & Branch Convention

Setiap anggota tim bekerja di branch masing-masing berdasarkan fitur yang dikerjakan.

### Branch Naming

```
feature/<nama>/<deskripsi-singkat>

Contoh:
  feature/hamid/core-theme
  feature/hamid/home-screen
  feature/louis/onboarding-flow
  feature/raja/tasks-feature
  feature/octaf/priority-analytics
```

### Alur Kerja

```bash
# Buat branch baru dari main
git checkout main
git pull origin main
git checkout -b feature/<nama>/<fitur>

# Setelah selesai, push branch
git add .
git commit -m "feat(<scope>): <deskripsi>"
git push origin feature/<nama>/<fitur>

# Buat Pull Request ke branch main
# Minta review dari minimal 1 anggota tim sebelum merge
```

### Commit Message Convention

Gunakan format **Conventional Commits**:

| Prefix | Kegunaan |
|--------|----------|
| `feat` | Fitur baru |
| `fix` | Bug fix |
| `style` | Perubahan styling/UI |
| `refactor` | Refactoring kode |
| `chore` | Update dependency, config |
| `docs` | Update dokumentasi |

**Contoh:**
```
feat(tasks): add create task screen with matrix assessment
fix(onboarding): fix progress bar not updating on step change
style(home): adjust spacing on current goal card
```

---

## 📋 Pembagian Tugas

### Hamid — Core, Home & Shared
- Setup project Flutter (pubspec, struktur folder)
- `core/theme/` — AppColors, AppTypography, AppTheme
- `core/router/` — GoRouter setup, semua route
- `shared/widgets/` — AppButton, AppTextField, AppTagChip, ProgressBar, SectionTitle
- `features/home/` — HomeScreen + semua home widgets

### Louis — Onboarding Flow
- `features/onboarding/screens/` — WelcomeScreen + 5 step onboarding + GoalSummaryScreen
- `features/onboarding/widgets/` — OnboardingProgressBar, StepHeader, SmartBadge, GoalSummaryCard

### Raja — Tasks Feature
- `features/tasks/screens/` — TasksScreen, CreateTaskScreen, TaskDetailScreen
- `features/tasks/widgets/` — TaskCard, SectionHeader, StatusStepper, MatrixSlider, PlacementChip, FAB

### Octaf — Priority Board & Analytics
- `features/analytics_priority/screens/` — PriorityBoardScreen, AnalyticsScreen
- `features/analytics_priority/widgets/` — EisenhowerQuadrantCard, PieChart, Heatmap, WeeklyBriefing

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^13.0.0
  flutter_riverpod: ^2.5.0
  fl_chart: ^0.68.0
  google_fonts: ^6.2.0
  flutter_svg: ^2.0.10

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
```

---

## 📄 Lisensi

Proyek ini dibuat untuk keperluan akademik. All rights reserved © 2024 Tim FocusFlow.
