# Garage App — Memory for agents

## Project structure
- `lib/` — Flutter app (imports `backend` + `ui`)
- `packages/backend/` — pure Dart lib (models, repository, sqlite, formatting, i10n data). Zero Flutter imports.
- `packages/ui/` — Flutter widgets, themes, helpers. Zero state management. Data via constructor params.
- `test/` — Flutter tests (widget + model)
- `packages/backend/test/` — pure Dart tests
- `packages/ui/test/` — ui package tests

## Architecture
- **State management**: `Provider` + `ChangeNotifier` for business logic. `GarageHome` (nav shell in `main.dart`) is a `StatelessWidget` using `context.watch<NavigationNotifier>()` for reactive nav stack. All other widgets are stateless.
- **Persistence**:
  - Car/work data: SQLite via `backend` (`sqlite3` package, ^3.0.0). Only `backend` imports `sqlite3`.
  - Settings: `shared_preferences` directly in `garage_app`.
- **Repository pattern**: `CarRepository` abstract interface in `backend`. `SqliteCarRepository` implements it.
  - Production: `SqliteCarRepository(String path)` — opens DB via file path.
  - Tests: `SqliteCarRepository.inMemory(Database db)` — accepts pre-opened in-memory DB.
- **Settings**: `SettingsPersistence` interface in `backend`, `SharedPrefsPersistence` impl in `garage_app` (needs Flutter plugin).
- **DI**: Manual — `Provider<CarRepository>.value` + `ChangeNotifierProvider` in `main()`. No DI framework.
- **L10n**: `L10n` abstract class in `backend`. `AppL10nAdapter` in app layer wraps generated `AppLocalizations`. Provided via `Provider<L10n>` at `MaterialApp.builder`. `L10nX` extension in `ui` package. UI widgets use `context.l10n`, no `l10n` param.

## Layer rules
- `backend` (pure Dart): models, repository interface & impl, formatting, i10n data. May NOT import Flutter.
- `ui` (Flutter): widgets, themes, helpers, `L10nX` extension. All widgets stateless. Data via constructor params. Use `context.l10n`. May NOT import app layer.
- `app` (lib/): orchestrates backend + ui. Providers, screens, main.dart. Imports `package:backend/backend.dart`, `package:ui/ui.dart`.

## Key files
- `lib/main.dart` — `GarageApp` + `GarageHome` (providers setup, nav using `GarageNavigator`)
- `lib/screens/screens.dart` — barrel + `Screen` enum
- `lib/providers/` — `SettingsNotifier`, `NavigationNotifier`, `CarListNotifier`, `CarDetailNotifier`
- `packages/ui/lib/src/l10n.dart` — `L10nX` extension on `BuildContext`
- `lib/storage.dart` — `SharedPrefsPersistence` (implements `SettingsPersistence`)
- `lib/screens/home_screen.dart` — `HomeScreen` widget
- `lib/screens/detail_screen.dart` — `DetailScreen` + `buildInfoBar()`
- `lib/screens/settings_screen.dart` — `SettingsScreen` + donate section helpers
- `lib/screens/dialogs/` — dialog functions (car_form, work_form, monthly, breakdown, oil_history, settings_modal)
- `lib/providers/` — `SettingsNotifier`, `CarListNotifier`, `CarDetailNotifier`
- `packages/backend/lib/src/models.dart` — `Car`, `WorkRecord` (freezed)
- `packages/backend/lib/src/settings.dart` — `AppSettings` (freezed)
- `packages/backend/lib/src/data.dart` — sample cars, `categories` map, `presetColors`
- `packages/backend/lib/src/repository.dart` — `CarRepository` interface
- `packages/backend/lib/src/sqlite_repository.dart` — `SqliteCarRepository`
- `packages/backend/lib/src/formatting.dart` — currency/distance/compact format, `formatNum()`, `formatCurrency()`
- `packages/backend/lib/src/labels.dart` — `catLabel()`, `monthName()`, `formatDistance()`, `SettingsOption`, `MonthlyEntry`, `todayDateString()`, `formatMonth()`
- `packages/backend/lib/src/aggregation.dart` — in-memory stats helpers
- `packages/backend/lib/src/settings_persistence.dart` — `SettingsPersistence` interface
- `packages/ui/lib/src/tablet.dart` — `TabletContextX` extension (`context.isTablet`)
- `packages/ui/lib/src/snackbar.dart` — `showStyledSnackbar()` helper
- `packages/ui/lib/src/theme/app_colors.dart` — `AppColors` constants
- `packages/ui/lib/src/theme/theme_colors_x.dart` — color extensions, `parseHex()`
- `packages/ui/lib/src/theme/themes.dart` — `AppTheme` light/dark
- `packages/ui/lib/src/widgets/` — `CarCard`, `WorkItem`, `StatCard`, `OilLifeCard`, `SettingsItem`, `DonateCard`, `SummaryCard`, `MiniProgressBar`, `AddButton`, `CardWrapper`, `ColorDot` etc.
- `packages/ui/lib/src/forms.dart` — `FormLabel`, `formField`, `formBtn`, `formActionRow`, etc.
- `packages/ui/lib/src/dialogs.dart` — `showConfirmDelete`, `buildInfoDialogBody`, `showAppBottomSheet`
- `packages/ui/lib/src/stat_label.dart` — `statLabelColumn`

## Workflow
- After every code change, run `format.sh` to format all Dart files.
- Run `flutter analyze` after every change.

## Conventions
- `sqlite3` v3.3.1 API: `sqlite3.open(path)` → `Database`, `db.execute(sql)` → void, `db.select(sql)` → `ResultSet` (List<Row>), `db.lastInsertRowId` → int, `db.close()` to close.
- All aggregate stats (total/avg/category/monthly) computed via SQL aggregate queries (SUM, AVG, GROUP BY) in `SqliteCarRepository`. `Car` model also has in-memory computed convenience properties (`totalSpent`, `lastService`, `avgSpent`, `categoryTotals`, `topCategory`) used by UI widgets.
- `_cars` list from `loadCars()` may be unmodifiable. Always create new list on mutation:
  - Add: `_cars = [..._cars, saved]`
  - Update: `_cars = _cars.toList()..[idx] = updated`
  - Remove: `_cars = _cars.where((c) => c.id != id).toList()`
- Async ops in dialogs use `async void` + `if (mounted) setState(...)`.
- `Navigator.pop(ctx)` before `await` to close dialog eagerly.
- Mock `CarRepository` in widget tests returns `List.unmodifiable(_cars)`.
- `sqlite3` is transitive dep of `garage_app` (via `backend`). Never add as direct dep.
- `context.l10n` via `L10nX` extension (import `package:ui/ui.dart` or `package:backend/backend.dart`).
- **Layer rules for imports**: `backend` has zero Flutter imports. App-layer files import `package:ui/ui.dart` for widgets (includes `L10nX` extension) and `package:backend/backend.dart` for models/data/labels/stats.

## Coding conventions
- `build()` methods: max ~80 lines.
- **Nesting depth rule**: Max 4 bracket levels from function body margin (2-space indent per level). The deepest `)`, `]`, `}` must indent ≤ 8 spaces from the function body's first statement.
  - Every `(`, `[`, `{` = one level deeper. Every `)`, `]`, `}` reduces count by one.
  - Rule applies to all braces: constructor args, list literals, function bodies, closures.
  - `onTap: () => foo(bar)` → the lambda `() =>` adds one level; the callback body adds another.
- **Universal flattening strategies** (apply to any language, any widget tree):
  1. **Extract callback closures**: Any inline closure > 1 line → extract to local function and pass as tear-off.
  2. **Extract intermediate subtrees**: Deeply chained `Widget(child: Widget(child: Widget(...)))` → extract inner 2-3 nodes to a local variable, then return a shallow wrapper.
  3. **Ternary branches**: `isTablet ? DeepWidget(...) : OtherDeepWidget(...)` → extract each branch to a local variable.
  4. **Lambda chains**: `() => foo((x) => bar(x))` → extract the inner action to a named function, flatten to `() => namedFn(x)`.
  5. **Config objects**: `Container(decoration: BoxDecoration(...))` → extract `BoxDecoration deco = ...` local var, pass as `decoration: deco`.
  6. **Deep list builders**: `children: list.map((x) { return Padding(Text(...)); }).toList()` → extract the map callback to a local function, use tear-off.
  7. **Return structure**: If `return Foo(...)` contains >4 levels, extract the deep path to a local var, return a shallow `Foo(child: localVar)`.
- Extraction priority: local var → private method → separate file (if reusable across 2+ sites).
- Prefer `const` constructors on widgets (enforced by lint).
- Max line length: 100 chars (enforced by `format.sh --line-length 100`).
- `children: [...]` lists > 6 items → extract to helper or local variable.
- Repetitive widget patterns (3+ instances) → extract to shared helper.
- **Common flattening patterns** (applied across all screens/dialogs):
  - `Consumer<T>(builder: ...)` → extract `final app = Consumer<T>(builder: ...)` local var, pass as `child: app`.
  - `onTap: () => showDialog(ctx, ..., (result) => ...)` → extract `void handleAction() { showDialog(...); }` local function, pass as `onTap: handleAction`.
  - `GestureDetector(child: Container(decoration: BoxDecoration(...)))` → extract `BoxDecoration deco` and `Widget? trailing` locals to flatten Container + children.
  - `List.generate(n, (i) { return Padding(child: Row(children: [...])); })` → extract the builder to a local function, use tear-off `List.generate(n, buildRow)`.
- All app-layer files enforced: main.dart, home_screen, detail_screen, settings_screen, all 6 dialogs.

## Rename discipline
When renaming any class/type, grep the full concept (not just the type name) and batch all changes in one pass:
- Source files (class name, constructor, file name, export)
- Dependent files (imports, usages)
- Variables, params, fields named after the concept
- Mocks and test helpers
- Analyze + test in one command before declaring done

## Test commands
- `sh format.sh` — format all Dart files (always run this after code changes)
- `sh tests.sh` — run all test suites (backend + Flutter + ui)
- `sh analyze.sh` — analyze all packages (backend + ui + app)
- Report all analyze issues (warnings, infos, errors) to user — don't hide or auto-fix without asking
