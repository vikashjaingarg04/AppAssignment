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
	@State private var showAnalyticsPeek: Bool = false

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
			.toolbar(.hidden, for: .tabBar)

			CustomGlassTabBar(selectedTab: $selectedTab, centerAction: {
				showCenterAction = true
			}, onReselect: { tab in
				if tab == .analytics {
					showAnalyticsPeek = true
				}
			})
		}
		.ignoresSafeArea(.keyboard)
		.sheet(isPresented: $showCenterAction) {
			CenterActionSheet()
		}
		.sheet(isPresented: $showAnalyticsPeek) {
			AnalyticsPeekSheet()
				.presentationDetents([.height(360), .large])
		}
	}
}

struct CustomGlassTabBar: View {
	@Binding var selectedTab: AppTab
	var centerAction: () -> Void
	var onReselect: ((AppTab) -> Void)? = nil

	@Environment(\.colorScheme) private var colorScheme

	var body: some View {
		HStack(spacing: 14) {
			HStack(spacing: 0) {
				ForEach(AppTab.allCases, id: \.self) { tab in
					let isSel = (selectedTab == tab)
					TabButton(tab: tab, isSelected: isSel) {
						UIImpactFeedbackGenerator(style: .light).impactOccurred()
						if isSel {
							onReselect?(tab)
						} else {
							withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
								selectedTab = tab
							}
						}
					}
				}
			}
			.padding(.horizontal, 12)
			.padding(.vertical, 10)
			.background(
				RoundedRectangle(cornerRadius: 36, style: .continuous)
					.fill(colorScheme == .dark ? Color.black.opacity(0.88) : Color.white.opacity(0.96))
			)
			.overlay(
				RoundedRectangle(cornerRadius: 36, style: .continuous)
					.strokeBorder(colorScheme == .dark ? Color.black.opacity(0.9) : Color.black.opacity(0.1), lineWidth: 2)
			)
			.shadow(color: Color.black.opacity(colorScheme == .dark ? 0.5 : 0.12), radius: 30, x: 0, y: 10)

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

	@Environment(\.colorScheme) private var colorScheme

	private var unselectedColor: Color { colorScheme == .dark ? Color.white.opacity(0.65) : Color.gray.opacity(0.6) }
	private var selectedContentColor: Color { colorScheme == .dark ? .white : Color.blue }

	var body: some View {
		Button(action: action) {
			ZStack {
				if isSelected {
					let fillStyle: AnyShapeStyle = {
						if colorScheme == .dark {
							return AnyShapeStyle(LinearGradient(colors: [
								Color(red: 0.20, green: 0.31, blue: 0.95),
								Color(red: 0.16, green: 0.24, blue: 0.78)
							], startPoint: .topLeading, endPoint: .bottomTrailing))
						} else {
							return AnyShapeStyle(LinearGradient(colors: [
								Color(red: 0.86, green: 0.88, blue: 1.0),
								Color(red: 0.78, green: 0.80, blue: 1.0)
							], startPoint: .topLeading, endPoint: .bottomTrailing))
						}
					}()
					RoundedRectangle(cornerRadius: 26, style: .continuous)
						.fill(fillStyle)
						.frame(width: 100, height: 50)
						.overlay(
							RoundedRectangle(cornerRadius: 26, style: .continuous).strokeBorder((colorScheme == .dark ? Color.white.opacity(0.15) : Color.black.opacity(0.06)), lineWidth: 1)
						)
				}
				VStack(spacing: 4) {
					Image(systemName: tab.systemImage)
						.font(.system(size: 12, weight: .semibold))
						.foregroundStyle(isSelected ? selectedContentColor : unselectedColor)
					Text(tab.title)
						.font(.system(size: 9, weight: .semibold))
						.foregroundStyle(isSelected ? selectedContentColor : unselectedColor)
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

struct AnalyticsPeekSheet: View {
	var body: some View {
		NavigationStack {
			VStack(alignment: .leading, spacing: 16) {
				Text("Portfolio Overview")
					.font(.headline)
					.padding(.top, 4)
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text(MockData.portfolioINR.inrString)
						.font(.system(size: 28, weight: .bold, design: .rounded))
					Text("+4.6%")
						.font(.subheadline.weight(.semibold))
						.foregroundStyle(.green)
				}
				ScrollView(.horizontal, showsIndicators: false) {
					HStack(spacing: 12) {
						AssetCard(asset: MockData.assets[0])
							.frame(width: 240)
						AssetCard(asset: MockData.assets[1])
							.frame(width: 240)
					}
				}
				Text("Recent Transactions")
					.font(.headline)
				VStack(spacing: 10) {
					ForEach(MockData.transactions) { tx in
						TransactionRow(item: tx)
					}
				}
				Spacer(minLength: 0)
			}
			.padding(16)
			.navigationTitle("Analytics")
		}
	}
}

#Preview {
	RootTabView()
} 
