import SwiftUI

struct WalletScreen: View {
	@State private var segment: WalletSegment = .tokens
	@EnvironmentObject private var theme: ThemeManager

	var body: some View {
		NavigationStack {
			ScrollView(showsIndicators: false) {
				VStack(alignment: .leading, spacing: 16) {
					Text("Wallet")
						.font(.title2.weight(.semibold))
						.padding(.top, 6)

					GradientHeaderCard {
						HStack {
							Text("Total Balance")
								.font(.subheadline)
								.foregroundStyle(Color.white.opacity(0.85))
							Spacer()
							SegmentedPill(selected: $segment)
						}
						Text(MockData.portfolioINR.inrString)
							.font(.system(size: 32, weight: .bold))
							.foregroundStyle(.white)
					}

					Text(segment == .tokens ? "Your Tokens" : "Your Fiat")
						.font(.headline)

					VStack(spacing: 12) {
						ForEach(MockData.assets) { asset in
							AssetCard(asset: asset)
						}
					}
				}
				.padding(16)
			}
			.background(AppBackgroundWithGlow())
		}
	}
}

enum WalletSegment: String, CaseIterable { case tokens = "Tokens", fiat = "Fiat" }

private struct SegmentedPill: View {
	@Binding var selected: WalletSegment

	var body: some View {
		HStack(spacing: 0) {
			ForEach(WalletSegment.allCases, id: \.self) { seg in
				Button(action: { withAnimation(.easeInOut) { selected = seg } }) {
					Text(seg.rawValue)
						.font(.caption.weight(selected == seg ? .bold : .regular))
						.padding(.horizontal, 12)
						.padding(.vertical, 8)
				}
			}
		}
		.background(Capsule().fill(Color.white.opacity(0.15)))
		.clipShape(Capsule())
	}
}

#Preview {
	WalletScreen()
		.environmentObject(ThemeManager())
		.background(AppBackgroundWithGlow())
} 