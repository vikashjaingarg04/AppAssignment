import SwiftUI

struct TransactionsSummaryScreen: View {
	@State private var selectedAction: String? = nil
	@State private var goExchange: Bool = false

	var body: some View {
		NavigationStack {
			ScrollView(showsIndicators: false) {
				VStack(alignment: .leading, spacing: 20) {
					GradientHeaderCard {
						HStack {
							Button(action: {}) { Image(systemName: "line.3.horizontal").font(.title2) }
							Spacer()
							Button(action: {}) { Image(systemName: "bell").font(.title2) }
						}
						HStack {
							Spacer()
							Text("INR")
								.font(.caption2.weight(.bold))
								.padding(.horizontal, 10).padding(.vertical, 6)
								.background(Capsule().fill(.black.opacity(0.25)))
							Spacer().frame(width: 0)
						}
						Text(MockData.portfolioINR.inrString)
							.font(.system(size: 40, weight: .bold, design: .rounded))
							.foregroundStyle(.white)
						HStack(spacing: 12) {
							Text("₹ 1,342")
								.font(.subheadline)
								.foregroundStyle(.white.opacity(0.8))
							Text("+4.6%")
								.font(.subheadline.weight(.semibold))
								.foregroundStyle(.green)
						}
					}

					HStack(spacing: 18) {
						CircleAction(icon: "arrow.up", title: "Send") { selectedAction = "Send" }
						CircleAction(icon: "plus", title: "Exchange") { goExchange = true }
						CircleAction(icon: "arrow.down", title: "Receive") { selectedAction = "Receive" }
					}

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
				Image(systemName: icon)
					.font(.system(size: 18, weight: .bold))
					.frame(width: 54, height: 54)
					.background(Circle().fill(.ultraThinMaterial))
			}
			Text(title).font(.caption)
		}
	}
}

#Preview { TransactionsSummaryScreen() } 