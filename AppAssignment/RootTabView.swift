import SwiftUI

enum AppTab: Int, CaseIterable {
	case analytics
	case exchange
	case record
	case wallet

	var title: String {
		switch self {
		case .analytics: return "Analytics"
		case .exchange: return "Exchange"
		case .record: return "Record"
		case .wallet: return "Wallet"
		}
	}

	var systemImage: String {
		switch self {
		case .analytics: return "chart.line.uptrend.xyaxis"
		case .exchange: return "arrow.2.squarepath"
		case .record: return "list.bullet.rectangle"
		case .wallet: return "wallet.pass"
		}
	}
}

struct RootTabView: View {
	@State private var selectedTab: AppTab = .analytics
	@State private var showCenterAction: Bool = false

	var body: some View {
		ZStack(alignment: .bottom) {
			TabView(selection: $selectedTab) {
				PortfolioDashboardScreen()
					.tag(AppTab.analytics)
					.tabItem { Label(AppTab.analytics.title, systemImage: AppTab.analytics.systemImage) }

				TransactionsSummaryScreen()
					.tag(AppTab.exchange)
					.tabItem { Label(AppTab.exchange.title, systemImage: AppTab.exchange.systemImage) }

				RecordScreen()
					.tag(AppTab.record)
					.tabItem { Label(AppTab.record.title, systemImage: AppTab.record.systemImage) }

				WalletScreen()
					.tag(AppTab.wallet)
					.tabItem { Label(AppTab.wallet.title, systemImage: AppTab.wallet.systemImage) }
			}
			.opacity(0) // hide default tab bar visuals

			CustomGlassTabBar(selectedTab: $selectedTab, centerAction: {
				showCenterAction = true
			})
		}
		.ignoresSafeArea(.keyboard)
		.sheet(isPresented: $showCenterAction) {
			CenterActionSheet()
		}
	}
}

struct CustomGlassTabBar: View {
	@Binding var selectedTab: AppTab
	var centerAction: () -> Void

	@Environment(\.colorScheme) private var colorScheme

	var body: some View {
		HStack(spacing: 14) {
			// Glass pill with tabs
			HStack(spacing: 0) {
				ForEach(AppTab.allCases, id: \.self) { tab in
					TabButton(tab: tab, isSelected: selectedTab == tab) {
						UIImpactFeedbackGenerator(style: .light).impactOccurred()
						withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
							selectedTab = tab
						}
					}
				}
			}
			.padding(.horizontal, 12)
			.padding(.vertical, 10)
			.background(
				RoundedRectangle(cornerRadius: 36, style: .continuous)
					.fill(Color.black.opacity(0.88))
			)
			.overlay(
				RoundedRectangle(cornerRadius: 36, style: .continuous)
					.strokeBorder(Color.black.opacity(0.9), lineWidth: 2)
			)
			.shadow(color: .black.opacity(0.5), radius: 30, x: 0, y: 10)

			// Separate floating plus button
			Button(action: {
				UIImpactFeedbackGenerator(style: .medium).impactOccurred()
				centerAction()
			}) {
				Image(systemName: "plus")
					.font(.system(size: 22, weight: .bold))
					.frame(width: 56, height: 56)
					.background(Circle().fill(Color.white))
					.foregroundStyle(Color.blue)
					.overlay(Circle().strokeBorder(Color.black.opacity(0.08)))
			}
		}
		.padding(.horizontal, 24)
		.padding(.bottom, 16)
	}
}

struct TabButton: View {
	var tab: AppTab
	var isSelected: Bool
	var action: () -> Void

	private var unselectedColor: Color { Color.white.opacity(0.65) }

	var body: some View {
		Button(action: action) {
			ZStack {
				if isSelected {
					let fillStyle: AnyShapeStyle = AnyShapeStyle(LinearGradient(colors: [
						Color(red: 0.20, green: 0.31, blue: 0.95),
						Color(red: 0.16, green: 0.24, blue: 0.78)
					], startPoint: .topLeading, endPoint: .bottomTrailing))
					RoundedRectangle(cornerRadius: 26, style: .continuous)
						.fill(fillStyle)
						.frame(width: 100, height: 50)
						.overlay(
							RoundedRectangle(cornerRadius: 26, style: .continuous).strokeBorder(Color.white.opacity(0.15), lineWidth: 1)
						)
				}
				VStack(spacing: 4) {
					Image(systemName: tab.systemImage)
						.font(.system(size: 12, weight: .semibold))
						.foregroundStyle(isSelected ? .white : unselectedColor)
					Text(tab.title)
						.font(.system(size: 9, weight: .semibold))
						.foregroundStyle(isSelected ? .white : unselectedColor)
				}
				.frame(maxWidth: .infinity)
			}
		}
		.buttonStyle(.plain)
		.frame(maxWidth: .infinity, minHeight: 50)
	}
}

struct CenterActionSheet: View {
	var body: some View {
		NavigationStack {
			VStack(spacing: 20) {
				Text("Quick Actions")
					.font(.headline)
				Button("Send") {}
				Button("Receive") {}
				Button("Exchange") {}
				Spacer()
			}
			.padding()
			.navigationTitle("Actions")
		}
	}
}

#Preview {
	RootTabView()
} 
