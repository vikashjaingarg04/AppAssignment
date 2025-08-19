import SwiftUI

struct ExchangeScreen: View {
    @State private var fromToken: String = "ETH"
    @State private var toCurrency: String = "INR"
    @State private var amount: String = "2.640"
    @FocusState private var focused: Bool

    private var amountDouble: Double { Double(amount) ?? 0 }
    private var summary: ExchangeRateSummary { MockData.exchangeSummary }
    private var receiveINR: Double {
        let gross = amountDouble * summary.rateINRPerETH
        let fee = gross * summary.spread + summary.gasFeeINR
        return max(gross - fee, 0)
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Button(action: { }) { Image(systemName: "chevron.left").font(.title3.weight(.semibold)) }
                        Text("Exchange")
                            .font(.headline)
                        Spacer()
                    }

                    VStack(spacing: 12) {
                        SwapPanel(titleLeftIcon: "e.circle.fill", title: "\(fromToken)", subtitle: "Send") {
                            TextField("0.0", text: $amount)
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .keyboardType(.decimalPad)
                                .focused($focused)
                        }

                        SwapButton { withAnimation(.spring()) { swap(&fromToken, &toCurrency) } }

                        SwapPanel(titleLeftIcon: "indianrupeesign.circle.fill", title: "\(toCurrency)", subtitle: "Receive") {
                            Text(receiveINR.inrString)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                        }
                    }

                    Button(action: { UIImpactFeedbackGenerator(style: .heavy).impactOccurred() }) {
                        Text("Exchange")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.blue))
                            .foregroundStyle(.white)
                    }

                    VStack(spacing: 12) {
                        HStack { Text("Rate"); Spacer(); Text("1 ETH = \(summary.rateINRPerETH.inrString)") }
                        HStack { Text("Spread"); Spacer(); Text("\(Int(summary.spread * 1000)/10)%") }
                        HStack { Text("Gas fee"); Spacer(); Text(summary.gasFeeINR.inrString) }
                        Divider().overlay(Color.white.opacity(0.2))
                        HStack { Text("You will receive"); Spacer(); Text(receiveINR.inrString).fontWeight(.semibold) }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding(16)
            }
            .background(Color.black)
        }
    }
}

private struct SwapPanel<Content: View>: View {
    var titleLeftIcon: String
    var title: String
    var subtitle: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: titleLeftIcon)
                        .font(.title3)
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                }
                Spacer()
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            content()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.white.opacity(0.05)))
    }
}

private struct SwapButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            action()
        }) {
            Image(systemName: "arrow.up.arrow.down")
                .font(.headline)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.white.opacity(0.08)))
        }
    }
}

#Preview { ExchangeScreen() } 