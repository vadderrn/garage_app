# Garage App — Test Cases

## 1. Home Screen (GarageHome)

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 1.1 | Render car cards | Launch app | See 3 car cards (BMW, Toyota, Mercedes) with make, model, year, plate, mileage, total spent |
| 1.2 | Add Car button visible | Scroll to bottom | See "+ Add New Car" button with dashed border |
| 1.3 | Settings gear visible | Look at AppBar | Gear icon (⚙️) in top-right |
| 1.4 | AppBar title | — | Shows "🚗 Garage" |

## 2. Add Car Dialog

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 2.1 | Open add car dialog | Tap "+ Add New Car" | Bottom sheet opens with fields: Make, Model, Year, Plate, Price, Mileage, Color picker |
| 2.2 | Inline validation — empty make | Tap Save with empty fields | Red border + error "Make is required" on Make field |
| 2.3 | Inline validation — empty model | Fill Make, tap Save with empty Model | Error "Model is required" on Model field |
| 2.4 | Inline validation — invalid year | Enter "abc" for Year, tap Save | Error "Enter a valid year (1900-2099)" on Year field |
| 2.5 | Inline validation — invalid price | Enter non-numeric Price, tap Save | Error "Enter a valid price" on Price field |
| 2.6 | Inline validation — invalid mileage | Enter non-numeric Mileage, tap Save | Error "Enter a valid mileage" on Mileage field |
| 2.7 | Errors clear on type | Trigger error on Make, then type in Make | Red border and error disappear |
| 2.8 | Save valid car | Fill all fields validly, tap Save | Dialog closes, new car card appears on home screen |
| 2.9 | Cancel | Tap Cancel button | Dialog closes, no car added |
| 2.10 | Color picker works | Open dialog, tap a different color circle | Color selection changes, previously selected circle updates border |

## 3. Edit Car Dialog

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 3.1 | Open edit car | Tap a car card → tap ✏️ in AppBar | Dialog opens with pre-filled data from that car |
| 3.2 | Edit and save | Change make, tap Save | Dialog closes, car card updated on home |
| 3.3 | Delete car | Tap 🗑️ in dialog → confirm | Car removed from home screen, cars reindex |
| 3.4 | Cancel edit | Open dialog, tap Cancel | No changes applied |

## 4. Detail Screen — Navigation

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 4.1 | Open car detail | Tap any car card | Navigate to detail screen with back arrow ← in AppBar |
| 4.2 | Back via button | Tap ← arrow | Return to home screen |
| 4.3 | Back via system gesture | Swipe from left edge (or press back button) | Return to home screen (not close app) |
| 4.4 | Back at home closes app | On home screen, press back/system gesture | App closes (canPop = true) |

## 5. Detail Screen — Stats Cards

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 5.1 | Total Spent card | Open detail | Shows formatted total of all work costs |
| 5.2 | Avg/Service card | Open detail | Shows total spent / work count |
| 5.3 | Last Service card | Open detail | Shows date of most recent work record |
| 5.4 | Top Category card | Open detail | Shows category icon + name with highest total spend |
| 5.5 | Tap Total Spent → Monthly dialog | Tap Total Spent card | Opens Monthly Spending bottom sheet (4 months) |
| 5.6 | Tap Top Category → Breakdown dialog | Tap Top Category card | Opens Spending by Category bottom sheet |
| 5.7 | Oil Life card visible | Open detail | Shows oil life %, distance since change, max |

## 6. Monthly Spending Dialog

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 6.1 | Open monthly dialog | Tap Total Spent card | Shows 4 months with name, amount, work count, bar chart |
| 6.2 | Change indicator | Check bottom summary | Shows ↑/↓/→ with % change vs previous month |
| 6.3 | No pixel overflow | Open on narrow screen | No yellow/black overflow stripes — month name truncates with ellipsis |
| 6.4 | Close dialog | Tap Close button | Dialog dismisses |

## 7. Category Breakdown Dialog

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 7.1 | Open breakdown dialog | Tap Top Category card | Shows categories sorted by spend, each with icon, name, bar, amount, % |
| 7.2 | Total at bottom | Scroll to bottom | Shows total formatted amount |
| 7.3 | Close dialog | Tap Close button | Dialog dismisses |

## 8. Add Work Record Dialog

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 8.1 | Open add work | On detail screen, tap "+ Add Work Record" | Bottom sheet opens with Description, Date, Cost, Category picker |
| 8.2 | Date is pre-filled | Open dialog | Date field shows today's date in YYYY-MM-DD format |
| 8.3 | Date picker popup | Tap date field | Native calendar date picker opens |
| 8.4 | Date picker styling | Open date picker | Header matches dialog bg (not green), OK/Cancel buttons styled like app buttons, dialog has 16px border radius |
| 8.5 | Select date in picker | Pick a date, tap OK | Date field updates to selected YYYY-MM-DD |
| 8.6 | Inline validation — empty desc | Tap Save with empty Description | Error "Description is required" on Desc field |
| 8.7 | Inline validation — empty date | Clear date, tap Save | Error "Date is required" on Date field |
| 8.8 | Inline validation — invalid cost | Enter "0" or negative, tap Save | Error "Enter a valid cost greater than 0" on Cost field |
| 8.9 | Category selector works | Tap a different category icon | Category highlight changes |
| 8.10 | Save valid work | Fill all fields, tap Save | Dialog closes, new work record appears at top of service history list |
| 8.11 | Cost updates stats | Save work with cost X | Total Spent increases by X, Avg/Service recalculates |
| 8.12 | Date / Cost ratio | Check layout | Date field takes ~60% width, Cost ~40% |

## 9. Edit / Delete Work Record

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 9.1 | Open edit work | Tap any work record in service history | Dialog opens with pre-filled data |
| 9.2 | Edit and save | Change description, tap Save | Work record updated in list |
| 9.3 | Delete work | Tap 🗑️ → confirm | Work record removed, stats recalculate |
| 9.4 | Cancel edit | Open dialog, tap Cancel | No changes |

## 10. Oil Change History Dialog

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 10.1 | Open oil history | Tap Oil Life card | Bottom sheet shows oil %, distance, max, and filtered work records containing "oil" |
| 10.2 | Empty state | If no oil records exist | Shows "No oil change records yet" |
| 10.3 | Status indicator | Check color | Green (>50%), Yellow (20-50%), Red (<20%) |

## 11. Settings

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 11.1 | Open settings | Tap ⚙️ gear icon | Settings screen with Language, Distance Unit, Currency, Theme |
| 11.2 | Switch language to Russian | Tap Language → select Русский | All UI text changes to Russian immediately |
| 11.3 | Switch language back to English | Tap Language → select English | All UI text changes back to English |
| 11.4 | Switch distance unit to mi | Tap Distance → select mi | Mileage displays in miles with "mi" suffix |
| 11.5 | Switch currency to RUB | Tap Currency → select RUB | Costs display with ₽ symbol and converted amounts |
| 11.6 | Switch currency to EUR | Tap Currency → select EUR | Costs display with € symbol and converted amounts |
| 11.7 | Switch theme to Light | Tap Theme → select Light | UI switches to light color scheme |
| 11.8 | Switch theme to Dark | Tap Theme → select Dark | UI switches to dark color scheme |
| 11.9 | Switch theme to System | Tap Theme → select System | UI follows device theme |
| 11.10 | Settings persist after restart | Change language, restart app | Setting persists |

## 12. Donate Section

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 12.1 | Donate cards visible | Scroll to bottom of settings | Shows Coffee ($3), Pizza ($5, featured), Beer ($10) cards |
| 12.2 | Custom amount field | Enter a number in text field | Field accepts numeric input |
| 12.3 | Tap donate card | Tap Coffee | SnackBar "Thanks for the Coffee!" appears |
| 12.4 | Custom donate | Enter amount, tap Donate | SnackBar "Thanks for the Custom amount!" appears |

## 13. Data Integrity

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 13.1 | Work count increments correctly | Add work → check _nextWorkId | New work gets unique sequential ID |
| 13.2 | Car count increments correctly | Add car → check _nextCarId | New car gets unique sequential ID |
| 13.3 | Monthly stats recalculate after add | Add work with cost X, open monthly dialog | Current month total includes X |
| 13.4 | Monthly stats recalculate after delete | Delete a work record, open monthly dialog | Current month total decreases |
| 13.5 | Category totals correct | Add work with category "fuel" | Fuel category total increases in breakdown dialog |
| 13.6 | Total spent matches sum | Sum all work costs manually | Total Spent stat card matches |

## 14. Edge Cases

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 14.1 | Empty description | Tap Save with no description | Dialog stays open, shows validation error (no crash) |
| 14.2 | Invalid date in existing data | Set date to "ddhh" (manually) | `DateTime.tryParse` returns null, record skipped in stats (no crash) |
| 14.3 | Rapid consecutive adds | Add 5 work records quickly | All saved, list shows all 5 |
| 14.4 | Delete last car | Delete all 3 cars, check state | Home shows no cars, add button still works |
| 14.5 | Very long description | Enter 500-char description | Text wraps/ellipsis, no overflow |
| 14.6 | Zero cost work | Enter cost "0", tap Save | Validation rejects, shows error |
| 14.7 | Negative cost | Enter "-100", tap Save | Validation rejects, shows error |
| 14.8 | Future year in car | Enter year "2050", tap Save | Validation rejects (max 2099 is ok, 2050 should pass) |
| 14.9 | Year below 1900 | Enter "1800", tap Save | Validation rejects, shows error |
| 14.10 | Empty car list edge case | Delete all cars, navigate to detail (should not be possible) | No crash (guarded by null checks) |

## 15. Localization — String Coverage

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 15.1 | Month names EN | Set language English | All 12 months display correctly in English |
| 15.2 | Month names RU | Set language Russian | All 12 months display correctly in Russian |
| 15.3 | Validation strings EN | Trigger validation in English | Error messages in English |
| 15.4 | Validation strings RU | Switch to Russian, trigger validation | Error messages in Russian |
| 15.5 | Category names EN | English locale | All 10 categories show English labels |
| 15.6 | Category names RU | Russian locale | All 10 categories show Russian labels |

## 16. Theme — Visual Regression

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 16.1 | Dark theme colors | Dark mode | bgPrimary #1a1a1a, cardBg #252525, textPrimary white, cardBorder #333333 |
| 16.2 | Light theme colors | Light mode | bgPrimary #f5f5f5, cardBg white, textPrimary #1a1a1a, cardBorder #dddddd |
| 16.3 | Accent color consistent | Both themes | accent = #30d158 throughout |
| 16.4 | Expense color consistent | Both themes | expense = #ff6b6b throughout |

## 17. Detail Screen — Info Bar & Service History

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 17.1 | Info bar shows plate | Open detail | Plate number displayed in a pill/badge |
| 17.2 | Info bar shows mileage | Open detail | Formatted distance shown next to plate |
| 17.3 | Info bar shows price | Open detail | Formatted car price on right side in accent color |
| 17.4 | Service history header | Open detail | Shows "Service History (N)" with work count |
| 17.5 | Work records displayed | Open detail | All work records listed in reverse chronological order (newest first) |
| 17.6 | Each work shows fields | Open detail | Each work item shows: description, date, formatted cost, category |
| 17.7 | Add Work button | Scroll to bottom of detail | "+ Add Work Record" button visible |
| 17.8 | Multiple works scrollable | Open detail with 8+ records | Entire detail screen scrolls (SingleChildScrollView + ListView) |

## 18. Responsive Design — Tablet Layout

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 18.1 | Tablet home — 2-column grid | Set width ≥ 600px | Car cards displayed in 2-column Wrap layout |
| 18.2 | Tablet home — wider padding | Set width ≥ 600px | Horizontal padding increases to 24px |
| 18.3 | Tablet detail — 4 stat cards in row | Set width ≥ 600px | Total Spent, Avg/Service, Last Service, Top Category in single Row |
| 18.4 | Tablet detail — wider padding | Set width ≥ 600px | Detail content padding = 24px |
| 18.5 | Tablet settings — centered column max 600px | Set width ≥ 600px | Settings items in centered SizedBox(width: 600) with 2-column grid |
| 18.6 | Tablet settings — 2-column preferences | Set width ≥ 600px | Language next to Distance Unit, Currency next to Theme |
| 18.7 | Tablet donate section — 420px centered | Set width ≥ 600px | Donate cards and custom amount in centered 420px wide container |
| 18.8 | Phone home — single column list | Width < 600px | Car cards in ListView, one per row, 16px padding |
| 18.9 | Phone detail — stat cards in 2x2 grid | Width < 600px | First row: Total Spent + Avg/Service, Second row: Last Service + Top Category |
| 18.10 | Phone detail — 20px padding | Width < 600px | Detail content padding = 20px |
| 18.11 | Work history — single column on phone | Width < 600px | Each work record full width, one per row |
| 18.12 | Work history — 2-column tablet | Width ≥ 600px | Work records paired 2 per row |

## 19. Navigation Stack Integrity

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 19.1 | Nav stack starts at home | App launch | `_navStack` is `[Screen.home]`, `_currentScreen` is `Screen.home` |
| 19.2 | Navigate to detail | Tap car card | `_navStack` becomes `[Screen.home, Screen.detail]` |
| 19.3 | Navigate to settings | Tap gear icon | `_navStack` becomes `[Screen.home, Screen.settings]` |
| 19.4 | Back from settings to home | Tap ← in settings | `_navStack` back to `[Screen.home]` |
| 19.5 | Back from detail to home | Tap ← in detail | `_navStack` back to `[Screen.home]` |
| 19.6 | Deep stack: home→detail→settings | Navigate detail, then use gear (not possible — no gear in detail) | Settings only accessible from home |
| 19.7 | Back multiple levels | Navigate home→detail→(impossible to go deeper in stack) | `_goBack()` only pops one level |
| 19.8 | Prevent nav stack underflow | Call `_goBack()` when at home | No-op, `_navStack` stays `[Screen.home]` |

## 20. Data Consistency

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 20.1 | Add work updates car stats | Add work with cost 500 | totalSpent increases by 500, avgSpent recalculated, lastService updates to new date |
| 20.2 | Delete work updates car stats | Delete a work record | totalSpent decreases, avgSpent recalculated |
| 20.3 | Edit work cost updates stats | Change work cost from 100 to 200 | totalSpent changes by +100 |
| 20.4 | Edit work date changes monthly stats | Move work to different month | Monthly spending for old month decreases, new month increases |
| 20.5 | Category totals update after edit | Change work category from 'fuel' to 'maintenance' | Fuel category total decreases, maintenance increases |
| 20.6 | Oil life unaffected by work CRUD | Edit/add/delete work (not oil-related) | oilLife, oilKm, oilMax remain unchanged |
| 20.7 | Top category recalculates | Add work with huge cost in new category | Top Category stat card updates |
| 20.8 | Monthly change % correct | Compare current vs previous month spend | Change = ((curr - prev) / prev * 100).round() |
| 20.9 | Monthly change — no prev data | First month has data, prev month has 0 | Change = 100% (increase) |
| 20.10 | Monthly change — identical months | Both months have same spend | Change = 0%, shows "No change" |

## 21. Work Record Ordering

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 21.1 | Newest work appears first | Add work with past date | Record appears at top of list (new records always prepend) |
| 21.2 | Reverse chronological order | Check sample data | BMW works: Oil change (Apr 12) → Tires (Apr 2) → Inspection (Mar 10) → Brakes (Feb 15)→... |
| 21.3 | Tablet reverse order | Tablet view, check work pairs | Works displayed in reverse order, paired left-to-right |

## 22. Color Picker — Car Dialog

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 22.1 | 11 preset colors available | Open add/edit car | Colors: Black, White, Gray, Red, Blue, Green, Yellow, Orange, Brown, Purple, Pink |
| 22.2 | Color circles display correctly | Open dialog | Each circle shows the actual color, 32x32px, circular shape |
| 22.3 | Selected color has accent border | Tap a color | Selected color shows green accent border (2px) and shadow |
| 22.4 | White/yellow colors visible on light bg | Select White or Yellow | Border uses #555555 instead of transparent |
| 22.5 | Default selected is Blue | Open add car dialog | First selected color is Blue (#1e3a8a) |
| 22.6 | Color persists after close/reopen | Select Red, close, reopen edit car | Red is selected |

## 23. Oil Life Card — Visual States

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 23.1 | Oil life "Good" state (≥ 51%) | Car with oilLife 65 | Green (#30d158) progress/percentage |
| 23.2 | Oil life "Due Soon" state (21-50%) | Car with oilLife 40 | Yellow/orange (#ff9f0a) progress/percentage |
| 23.3 | Oil life "Overdue" state (≤ 20%) | Car with oilLife 18 | Red (#ff453a) progress/percentage |
| 23.4 | Oil distance display | Open detail for BMW | Shows "4,500 km since change / 10,000 km max" |
| 23.5 | Oil life card tap opens history | Tap oil life card | Opens Oil Change History bottom sheet |
| 23.6 | Oil history filters correctly | Check Mercedes (0 oil works) | Shows "No oil change records yet" |
| 23.7 | Oil history counts correctly | Check BMW (1 oil work: "Oil change & filter") | Shows "1 work record" |

## 24. AppBar Per Screen

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 24.1 | Home AppBar: title "Garage" + gear | Home screen | Title "🚗 Garage", gear icon on right, no back button |
| 24.2 | Detail AppBar: car name + back + edit | Detail screen | Title "{make} {model} {year}" with color dot, ← back button, ✏️ edit button on right |
| 24.3 | Settings AppBar: title "Settings" + back | Settings screen | Title "⚙️ Settings", ← back button, no actions |
| 24.4 | Back button width | Detail/settings screen | Back button area is 56px wide |
| 24.5 | Title spacing | All screens | Title spacing = 20px |
| 24.6 | Title overflow handling | Very long car name | Title text uses TextOverflow.ellipsis |

## 25. Input Formatting

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 25.1 | Number formatting — thousands | Input 1000000 as mileage | Formatted as "1,000,000" in display (formatNum extension) |
| 25.2 | Number formatting — compact K | Input 1500 as cost | Displayed as "1.5K" (formatCompact extension) |
| 25.3 | Number formatting — compact M | Input 2000000 as cost | Displayed as "2M" (formatCompact extension) |
| 25.4 | Number formatting — under 1000 | Input 999 as cost | Displayed as "999" (no formatting applied) |
| 25.5 | Distance formatting — km | distanceUnit = km, mileage = 1500 | Displayed as "1,500 km" |
| 25.6 | Distance formatting — mi | distanceUnit = mi, mileage = 1609 | Displayed as "1,000 mi" (1609/1.609 = 1000) |
| 25.7 | Currency format — USD | currency = usd, cost = 1500 | Displayed as "$1.5K" |
| 25.8 | Currency format — RUB | currency = rub, cost = 100 | Displayed as "₽9K" (100 × 90 = 9000) |
| 25.9 | Currency format — EUR | currency = eur, cost = 100 | Displayed as "€92" (100 × 0.92 = 92) |

## 26. Accessibility

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 26.1 | Contrast — dark mode text | Dark theme | textPrimary white on bgPrimary #1a1a1a — contrast > 4.5:1 |
| 26.2 | Contrast — light mode text | Light theme | textPrimary #1a1a1a on bgPrimary #f5f5f5 — contrast > 4.5:1 |
| 26.3 | Touch target size — buttons | Check all buttons (formBtn) | Minimum 48px tap target |
| 26.4 | Touch target — color circles | Check color picker circles | 32px with padding, touchable |
| 26.5 | Touch target — work items | Tap work record | Entire card is tappable |
| 26.6 | Touch target — stat cards | Tap Total Spent / Top Category | Entire card is tappable |

## 27. Keyboard & Input Behavior

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 27.1 | Keyboard pushes dialog up | Tap any text field in bottom sheet | Dialog moves up above keyboard (via viewInsets) |
| 27.2 | Number keyboard for price/cost/mileage | Focus price field | Number keyboard appears |
| 27.3 | Regular keyboard for make/model/desc | Focus make field | Alphanumeric keyboard appears |
| 27.4 | Date field not editable by keyboard | Tap date field | Date picker opens, keyboard does not appear (AbsorbPointer) |
| 27.5 | Cancel keyboard on date picker | Tap date field | Date picker opens, soft keyboard dismissed |
| 27.6 | Dismiss keyboard on Save | Tap Save with valid data | Keyboard dismissed, dialog closes |

## 28. Widget Rendering

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 28.1 | CarCard — shows all fields | View BMW card | Shows: color dot, Make Model Year, Plate, Mileage, Total Spent (formatted) |
| 28.2 | CarCard — tappable | Tap card | Navigates to detail for that car |
| 28.3 | WorkItem — shows all fields | View any work record | Shows: description, date, formatted cost with icon+currency |
| 28.4 | WorkItem — tappable | Tap work record | Opens Edit Work dialog |
| 28.5 | StatCard — shows label and value | View any stat | Shows header label, main value, optional subtitle |
| 28.6 | StatCard — optional tap | Stat with onTap | Stat highlights on tap (InkWell ripple) |
| 28.7 | OilLifeCard — gradient bar | View oil card | Shows oil life % with gradient colored bar (green→yellow→red) |
| 28.8 | SettingsItem — icon + title + value | View settings list | Shows emoji icon, setting name, current value on right, tap opens modal |
| 28.9 | DonateCard — featured style | View Pizza ($5) card | Card has accent border/background (featured: true), others are normal |
| 28.10 | DonateMethod — GitHub icon | Scroll donate section | Shows GitHub icon with label, tappable |
| 28.11 | Empty state — no cars | Delete all cars | Shows "No cars yet" message |

## 29. Form Button States

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 29.1 | Save button — accent green bg, white text | Any dialog save | Background accent (#30d158), text white, font 16/700, 12px radius |
| 29.2 | Cancel button — outlined style | Any dialog cancel | Transparent bg, cardBorder, textPrimary, 16/700, 12px radius |
| 29.3 | Delete button — danger style | Edit car/work dialog | Red border, red text, compact padding |
| 29.4 | Close button — outlined style | Monthly/Breakdown/Oil dialogs | Same as Cancel — outlined style |
| 29.5 | Button full-width | Add car dialog, Save/Cancel | Each button takes 50% of row (Expanded) |
| 29.6 | Button with delete icon | Edit work dialog | 🗑️ icon only, compact, to left of Cancel |

## 30. Dialog Bottom Sheets — Style Consistency

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 30.1 | All sheets use modalBg | Open each dialog type | Background matches `AppColors.modalBg` (dark: #1c1c1e, light: #f0f0f0) |
| 30.2 | All sheets have 20px top radius | Open any bottom sheet | Shape: RoundedRectangleBorder with 20px top radius |
| 30.3 | Add/Edit Car sheet — useSafeArea: true | Open on notch device | Content respects safe area |
| 30.4 | Add/Edit Work sheet — useSafeArea: true | Open on notch device | Content respects safe area |
| 30.5 | Monthly dialog — no useSafeArea | Open monthly dialog | Content may extend under system bars |
| 30.6 | All scrollable sheets scroll | Open with many items | SingleChildScrollView allows scrolling |

## 31. Data Persistence via SharedPreferences

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 31.1 | Language persists | Switch to Russian, hot restart | Language stays Russian |
| 31.2 | Distance unit persists | Switch to mi, hot restart | Distance unit stays mi |
| 31.3 | Currency persists | Switch to EUR, hot restart | Currency stays EUR |
| 31.4 | Theme UI setting persists | Switch to Light, hot restart | Theme stays Light |
| 31.5 | Theme mode setting persists | Switch to System, hot restart | Theme mode stays System |
| 31.6 | No data loss on cold restart | Kill and relaunch app | All SharedPreferences values retained |
| 31.7 | Cars not persisted | Add car, restart | Cars reset to sampleCars (in-memory state) |

## 32. Edge — Date Handling

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 32.1 | Date picker initial = today | Open add work dialog | Date pre-filled with today's date in ISO format (YYYY-MM-DD) |
| 32.2 | Date picker initial = existing date | Open edit work dialog | Date pre-filled with work's existing date |
| 32.3 | Date picker year range | Open date picker | Min year: 2000, Max year: 2100 |
| 32.4 | Leap year date | Pick Feb 29, 2024 | Date shown as 2024-02-29, saves correctly |
| 32.5 | Month boundary | Pick Jan 31 → Feb → no 31st | Date picker handles month rollover gracefully |
| 32.6 | Date format consistency | Add work, check saved value | Stored as YYYY-MM-DD throughout |

## 33. Edge — Work Record with Empty Cars

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 33.1 | Detail without _selectedCar | Set _selectedCarId = null | `_buildDetailScreen` returns empty SizedBox (no crash) |
| 33.2 | Add work with null car | Set _selectedCar = null (impossible via UI) | `_showAddWorkDialog` returns early (no crash) |
| 33.3 | Edit work with null car | Set _selectedCar = null (impossible) | `_showEditWorkDialog` returns early (no crash) |
| 33.4 | Work on deleted car's detail | Delete car from detail screen | Exits to home (handled by setState) |

## 34. Donate Section — Layout

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 34.1 | Heart icon at top | Settings → scroll to donate | ❤️ emoji centered, 28px |
| 34.2 | Title + subtitle | View donate section | "Support Development" + "Help us keep the app free and ad-free" |
| 34.3 | Three donate cards in row | Phone view | Coffee ($3), Pizza ($5, featured), Beer ($10) in Row |
| 34.4 | Custom amount + Donate button | View custom area | Number TextField + "Donate" accent button |
| 34.5 | GitHub link section | Very bottom of settings | GitHub icon with label, centered |

## 35. Settings Modal Options

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 35.1 | Language options | Tap Language | Options: English, Русский |
| 35.2 | Distance unit options | Tap Distance Unit | Options: km, mi |
| 35.3 | Currency options | Tap Currency | Options: USD, RUB, EUR |
| 35.4 | Theme options | Tap Theme | Options: Dark, Light, System |
| 35.5 | Selected item shows checkmark | Open any settings modal | Selected option has accent bg, white text, ✓ icon |
| 35.6 | All modals have Cancel button | Open any settings modal | Cancel button at bottom closes without changes |

## 36. Performance

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 36.1 | Smooth scrolling — home | Scroll through 20+ cars | No jank, 60fps |
| 36.2 | Smooth scrolling — detail | Scroll long service history | No jank while rendering work items |
| 36.3 | Dialog opens smoothly | Tap any button that opens dialog | Dialog animates in at 60fps |
| 36.4 | Date picker opens responsively | Tap date field | Calendar appears within 500ms |
| 36.5 | Theme switch instant | Toggle dark↔light | UI rebuilds without noticeable delay |

## 37. App Lifecycle

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 37.1 | App to background → foreground | Press home, reopen app | Last screen preserved, no crash |
| 37.2 | Dialog survives orientation change | Open dialog, rotate | Dialog re-lays out (isScrollControlled handles it) |
| 37.3 | Multi-window (Android) | Enter split-screen | App resizes, tablet breakpoint may activate |

## 38. Error Recovery

| ID | Title | Steps | Expected |
|----|-------|-------|----------|
| 38.1 | Rapid dialog open/close | Open and close dialog rapidly | No crash or state corruption |
| 38.2 | Save with empty controllers | Programmatically clear TextControllers then save | Validation catches all, no crash |
| 38.3 | setState after unmount | Trigger async op that calls setState | `mounted` check prevents crash |
| 38.4 | Index out of bounds — _cars | Delete car while on its detail | `_indexWhere` returns -1, `_selectedCar` returns null, detail shows empty |
