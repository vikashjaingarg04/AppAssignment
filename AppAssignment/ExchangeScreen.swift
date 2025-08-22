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
    private var receiveETH: Double {
        // Treat current amount as INR when converting INR -> ETH
        let grossINR = amountDouble
        let fee = grossINR * summary.spread + summary.gasFeeINR
        let netINR = max(grossINR - fee, 0)
        return max(netINR / summary.rateINRPerETH, 0)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                ZStack {
                    VStack(spacing: 12) {
                        SwapPanel(titleLeftIcon: iconName(for: fromToken), title: "\(fromToken)", subtitle: "Send", bottomRightText: balanceText(for: fromToken)) {
                            TextField("0.0", text: $amount)
                                .font(.system(size: 36, weight: .bold))
                                .keyboardType(.decimalPad)
                                .focused($focused)
                        }
                        SwapPanel(titleLeftIcon: iconName(for: toCurrency), title: "\(toCurrency)", subtitle: "Receive", bottomRightText: balanceText(for: toCurrency)) {
                            Group {
                                if toCurrency.uppercased() == "INR" {
                                    Text(receiveINR.inrString)
                                } else {
                                    Text(receiveETH.format(maxFraction: 6))
                                }
                            }
                            .font(.system(size: 32, weight: .bold))
                        }
                    }

                    SwapButton {
                        let oldFrom = fromToken
                        let oldTo = toCurrency
                        let newAmount: String
                        if oldFrom.uppercased() == "ETH" && oldTo.uppercased() == "INR" {
                            newAmount = String(format: "%.2f", receiveINR)
                        } else if oldFrom.uppercased() == "INR" && oldTo.uppercased() == "ETH" {
                            newAmount = receiveETH.format(maxFraction: 6)
                        } else {
                            newAmount = amount
                        }
                        withAnimation(.spring()) {
                            swap(&fromToken, &toCurrency)
                            amount = newAmount
                        }
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
        .background(AppBackgroundWithGlow())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("Exchange")
                    .font(.headline)
                    .foregroundStyle(.white)
            }
        }
        .tint(.white)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private func iconName(for code: String) -> String {
        switch code.uppercased() {
        case "ETH": return "e.circle.fill"
        case "INR": return "indianrupeesign.circle.fill"
        default: return "circle"
        }
    }

    private func balanceText(for code: String) -> String {
        switch code.uppercased() {
        case "ETH":
            return "10.254"
        case "INR":
            return formatINRDecimal(435804)
        default:
            return "-"
        }
    }

    private func formatINRDecimal(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.locale = Locale(identifier: "en_IN")
        f.maximumFractionDigits = 0
        return f.string(from: NSNumber(value: value)) ?? "0"
    }
}

private struct SwapPanel<Content: View>: View {
    var titleLeftIcon: String
    var title: String
    var subtitle: String
    var bottomRightText: String? = nil
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
            Spacer(minLength: 0)
            HStack {
                Text("Balance")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                if let t = bottomRightText {
                    Text(t)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .frame(minHeight: 150, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(Color.white.opacity(0.06)))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

// Inner row used within the combined swap card (no background)
private struct SwapRow<Content: View>: View {
    var titleLeftIcon: String
    var title: String
    var subtitle: String
    @ViewBuilder var content: () -> Content
    var minHeight: CGFloat = 150

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 10) {
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
        .padding(16)
        .frame(minHeight: minHeight, alignment: .leading)
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
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.white)
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.black.opacity(0.35))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.white.opacity(0.10), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.45), radius: 10, x: 0, y: 6)
        }
    }
}

#Preview { ExchangeScreen() } 