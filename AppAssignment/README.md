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



/var/folders/dv/s98ghslj74q6x0w1y2__h9hm0000gn/T/simulator_screenshot_C1320AC3-7D25-4BA6-9B70-76DB6050E327.png
