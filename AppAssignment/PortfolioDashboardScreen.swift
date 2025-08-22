import SwiftUI

struct PortfolioDashboardScreen: View {
    @State private var showINR: Bool = true
    @State private var timeRange: String = "6m"
    @State private var chartAnimationTrigger: Int = 0
    @State private var highlightIndex: Int = 8

    private let mockTrend: [Double] = [1,1.3,1.2,1.5,1.45,1.6,1.8,2.1,2.0,2.3,2.5]

    // Map timeRange to highlightIndex for marker position under tabs
    private func indexForRange(_ range: String) -> Int {
        switch range {
        case "1h": return 0
        case "8h": return 1
        case "1d": return 2
        case "1w": return 4
        case "1m": return 6
        case "6m": return 8
        case "1y": return 10
        default: return 8
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    PortfolioHeaderCard {
                        HStack {
                            Button(action: {}) { Image(systemName: "line.3.horizontal").font(.title2) }
                            Spacer()
                            Button(action: {}) { Image(systemName: "bell").font(.title2) }
                        }
                        Text("Portfolio Value  >")
                            .font(.subheadline)
                            .foregroundStyle(Color.white.opacity(0.9))

                        HStack(alignment: .center, spacing: 12) {
                            Text(showINR ? MockData.portfolioINR.inrString : "\(MockData.portfolioBTC.format(maxFraction: 3)) BTC")
                                .font(.system(size: 36, weight: .bold))
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

                    TimeSelector(selected: Binding(
                        get: { timeRange },
                        set: { newValue in
                            timeRange = newValue
                            highlightIndex = indexForRange(newValue)   // Update highlight marker position
                            chartAnimationTrigger += 1                 // Trigger line redraw animation
                        }
                    ))
                    .padding(.horizontal, 4)

                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white.opacity(0.03))
                            .frame(height: 220)
                            .overlay(
                                PortfolioChart(
                                    barValues: [80, 120, 100, 140, 130, 150, 160, 180, 170, 190, 210],
                                    lineValues: mockTrend.map { $0 * 100 },
                                    highlightIndex: highlightIndex,
                                    animationKey: chartAnimationTrigger
                                )
                                .padding(.horizontal, 16)
                            )
                    }

                    Text("Your Assets")
                        .font(.headline)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(MockData.assets) { asset in
                                AssetCardLarge(asset: asset)
                            }
                        }
                        .padding(.horizontal, 4)
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
            .background(AppBackgroundWithGlow())
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    PortfolioDashboardScreen()
}
