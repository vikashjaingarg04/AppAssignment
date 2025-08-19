import SwiftUI

struct GradientHeaderCard<Content: View>: View {
	var gradient: LinearGradient = LinearGradient(colors: [Color(#colorLiteral(red: 0.215, green: 0.168, blue: 0.631, alpha: 1)), Color(#colorLiteral(red: 0.345, green: 0.345, blue: 0.949, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
	@ViewBuilder var content: () -> Content

	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			content()
		}
		.padding(20)
		.background(
			RoundedRectangle(cornerRadius: 24, style: .continuous)
				.fill(gradient)
		)
	}
}

struct TimeSelector: View {
	@Binding var selected: String
	private let options = ["1h","8h","1d","1w","1m","6m","1y"]

	var body: some View {
		HStack(spacing: 18) {
			ForEach(options, id: \.self) { option in
				Button(action: { withAnimation(.easeInOut) { selected = option } }) {
					Text(option)
						.font(.system(size: 13, weight: option == selected ? .semibold : .regular))
						.foregroundStyle(option == selected ? .primary : .secondary)
						.padding(.horizontal, 8)
						.padding(.vertical, 6)
						.background(
							Capsule().fill(option == selected ? Color.white.opacity(0.08) : Color.clear)
						)
				}
			}
		}
	}
}

struct AssetCard: View {
	var asset: Asset

	var body: some View {
		HStack(spacing: 14) {
			ZStack {
				Circle().fill(Color.orange.opacity(0.15)).frame(width: 44, height: 44)
				Image(systemName: asset.iconSystemName)
					.font(.system(size: 22))
					.foregroundStyle(.orange)
			}
			VStack(alignment: .leading, spacing: 4) {
				Text("\(asset.name) (\(asset.symbol))")
					.font(.subheadline)
					.foregroundStyle(.primary)
				Text(asset.priceINR.inrString)
					.font(.footnote)
					.foregroundStyle(.secondary)
			}
			Spacer()
			Text(String(format: "%@%.1f%%", asset.changePercent >= 0 ? "+" : "", asset.changePercent))
				.font(.footnote.weight(.semibold))
				.foregroundStyle(asset.changePercent >= 0 ? .green : .red)
		}
		.padding()
		.background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.white.opacity(0.04)))
	}
}

struct TransactionRow: View {
	var item: TransactionItem
	private let df: DateFormatter = {
		let f = DateFormatter()
		f.dateFormat = "d MMMM"
		return f
	}()

	var body: some View {
		HStack(spacing: 12) {
			ZStack {
				RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.white.opacity(0.06)).frame(width: 48, height: 48)
				Image(systemName: item.type.icon)
					.font(.system(size: 18, weight: .semibold))
			}
			VStack(alignment: .leading, spacing: 4) {
				Text(item.type.title)
					.font(.subheadline.weight(.semibold))
				Text(df.string(from: item.date))
					.font(.caption)
					.foregroundStyle(.secondary)
			}
			Spacer()
			VStack(alignment: .trailing, spacing: 4) {
				Text(item.tokenSymbol)
					.font(.caption)
					.foregroundStyle(.secondary)
				Text("\(item.amountToken.format())")
					.font(.subheadline.weight(.semibold))
			}
		}
		.padding()
		.background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color.white.opacity(0.05)))
	}
}

struct SimpleLineChart: View {
	var values: [Double]
	var lineColor: Color = .green

	@State private var trimEnd: CGFloat = 0

	var body: some View {
		GeometryReader { proxy in
			let w = proxy.size.width
			let h = proxy.size.height
			let maxV = (values.max() ?? 1)
			let minV = (values.min() ?? 0)
			let span = max(maxV - minV, 0.0001)
			let points = values.enumerated().map { idx, v in
				CGPoint(x: CGFloat(idx) / CGFloat(values.count - 1) * w, y: h - CGFloat((v - minV) / span) * h)
			}

			Path { p in
				guard let first = points.first else { return }
				p.move(to: first)
				for pt in points.dropFirst() { p.addLine(to: pt) }
			}
			.trim(from: 0, to: trimEnd)
			.stroke(lineColor.opacity(0.9), style: StrokeStyle(lineWidth: 2.0, lineCap: .round, lineJoin: .round))
			.animation(.easeInOut(duration: 1.0), value: trimEnd)
			.onAppear { trimEnd = 1 }
		}
	}
} 