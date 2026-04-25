# FocusFlow — Flutter Stub Scaffold (SMART + Eisenhower)

## TL;DR
> **Summary**: Bootstrap a new Flutter app and generate a compile-clean stub scaffold (core theme/router/constants + shared widgets/models + feature screens/widgets) so the 4-person team can implement UI/logic independently.
> **Deliverables**: Flutter project created (`com.focusflow`), dependencies added, full folder/file tree created with `// ASSIGNED TO:` headers + TODOs, `go_router` wired, `flutter analyze` + `flutter test` passing.
> **Effort**: Medium
> **Parallel**: YES — 3 waves
> **Critical Path**: Bootstrap project → add deps + core theme/router/constants/models → generate feature stubs → wire router/app → QA gates

## Context
### Original Request
- Generate a prompt/work plan to scaffold **FocusFlow** (Flutter) stub files for:
  - SMART onboarding flow (5 steps + summary)
  - Home command center + bottom nav
  - Tasks (kanban/list + create + detail)
  - Priority board (Eisenhower matrix)
  - Analytics (charts + heatmap)
- Enforce a design system and consistent stub conventions.

### Interview Summary (decisions confirmed)
- `flutter create` org id: `com.focusflow`
- Platforms: `android,ios`
- State management dependency: `provider`
- QA strictness: default compile gates (pub get + format + analyze(no errors) + test + 1 build target)

**Package/Bundler ID clarification (decision-complete)**:
- With `flutter create --org com.focusflow ... focusflow`, Android `applicationId` will be `com.focusflow.focusflow` and iOS bundle id will be analogous.
- This is acceptable for this scaffold; do **not** manually rename IDs in this phase.

### Metis Review (gaps addressed)
- Repo is empty → plan includes exact bootstrap commands.
- Resolve “no hardcoded strings” conflict by storing non-placeholder copy/paths in `AppConstants` (stubs may still show widget-name placeholder labels).
- Ensure router/theme are *used* by `MaterialApp.router` so code is compiled.
- Add concrete QA gates: `flutter pub get`, `dart format --output=none`, `flutter analyze` (no errors), `flutter test`, and Android debug build smoke test.

## Work Objectives
### Core Objective
Create a runnable Flutter shell app that compiles and routes to all screens, with all screens/widgets present as stubs and ready for team implementation.

### Deliverables
1. Flutter project skeleton created in this repo root.
2. Dependencies added in `pubspec.yaml`:
   - `flutter_svg`, `go_router`, `fl_chart`, `google_fonts`, `provider`
3. Source scaffold:
   - `lib/main.dart`, `lib/app.dart`
   - `lib/core/{theme,constants,router}/...`
   - `lib/shared/{models,widgets}/...`
   - `lib/features/{onboarding,home,tasks,analytics_priority}/{screens,widgets}/...`
4. All stub files follow the **Stub File Contract** (below).
5. Router paths implemented exactly as specified.

### Definition of Done (agent-verifiable)
From repo root:
1. `flutter doctor -v` runs (output captured as evidence).
2. `flutter pub get` exits 0.
3. `dart format --output=none .` exits 0.
4. `flutter analyze` exits 0 **with zero errors** (warnings allowed).
5. `flutter test` exits 0.
6. Smoke build (see Decision Note below): one of the following exits 0 and evidence is captured:
   - `flutter build apk --debug`
   - OR (if Android toolchain is missing) enable an additional buildable platform and run its build (Decision Note).

**Decision Note (environment-sensitive)**:
- This environment is Windows. iOS builds are not possible here.
- If `flutter doctor -v` reports Android toolchain missing/unavailable, you must choose ONE:
  1) Install Android toolchain (Android Studio/SDK) and keep `android,ios` only, OR
  2) Add a buildable platform (recommended: `web` or `windows`) and use that for the smoke build gate.
  The plan below defaults to option (1) *if toolchain is already present*; otherwise it becomes a decision.

### Must Have
- Every listed file exists at the exact path and compiles.
- Every Dart file contains:
  - `// ASSIGNED TO: <Name>` as the very first non-empty line.
  - A short doc/comment block describing intent.
  - A `TODO(<Name>): ...` comment describing what the assignee should implement.
  - Correct class name matching filename (PascalCase).
  - `const` constructor, named parameters, and `Key? key`.
  - Placeholder UI showing **widget name** (e.g., `Text('WelcomeScreen')`).
- `AppTheme` + `AppTypography` + `AppColors` exist and are referenced by the app.
- `go_router` configured via `MaterialApp.router`.

### Must NOT Have (guardrails)
- No real UI layout fidelity, persistence, API calls, authentication, analytics events, localization/i18n scaffolding, or code generation.
- No additional dependencies beyond the specified list.
- No “barrel exports” (e.g., `index.dart`) in this scaffold — use explicit imports to avoid circular deps during early-stage stubbing.
 - Do not add extra platforms **unless** Android toolchain is missing; then you may add exactly ONE fallback platform (`web` OR `windows`) solely to satisfy the smoke-build gate.

## Verification Strategy
> ZERO HUMAN INTERVENTION — all verification is command-driven.
- Test decision: **tests-after** (compile gates only; no new test suite beyond updating default widget test).
- Evidence files:
  - `.sisyphus/evidence/doctor.txt`
  - `.sisyphus/evidence/pub-get.txt`
  - `.sisyphus/evidence/format.txt`
  - `.sisyphus/evidence/analyze.txt`
  - `.sisyphus/evidence/test.txt`
  - `.sisyphus/evidence/build-apk.txt`
  - (optional alternative) `.sisyphus/evidence/build-alt.txt`

## Execution Strategy
### Stub File Contract (apply to EVERY Dart file listed below)
1. Header line: `// ASSIGNED TO: <Hamid|Louis|Raja|Octaf>`
2. Intent comment block (2–4 lines) describing what it will render.
3. Widget/class name must match filename:
   - `welcome_screen.dart` → `WelcomeScreen`
   - `app_bottom_nav_bar.dart` → `AppBottomNavBar`
4. Constructor:
   - `const <ClassName>({super.key, ...named params...});`
5. Placeholder body:
   - Must visibly render `Text('<ClassName>')` (allowed hardcoded placeholder).
6. Parameters:
   - Declare exactly the parameters specified in **File List & Signatures**.
   - Parameters may be unused in stub build methods (warnings acceptable).
7. Strings policy:
   - Allowed hardcoded string: the widget-name placeholder label.
   - All other copy/route paths live in `AppConstants`.

### Parallel Execution Waves
Wave 1 (Foundation — blocks all others)
- Project bootstrap (`flutter create`) + dependency setup
- Core theme/typography/colors/constants
- Shared models (`TaskItem`, `SmartItem`)
- Router skeleton (paths constants + GoRouter table)

Wave 2 (Independent stubs — parallel by feature)
- Shared widgets stubs
- Onboarding stubs (Louis)
- Home stubs (Hamid)
- Tasks stubs (Raja)
- Analytics/Priority stubs (Octaf)

Wave 3 (Integration + QA)
- Wire `app.dart` + router + bottom nav navigation placeholders
- Update default tests to reference `FocusFlowApp`
- Run QA gates and capture evidence

### Dependency Matrix (full)
- 1 → blocks 2–6
- 2,3,4,5,6 → block 7

### Agent Dispatch Summary
- Wave 1: 1 task (unspecified-high)
- Wave 2: 5 tasks in parallel (quick/unspecified-low)
- Wave 3: 1 task (unspecified-high)

## File List & Signatures (authoritative)

### Bootstrap / App entry
- `lib/main.dart` — **ASSIGNED TO: Hamid**
  - Must call `runApp(const FocusFlowApp())`
- `lib/app.dart` — **ASSIGNED TO: Hamid**
  - `class FocusFlowApp extends StatelessWidget`
  - Uses `MaterialApp.router(routerConfig: AppRouter.router, theme: AppTheme.lightTheme, ...)`

### Core
- `lib/core/constants/app_constants.dart` — **ASSIGNED TO: Hamid**
  - `abstract class AppConstants` with:
    - `static const String appName = 'FocusFlow';`
  - `abstract class AppRoutes` with static const route paths listed in request.
  - `abstract class AppCopy` with:
    - welcome title/subtitle (from request)
    - any other non-placeholder copy used in stubs (optional; keep minimal)

#### Theme
- `lib/core/theme/app_colors.dart` — **ASSIGNED TO: Hamid**
  - `abstract class AppColors` with `static const Color ...`:
    - primary `0xFF1B2A5E`
    - secondary `0xFFD32F2F`
    - tertiary `0xFF2E7D32`
    - neutral `0xFF475569`
    - background `0xFFEEF0F8`
    - plus any minimal supporting tokens required by `AppTheme` (surface, textPrimary) but keep to minimum.
- `lib/core/theme/app_typography.dart` — **ASSIGNED TO: Hamid**
  - `abstract class AppTypography` with TextStyles:
    - `headlineLarge`, `headlineMedium`, `bodyLarge`, `bodyMedium`, `labelMedium`, `labelSmall`
  - Use `GoogleFonts.plusJakartaSans(...)` with weights 400/500/600/700.
- `lib/core/theme/app_theme.dart` — **ASSIGNED TO: Hamid**
  - `abstract class AppTheme` with:
    - `static ThemeData get lightTheme` returning ThemeData referencing `AppColors` + `AppTypography`.
    - Configure radii: cards 12, inputs 8, buttons 24.

#### Router
- `lib/core/router/app_router.dart` — **ASSIGNED TO: Hamid**
  - `abstract class AppRouter` with:
    - `static final GoRouter router = GoRouter(routes: [...])`
  - Must include GoRoutes for every path.
  - For `/tasks/:id`, route builder must extract `id` and pass into `TaskDetailScreen(taskId: id)`.
  - Must map all `AppRoutes.*` above to their corresponding Screen widgets:
    - `/welcome` → `WelcomeScreen`
    - `/onboarding/specific` → `OnboardingSpecificScreen`
    - `/onboarding/measurable` → `OnboardingMeasurableScreen`
    - `/onboarding/achievable` → `OnboardingAchievableScreen`
    - `/onboarding/relevant` → `OnboardingRelevantScreen`
    - `/onboarding/timebound` → `OnboardingTimeboundScreen`
    - `/goal-summary` → `GoalSummaryScreen`
    - `/home` → `HomeScreen`
    - `/tasks` → `TasksScreen`
    - `/tasks/create` → `CreateTaskScreen`
    - `/tasks/:id` → `TaskDetailScreen(taskId: id)`
    - `/priority` → `PriorityBoardScreen`
    - `/analytics` → `AnalyticsScreen`

### Shared models (compile support)
- `lib/shared/models/task_item.dart` — **ASSIGNED TO: Hamid**
  - `class TaskItem` with:
    - `final String id;`
    - `final String title;`
    - `final String? subtitle;`
    - `final List<String> tags;`
    - `final String? dueDate;`
    - `final String? quadrant;` (expects values like `Q1`..`Q4`)
    - `final bool isCompleted;`
    - const constructor with defaults (`tags = const []`, `isCompleted = false`).
- `lib/shared/models/smart_item.dart` — **ASSIGNED TO: Hamid**
  - `class SmartItem` with:
    - `final String label;`
    - `final bool isCompleted;`
    - const constructor.

### Shared widgets (all stubs)
- `lib/shared/widgets/app_button.dart` — **ASSIGNED TO: Hamid**
  - `enum AppButtonVariant { primary, secondary, outlined, inverted }`
  - `class AppButton extends StatelessWidget`
  - Params: `label (String)`, `onPressed (VoidCallback)`, `variant (AppButtonVariant)`
- `lib/shared/widgets/app_text_field.dart` — **ASSIGNED TO: Hamid**
  - Params: `hint (String)`, `controller (TextEditingController)`, `label (String?)`, `maxLines (int)`
- `lib/shared/widgets/app_tag_chip.dart` — **ASSIGNED TO: Hamid**
  - Params: `label (String)`, `color (Color?)`
- `lib/shared/widgets/progress_bar.dart` — **ASSIGNED TO: Hamid**
  - `class AppProgressBar extends StatelessWidget`
  - Params: `value (double)`, `color (Color?)`
- `lib/shared/widgets/section_title.dart` — **ASSIGNED TO: Hamid**
  - Params: `title (String)`, `actionLabel (String?)`, `onAction (VoidCallback?)`

### Onboarding — Louis
#### Screens
- `lib/features/onboarding/screens/welcome_screen.dart` — `WelcomeScreen`
- `lib/features/onboarding/screens/onboarding_specific_screen.dart` — `OnboardingSpecificScreen`
- `lib/features/onboarding/screens/onboarding_measurable_screen.dart` — `OnboardingMeasurableScreen`
- `lib/features/onboarding/screens/onboarding_achievable_screen.dart` — `OnboardingAchievableScreen`
- `lib/features/onboarding/screens/onboarding_relevant_screen.dart` — `OnboardingRelevantScreen`
- `lib/features/onboarding/screens/onboarding_timebound_screen.dart` — `OnboardingTimeboundScreen`
- `lib/features/onboarding/screens/goal_summary_screen.dart` — `GoalSummaryScreen`

#### Widgets
- `lib/features/onboarding/widgets/onboarding_progress_bar.dart`
  - `class OnboardingProgressBar extends StatelessWidget`
  - Params: `currentStep (int)`, `totalSteps (int)`
- `lib/features/onboarding/widgets/onboarding_step_header.dart`
  - Params: `stepNumber (int)`, `totalSteps (int)`, `badgeLabel (String)`
- `lib/features/onboarding/widgets/smart_badge.dart`
  - Params: `label (String)`, `isCompleted (bool)`
- `lib/features/onboarding/widgets/goal_summary_card.dart`
  - Params: `title (String)`, `smartItems (List<SmartItem>)`

### Home — Hamid
#### Screens
- `lib/features/home/screens/home_screen.dart`
  - `class HomeScreen extends StatelessWidget`
  - Must render placeholder + include the 4 referenced widgets below (can be in a Column).

#### Widgets
- `lib/features/home/widgets/current_goal_card.dart`
  - Params: `goalTitle (String)`, `progressValue (double)`, `smartBadges (List<String>)`, `timeRemaining (String)`
- `lib/features/home/widgets/focus_flow_list.dart`
  - Params: `tasks (List<TaskItem>)`
- `lib/features/home/widgets/momentum_section.dart`
  - No params
- `lib/features/home/widgets/focus_score_card.dart`
  - Params: `score (int)`
- `lib/features/home/widgets/bottom_nav_bar.dart`
  - `class AppBottomNavBar extends StatelessWidget`
  - Params: `currentIndex (int)`, `onTap (ValueChanged<int>)`
  - Must define 4 items: Home, Tasks, Priority, Analytics (labels can reference `AppCopy` constants).

### Tasks — Raja
#### Screens
- `lib/features/tasks/screens/tasks_screen.dart` — `TasksScreen`
- `lib/features/tasks/screens/create_task_screen.dart` — `CreateTaskScreen`
- `lib/features/tasks/screens/task_detail_screen.dart` — `TaskDetailScreen`
  - Params: `taskId (String)` **required** (to satisfy `/tasks/:id`).

#### Widgets
- `lib/features/tasks/widgets/task_card.dart`
  - Params: `title (String)`, `tags (List<String>)`, `dueDate (String?)`, `quadrant (String?)`, `isCompleted (bool)`
- `lib/features/tasks/widgets/task_section_header.dart`
  - Params: `label (String)`, `count (int)`, `color (Color)`
- `lib/features/tasks/widgets/task_status_stepper.dart`
  - Params: `currentStatus (String)` (expects `todo|in_progress|done`)
- `lib/features/tasks/widgets/matrix_assessment_slider.dart`
  - Params: `label (String)`, `value (double)`, `onChanged (ValueChanged<double>)`, `lowLabel (String)`, `highLabel (String)`
- `lib/features/tasks/widgets/predicted_placement_chip.dart`
  - Params: `quadrant (String)`, `description (String)`
- `lib/features/tasks/widgets/add_task_fab.dart`
  - Params: `onPressed (VoidCallback)`

### Analytics + Priority — Octaf
#### Screens
- `lib/features/analytics_priority/screens/priority_board_screen.dart` — `PriorityBoardScreen`
- `lib/features/analytics_priority/screens/analytics_screen.dart` — `AnalyticsScreen`

#### Widgets
- `lib/features/analytics_priority/widgets/eisenhower_quadrant_card.dart`
  - Params: `quadrantLabel (String)`, `urgencyLabel (String)`, `importanceLabel (String)`, `tasks (List<TaskItem>)`, `color (Color)`
- `lib/features/analytics_priority/widgets/quadrant_task_item.dart`
  - Params: `title (String)`, `subtitle (String?)`, `isCompleted (bool)`
- `lib/features/analytics_priority/widgets/analytics_header_card.dart`
  - Params: `goalTitle (String)`, `completionPercent (double)`
- `lib/features/analytics_priority/widgets/weekly_briefing_card.dart`
  - Params: `deepWorkHours (int)`, `completionPercent (int)`, `insightText (String)`
- `lib/features/analytics_priority/widgets/eisenhower_pie_chart.dart`
  - Params: `q1 (double)`, `q2 (double)`, `q3 (double)`, `q4 (double)`
  - Stub must render placeholder; `fl_chart` usage is TODO.
- `lib/features/analytics_priority/widgets/activity_heatmap.dart`
  - Params: `activityData (Map<DateTime, int>)`
  - Stub must render placeholder; calendar grid rendering is TODO.

## TODOs

> Note: Each TODO below combines implementation + verification steps.

- [x] 1. Bootstrap Flutter project + add dependencies (foundation)

  **What to do**:
  1. Confirm Flutter is installed:
     - Run `flutter --version` and `flutter doctor -v`.
     - Save doctor output to `.sisyphus/evidence/doctor.txt`.
     - Ensure `.sisyphus/evidence/` exists.
  2. Create Flutter project **in this repo root**:
     - Command (from repo root):
       - `flutter create --org com.focusflow --platforms android,ios focusflow`
     - Then move generated contents up one level so repo root becomes the Flutter project root (decision):
       - PowerShell-safe move:
         - `Get-ChildItem -Path "focusflow" -Force | Move-Item -Destination "." -Force`
       - Remove the now-empty `focusflow/` directory:
         - `Remove-Item -Recurse -Force "focusflow"`
  3. Add dependencies using Flutter tooling (do not hand-edit versions):
     - `flutter pub add flutter_svg go_router fl_chart google_fonts provider`
  4. Create required feature directories under `lib/` per file list.
  5. Run and capture:
     - `flutter pub get` → `.sisyphus/evidence/pub-get.txt`
     - `dart format --output=none .` → `.sisyphus/evidence/format.txt`

  **Must NOT do**:
  - Do not add any dependency not listed.
  - Do not generate extra platforms, **except** if Android toolchain is missing; then add exactly ONE fallback platform (`web` OR `windows`) for smoke-build only.

  **Recommended Agent Profile**:
  - Category: `unspecified-high` — Reason: multi-step bootstrap + pubspec wiring + filesystem layout.
  - Skills: []

  **Parallelization**: Can Parallel: NO | Wave 1 | Blocks: 2–7 | Blocked By: none

  **References**:
  - External: https://docs.flutter.dev/reference/flutter-cli

  **Acceptance Criteria**:
  - [ ] `pubspec.yaml` exists in repo root.
  - [ ] Dependencies are present in `pubspec.yaml`.
  - [ ] `flutter pub get` and `dart format --output=none .` exit 0 (evidence captured).

  **QA Scenarios**:
  ```
  Scenario: Bootstrap + dependency install
    Tool: Bash (PowerShell)
    Steps:
      1) mkdir .sisyphus/evidence (if missing)
      2) flutter doctor -v > .sisyphus/evidence/doctor.txt
      2) flutter create --org com.focusflow --platforms android,ios focusflow
      3) Get-ChildItem -Path "focusflow" -Force | Move-Item -Destination "." -Force
      4) Remove-Item -Recurse -Force "focusflow"
      5) flutter pub add flutter_svg go_router fl_chart google_fonts provider
      6) flutter pub get > .sisyphus/evidence/pub-get.txt
      7) dart format --output=none . > .sisyphus/evidence/format.txt
    Expected:
      - All commands succeed (exit code 0)
      - pubspec.yaml exists at repo root
    Evidence:
      - .sisyphus/evidence/doctor.txt
      - .sisyphus/evidence/pub-get.txt
      - .sisyphus/evidence/format.txt
  ```

  **Commit**: NO (repo not confirmed as git)

- [x] 2. Implement core theme + constants (AppColors/AppTypography/AppTheme/AppConstants)

  **What to do**:
  1. Create the 4 core files under `lib/core/...` exactly as listed.
  2. Ensure `AppTypography` uses `GoogleFonts.plusJakartaSans` with weights 400/500/600/700.
  3. Ensure `AppTheme.lightTheme` sets:
     - `scaffoldBackgroundColor = AppColors.background`
     - card/input/button shapes with radii (12/8/24)
  4. Put route path strings into `AppRoutes` constants (avoid scattering literal route strings elsewhere).
  5. Keep copy minimal in `AppCopy` (welcome title/subtitle only).

  **Must NOT do**:
  - Do not add dark theme, spacing tokens, or responsive breakpoints.

  **Recommended Agent Profile**:
  - Category: `quick` — Reason: small set of deterministic files.
  - Skills: []

  **Parallelization**: Can Parallel: YES | Wave 2 | Blocks: 7 | Blocked By: 1

  **Acceptance Criteria**:
  - [ ] 4 files exist with correct class names and constants.
  - [ ] `AppTheme.lightTheme` is referenced by `FocusFlowApp` (task 7).

  **QA Scenarios**:
  ```
  Scenario: Core files compile
    Tool: Bash
    Steps:
      1) flutter analyze
    Expected:
      - No analyzer errors
    Evidence:
      - .sisyphus/evidence/analyze.txt
  ```

  **Commit**: NO

- [x] 3. Create shared models (TaskItem, SmartItem)

  **What to do**:
  1. Add `lib/shared/models/task_item.dart` and `smart_item.dart` per signatures.
  2. Ensure `const` constructors and null-safety.
  3. Ensure imports are minimal (no Flutter import needed for models).

  **Recommended Agent Profile**:
  - Category: `quick`
  - Skills: []

  **Parallelization**: Can Parallel: YES | Wave 2 | Blocks: 4–6 | Blocked By: 1

  **Acceptance Criteria**:
  - [ ] Feature widgets that depend on these types can import them without additional stubs.

  **QA Scenarios**:
  ```
  Scenario: Model import sanity
    Tool: Bash
    Steps:
      1) flutter analyze
    Expected:
      - No analyzer errors related to missing types
    Evidence:
      - .sisyphus/evidence/analyze.txt
  ```

  **Commit**: NO

- [x] 4. Generate shared widgets stubs (Hamid)

  **What to do**:
  1. Create all files under `lib/shared/widgets/` listed above.
  2. Ensure they reference `AppColors` / `AppTypography` minimally (e.g., default text style).
  3. Keep implementation as placeholder only.

  **Recommended Agent Profile**:
  - Category: `unspecified-low`
  - Skills: []

  **Parallelization**: Can Parallel: YES | Wave 2 | Blocks: 7 | Blocked By: 1,2

  **Acceptance Criteria**:
  - [ ] All shared widget files compile and are importable.

  **QA Scenarios**:
  ```
  Scenario: Shared widgets compile
    Tool: Bash
    Steps:
      1) flutter analyze
    Expected:
      - No analyzer errors
    Evidence:
      - .sisyphus/evidence/analyze.txt
  ```

  **Commit**: NO

- [x] 5. Generate onboarding stubs (Louis)

  **What to do**:
  1. Create onboarding screens and widgets exactly as listed.
  2. Each screen should include:
     - Placeholder label Text
     - TODO comment describing the screen content from the user scenario.
  3. Widgets must declare params exactly as specified.
  4. `GoalSummaryCard` must import `SmartItem` from shared models.

  **Recommended Agent Profile**:
  - Category: `unspecified-low`
  - Skills: []

  **Parallelization**: Can Parallel: YES | Wave 2 | Blocks: 7 | Blocked By: 1,3

  **Acceptance Criteria**:
  - [ ] Router can navigate to all onboarding routes without missing imports (after task 7).

  **QA Scenarios**:
  ```
  Scenario: Onboarding stubs compile
    Tool: Bash
    Steps:
      1) flutter analyze
    Expected:
      - No analyzer errors
    Evidence:
      - .sisyphus/evidence/analyze.txt
  ```

  **Commit**: NO

- [x] 6. Generate home + tasks + analytics/priority stubs (Hamid/Raja/Octaf)

  **What to do**:
  1. Home (Hamid): create `HomeScreen` and 5 widget files listed.
  2. Tasks (Raja): create 3 screens + 6 widget files listed. Ensure `TaskDetailScreen({required this.taskId})`.
  3. Analytics/Priority (Octaf): create 2 screens + 7 widget files listed; chart/heatmap stay placeholder.
  4. Any widget requiring `TaskItem` must import from `lib/shared/models/task_item.dart`.

  **Recommended Agent Profile**:
  - Category: `unspecified-low`
  - Skills: []

  **Parallelization**: Can Parallel: YES | Wave 2 | Blocks: 7 | Blocked By: 1,3

  **Acceptance Criteria**:
  - [ ] All files compile; no missing type/import errors.

  **QA Scenarios**:
  ```
  Scenario: Feature stubs compile
    Tool: Bash
    Steps:
      1) flutter analyze
    Expected:
      - No analyzer errors
    Evidence:
      - .sisyphus/evidence/analyze.txt
  ```

  **Commit**: NO

- [x] 7. Wire app entry + router table + update tests + run QA gates

  **What to do**:
  1. Implement `lib/main.dart` and `lib/app.dart` so app starts with `FocusFlowApp`.
  2. Implement `AppRouter.router` with GoRoutes mapping every path to its screen.
     - Default initial location: `/welcome`.
  3. Ensure each route builder returns `const` screen where possible.
  4. Update default `test/widget_test.dart` created by Flutter template:
     - Replace references to template app with `FocusFlowApp`.
     - Assert at least one placeholder label exists (e.g., `WelcomeScreen`).
  5. Run and capture outputs to evidence:
     - `flutter analyze > .sisyphus/evidence/analyze.txt`
     - `flutter test > .sisyphus/evidence/test.txt`
     - Smoke build:
       - If Android toolchain present: `flutter build apk --debug > .sisyphus/evidence/build-apk.txt`
       - Otherwise (Decision Note): run the chosen alternative build and capture to `.sisyphus/evidence/build-alt.txt`

  **Must NOT do**:
  - Do not add provider state wiring beyond dependency presence (no global state architecture yet).

  **Recommended Agent Profile**:
  - Category: `unspecified-high` — Reason: integration touches multiple files + test update + QA run.
  - Skills: []

  **Parallelization**: Can Parallel: NO | Wave 3 | Blocks: none | Blocked By: 2–6

  **Acceptance Criteria**:
  - [ ] `flutter analyze` exits 0 (no errors).
  - [ ] `flutter test` exits 0.
  - [ ] Smoke build exits 0 (apk if possible; otherwise alternative per Decision Note).
  - [ ] Evidence files exist under `.sisyphus/evidence/`.

  **QA Scenarios**:
  ```
  Scenario: Full compile + test + build verification
    Tool: Bash (PowerShell)
    Steps:
      1) flutter analyze > .sisyphus/evidence/analyze.txt
      2) flutter test > .sisyphus/evidence/test.txt
      3) flutter build apk --debug > .sisyphus/evidence/build-apk.txt (if Android toolchain present)
         OR run alternative build > .sisyphus/evidence/build-alt.txt
    Expected:
      - analyze/test/build all succeed
    Evidence:
      - .sisyphus/evidence/analyze.txt
      - .sisyphus/evidence/test.txt
      - .sisyphus/evidence/build-apk.txt OR .sisyphus/evidence/build-alt.txt
  ```

  **Commit**: NO

## Final Verification Wave (MANDATORY — after ALL implementation tasks)
> Run these 4 reviews in PARALLEL. Present consolidated results and wait for user approval.
- [ ] F1. Plan Compliance Audit — oracle
- [ ] F2. Code Quality Review — unspecified-high
- [ ] F3. Real Manual QA — unspecified-high (launch app, tap through routes)
- [ ] F4. Scope Fidelity Check — deep

## Commit Strategy
- This workspace is not currently a git repo. If you want git history, do it explicitly later (`git init`) and then commit by feature.

## Success Criteria
- All files exist and compile.
- Router provides navigable skeleton for all screens.
- QA gates pass and evidence is captured.
- No real UI/logic beyond placeholders.

**Authoritative Route List (must be implemented verbatim)**
- `AppRoutes.welcome = '/welcome'`
- `AppRoutes.onboardingSpecific = '/onboarding/specific'`
- `AppRoutes.onboardingMeasurable = '/onboarding/measurable'`
- `AppRoutes.onboardingAchievable = '/onboarding/achievable'`
- `AppRoutes.onboardingRelevant = '/onboarding/relevant'`
- `AppRoutes.onboardingTimebound = '/onboarding/timebound'`
- `AppRoutes.goalSummary = '/goal-summary'`
- `AppRoutes.home = '/home'`
- `AppRoutes.tasks = '/tasks'`
- `AppRoutes.createTask = '/tasks/create'`
- `AppRoutes.taskDetail = '/tasks/:id'`
- `AppRoutes.priority = '/priority'`
- `AppRoutes.analytics = '/analytics'`
