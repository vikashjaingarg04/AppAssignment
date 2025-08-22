import SwiftUI

struct TransactionsSummaryScreen: View {
	@State private var selectedAction: String? = nil
	@State private var goExchange: Bool = false
    @EnvironmentObject private var theme: ThemeManager

	var body: some View {
		NavigationStack {
			ScrollView(showsIndicators: false) {
				VStack(alignment: .leading, spacing: 20) {
					// Top navigation actions outside the card
					HStack {
						Button(action: {}) { Image(systemName: "line.3.horizontal").font(.title2).foregroundStyle(.white) }
						Spacer()
						Button(action: {}) { Image(systemName: "bell").font(.title2).foregroundStyle(.white) }
					}

					StackedTealBlueHeaderCard {
						// Centered INR chip
						HStack { Spacer(); Text("INR").font(.caption2.weight(.bold)).padding(.horizontal, 12).padding(.vertical, 6).background(Capsule().fill(Color.black.opacity(0.35))).overlay(Capsule().stroke(Color.white.opacity(0.15), lineWidth: 1)).foregroundStyle(.white); Spacer() }
						// Main amount
						HStack { Spacer(); Text(MockData.portfolioINR.inrString).font(.system(size: 40, weight: .bold)).foregroundStyle(.white); Spacer() }
						// Centered sub info row
						HStack(spacing: 12) {
							Text("₹ 1,342").font(.subheadline).foregroundStyle(.white.opacity(0.85))
							Text("+4.6%").font(.subheadline.weight(.semibold)).foregroundStyle(.green)
						}
						.frame(maxWidth: .infinity)
					}

					HStack(spacing: 18) {
						CircleAction(icon: "arrow.up", title: "Send") { selectedAction = "Send" }
						CircleAction(icon: "plus", title: "Exchange") { goExchange = true }
						CircleAction(icon: "arrow.down", title: "Receive") { selectedAction = "Receive" }
					}
					.frame(maxWidth: .infinity)

					HStack {
						Text("Transactions")
							.font(.headline)
						Spacer()
						Text("Last 4 days")
							.font(.subheadline)
							.foregroundStyle(.secondary)
					}

					VStack(spacing: 14) {
						ForEach(MockData.transactions) { tx in
							TransactionRow(item: tx)
						}
					}
				}
				.padding(16)
			}
			.background(AppBackgroundWithGlow())
			.navigationTitle("")
			.navigationBarHidden(true)
			.navigationDestination(isPresented: $goExchange) {
				ExchangeScreen()
			}
		}
	}
}

private struct CircleAction: View {
	var icon: String
	var title: String
	var action: () -> Void

	var body: some View {
		VStack(spacing: 8) {
			Button(action: {
				UIImpactFeedbackGenerator(style: .medium).impactOccurred()
				action()
			}) {
				ZStack {
					Circle()
						.fill(
							LinearGradient(colors: [
								Color.black.opacity(0.85),
								Color.black.opacity(0.55)
							], startPoint: .topLeading, endPoint: .bottomTrailing)
						)
						.overlay(
							Circle().stroke(
								LinearGradient(colors: [
									Color.white.opacity(0.18),
									Color.white.opacity(0.04)
								], startPoint: .topLeading, endPoint: .bottomTrailing),
								lineWidth: 1
							)
						)
						.overlay(
							// Soft inner rim on bottom-right
							Circle().stroke(
								LinearGradient(colors: [
									Color.black.opacity(0.6),
									Color.clear
								], startPoint: .bottomTrailing, endPoint: .topLeading),
								lineWidth: 10
							)
							.blur(radius: 10)
							.mask(Circle().stroke(lineWidth: 10))
						)

					Image(systemName: icon)
						.font(.system(size: 18, weight: .bold))
						.foregroundStyle(.white)
				}
				.frame(width: 60, height: 60)
				.shadow(color: Color.black.opacity(0.55), radius: 14, x: 0, y: 8)
			}
			Text(title).font(.caption)
		}
	}
}

#Preview {
	TransactionsSummaryScreen()
		.environmentObject(ThemeManager())
		.background(AppBackgroundWithGlow())
}