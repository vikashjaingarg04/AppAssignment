# AppAssignment (Crypto Portfolio & Exchange)

This SwiftUI app recreates the provided crypto portfolio/exchange UI with pixel-focused components and mock data.

## Build & Run

1. Open `AppAssignment.xcodeproj` in Xcode 15+
2. Select an iPhone 13/14/15 simulator (or any iPhone with iOS 17+)
3. Run (Cmd+R)

The app launches with a custom glass bottom bar. Tabs:
- Analytics: Portfolio Dashboard
- Exchange: Transactions Summary
- Record:  Transactions Record
- Wallet: Wallet Money and tokens

## Structure

- `AppAssignmentApp.swift`: App entry (root `RootTabView`)
- `RootTabView.swift`: Custom glassmorphism tab bar + center action
- `Models.swift`: Mock models & sample data
- `Components.swift`: Reusable views (header, time selector, cards, chart)
- `PortfolioDashboardScreen.swift`: Screen 1
- `TransactionsSummaryScreen.swift`: Screen 2
- `ExchangeScreen.swift`: Screen 3
- `RecordScreen.swift` : Sccreen 4



## Notes

- Mock trend graph is an animated line (`SimpleLineChart`)
- Haptic feedback added to key buttons

- Dark mode optimized; light mode passable
- Navigation: Transactions → Exchange

## Next Steps (Bonus)

- Add real graph data & gestures
- Improve glass blur using UIVisualEffectView if needed
- Persist user preferences (selected timeframe/currency) 



## ScreenShots 
<img width="302" height="655" alt="simulator_screenshot_78BFE3CB-AE79-4181-882D-1D5AEC6CB16A" src="https://github.com/user-attachments/assets/b64907b3-eb3d-4dde-b053-bcdabc3d6712" />
<img width="302" height="655" alt="simulator_screenshot_B85C05BD-1E38-4E90-A558-05D7E7FE755C" src="https://github.com/user-attachments/assets/4ccd609a-88e7-4a4c-9299-9cb112843fa7" />
<img width="302" height="655" alt="simulator_screenshot_6411517F-A996-4B0D-BF03-8436ECA72195" src="https://github.com/user-attachments/assets/50079e82-4768-4dc2-be77-9e5997965bcc" />
<img width="302" height="655" alt="simulator_screenshot_EEA356B9-74E5-4DAC-B052-D76804E33E3B" src="https://github.com/user-attachments/assets/c1338036-5a76-49a3-9391-3f5bde517f7e" />
<img width="302" height="655" alt="Simulator Screenshot - iPhone 16 Pro - 2025-08-22 at 14 13 25" src="https://github.com/user-attachments/assets/c814a704-d72a-4643-96d5-d152f87cd986" />
<img width="302" height="655" alt="Simulator Screenshot - iPhone 16 Pro - 2025-08-22 at 14 13 54" src="https://github.com/user-attachments/assets/37712c29-1b47-400d-bd1e-3183ea8493fa" />


