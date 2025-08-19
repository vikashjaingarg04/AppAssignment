import SwiftUI

struct PortfolioDashboardScreen: View {
	@State private var showINR: Bool = true
	@State private var timeRange: String = "6m"
	private let mockTrend: [Double] = [1,1.3,1.2,1.5,1.45,1.6,1.8,2.1,2.0,2.3,2.5]

	var body: some View {
		NavigationStack {
			ScrollView(.vertical, showsIndicators: false) {
				VStack(alignment: .leading, spacing: 20) {
					GradientHeaderCard {
						HStack {
							Button(action: {}) { Image(systemName: "line.3.horizontal").font(.title2) }
							Spacer()
							Button(action: {}) { Image(systemName: "bell").font(.title2) }
						}
						Text("Portfolio Value  >")
							.font(.subheadline)
							.foregroundStyle(Color.white.opacity(0.8))

						HStack(alignment: .center, spacing: 12) {
							Text(showINR ? MockData.portfolioINR.inrString : "\(MockData.portfolioBTC.format(maxFraction: 3)) BTC")
								.font(.system(size: 36, weight: .bold, design: .rounded))
								.foregroundStyle(.white)
							Spacer()
							HStack(spacing: 0) {
								Button(action: { showINR = true }) {
									Image(systemName: "banknote")
										.font(.system(size: 14, weight: .bold))
										.padding(10)
								}
								.background(Capsule().fill(showINR ? .black.opacity(0.35) : .clear))
								Button(action: { showINR = false }) {
									Text("฿")
										.font(.system(size: 14, weight: .bold))
										.padding(10)
								}
							}
							.background(Capsule().fill(.white.opacity(0.15)))
							.clipShape(Capsule())
						}
					}

					TimeSelector(selected: $timeRange)
						.padding(.horizontal, 4)

					ZStack(alignment: .bottomLeading) {
						RoundedRectangle(cornerRadius: 24, style: .continuous)
							.fill(Color.white.opacity(0.03))
							.frame(height: 220)
							.overlay(
								SimpleLineChart(values: mockTrend.map { $0 * 100 })
									.padding(.horizontal, 16)
							)
					}

					HStack(spacing: 16) {
						AssetCard(asset: MockData.assets[0])
						AssetCard(asset: MockData.assets[1])
					}

					Text("Recent Transactions")
						.font(.headline)
						.padding(.top, 8)

					VStack(spacing: 12) {
						ForEach(MockData.transactions) { tx in
							TransactionRow(item: tx)
						}
					}
				}
				.padding(16)
			}
			.background(Color.black)
			.navigationBarHidden(true)
		}
	}
}

#Preview { PortfolioDashboardScreen() } 