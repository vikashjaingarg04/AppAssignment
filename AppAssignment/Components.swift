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

// Refined header card styled to match the screenshot (deep blue → violet, glossy, rounded)
struct PortfolioHeaderCard<Content: View>: View {
	@Environment(\.colorScheme) private var colorScheme
	@ViewBuilder var content: () -> Content

	private var baseGradient: LinearGradient {
		// Deep blue to violet
		LinearGradient(
			colors: [
				Color(red: 0.17, green: 0.28, blue: 0.98),
				Color(red: 0.42, green: 0.35, blue: 0.98)
			],
			startPoint: .topLeading,
			endPoint: .bottomTrailing
		)
	}

	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 32, style: .continuous)
				.fill(baseGradient)
				.shadow(color: .black.opacity(0.35), radius: 24, x: 0, y: 12)
				.overlay(
					// Glossy sweep overlay
					LinearGradient(
						colors: [Color.white.opacity(0.18), Color.white.opacity(0.02)],
						startPoint: .topLeading,
						endPoint: .bottomTrailing
					)
					.clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
				)
				.overlay(
					RoundedRectangle(cornerRadius: 32, style: .continuous)
						.stroke(Color.white.opacity(colorScheme == .dark ? 0.08 : 0.2), lineWidth: 1)
				)

			VStack(alignment: .leading, spacing: 12) {
				content()
			}
			.padding(22)
		}
	}
}

// Stacked gradient header card (blue→violet) with a small bottom lip, content centered
struct StackedTealBlueHeaderCard<Content: View>: View {
	@ViewBuilder var content: () -> Content

	private var baseGradient: LinearGradient {
		LinearGradient(
			colors: [
				Color(red: 0.36, green: 0.33, blue: 1.0),
				Color(red: 0.16, green: 0.20, blue: 0.45)
			],
			startPoint: .topLeading,
			endPoint: .bottomTrailing
		)
	}

	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 28, style: .continuous)
				.fill(baseGradient)
				.overlay(
					LinearGradient(
						colors: [Color.white.opacity(0.18), Color.clear],
						startPoint: .topLeading,
						endPoint: .bottomTrailing
					)
					.clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
				)
			VStack(spacing: 12) {
				content()
			}
			.padding(20)
		}
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

// Shared purple bottom glow background that adapts to theme
struct AppBackgroundWithGlow: View {
	@EnvironmentObject private var theme: ThemeManager
	@Environment(\.colorScheme) private var colorScheme

	var body: some View {
		ZStack {
			theme.palette.appBackground
			VStack {
				Spacer()
				Ellipse()
					.fill(
						LinearGradient(
							colors: [
								Color(red: 0.36, green: 0.33, blue: 1.0).opacity(colorScheme == .dark ? 0.50 : 0.30),
								Color(red: 0.23, green: 0.20, blue: 0.55).opacity(colorScheme == .dark ? 0.35 : 0.22),
								Color.clear
							],
							startPoint: .bottom,
							endPoint: .top
						)
					)
					.frame(height: 360)
					.blur(radius: 50)
					.padding(.horizontal, -60)
					.offset(y: 80)
			}
		}
		.ignoresSafeArea()
	}
}

struct AssetCardLarge: View {
	var asset: Asset

	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			HStack(spacing: 12) {
				ZStack {
					Circle().fill(Color.orange)
						.frame(width: 52, height: 52)
					Image(systemName: asset.iconSystemName)
						.font(.system(size: 24, weight: .bold))
						.foregroundStyle(.white)
				}
				Text("\(asset.name) (\(asset.symbol))")
					.font(.headline)
					.foregroundStyle(.primary)
					.lineLimit(1)
					.minimumScaleFactor(0.7)
				Spacer()
			}
			HStack(alignment: .firstTextBaseline) {
				Text(asset.priceINR.inrString)
					.font(.subheadline)
					.foregroundStyle(.secondary)
				Spacer()
				Text(String(format: "%@%.1f%%", asset.changePercent >= 0 ? "+" : "", asset.changePercent))
					.font(.footnote.weight(.semibold))
					.foregroundStyle(asset.changePercent >= 0 ? .green : .red)
			}
		}
		.padding(16)
		.frame(width: 220)
		.background(
			RoundedRectangle(cornerRadius: 22, style: .continuous)
				.fill(Color.white.opacity(0.05))
		)
		.overlay(
			RoundedRectangle(cornerRadius: 22, style: .continuous)
				.stroke(Color.white.opacity(0.08), lineWidth: 1)
		)
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
