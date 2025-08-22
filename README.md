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
<img width="302" height="655" alt="simulator_screenshot_63CA075F-157C-42D6-B004-B3DC80B1D237" src="https://github.com/user-attachments/assets/5<img width="302" height="655" alt="simulator_screenshot_81EA7467-1748-46CE-A572-D48CC8815871" src="https://github.com/user-attachments/assets/1aef5ccf-969a-4dce-8a96-63094f52e937" />
eba4843-0b50-4398-85a9-d3b475bf52b5" /><img width="302" height="655" alt="simulator_screenshot_D4FB3C04-FC63-4AB8-B39C-304CFE73C47C" src="https://github.com/user-attachments/assets/7423d466-1996-4c60-a0d0-6c53231255a3" />

![simulator_screenshot_4909F028-CCBA-46EB-BD5B-DB0F35D67883](https://github.com/user-attachments/assets/b49d87bd-2a8c-4aca-9fa4-9fb95ed53e34)
<img width="302" height="655" alt="simulator_screenshot_3325A9BE-EA8D-480C-AE5D-C6F17C09240E" src="https://github.com/user-attachments/assets/87d17669-2175-4bd1-8d0e-236fb35f02ec" />


<img width="302" height="655" alt="simulator_screenshot_5B79BE13-327C-4A7A-AC53-ABA023F707F7" src="https://github.com/user-attachments/assets/3bc9bbee-dd22-45fd-a3e3-1884d21cc441" />




