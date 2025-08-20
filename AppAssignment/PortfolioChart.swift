import SwiftUI

struct PortfolioChart: View {
	var barValues: [Double]
	var lineValues: [Double]
	var highlightIndex: Int
	var lineColor: Color = Color(red: 0.23, green: 0.85, blue: 0.55)

	var body: some View {
		GeometryReader { geo in
			let width = geo.size.width
			let height = geo.size.height

			let maxVal = max((barValues.max() ?? 1), (lineValues.max() ?? 1))
			let minVal = min((barValues.min() ?? 0), (lineValues.min() ?? 0))
			let span = max(maxVal - minVal, 0.0001)
			let count = max(barValues.count, 1)

			let inset: CGFloat = 12
			let W = max(width - inset * 2, 1)
			let H = max(height - inset * 2, 1)
			let stepX = W / CGFloat(max(count - 1, 1))
			let barWidth = min(18, max(6, stepX * 0.5))

			ZStack(alignment: .bottomLeading) {
				// Bars (rounded, gradient, ~85% of chart height)
				ForEach(0..<count, id: \.self) { idx in
					let x = inset + CGFloat(idx) * stepX
					let value = barValues[idx]
					let topY = yPosition(for: value, min: minVal, span: span, inset: inset, height: H)
					let barH = max(6, (inset + H) - topY)
					RoundedRectangle(cornerRadius: 10, style: .continuous)
						.fill(
							LinearGradient(colors: [Color.white.opacity(0.12), Color.white.opacity(0.02)], startPoint: .top, endPoint: .bottom)
						)
						.frame(width: barWidth, height: barH * 0.85)
						.position(x: x, y: inset + H - (barH * 0.85) / 2)
				}

				// Smooth line using Catmull–Rom → Bezier conversion
				let points: [CGPoint] = lineValues.enumerated().map { idx, v in
					CGPoint(x: inset + CGFloat(idx) * stepX, y: yPosition(for: v, min: minVal, span: span, inset: inset, height: H))
				}
				catmullRomBezierPath(points: points)
					.stroke(lineColor.opacity(0.95), style: StrokeStyle(lineWidth: 1.7, lineCap: .round, lineJoin: .round))
					.shadow(color: lineColor.opacity(0.35), radius: 4)

				// Highlight marker exactly at the line point
				let idx = min(max(highlightIndex, 0), count - 1)
				let mX = inset + CGFloat(idx) * stepX
				let mY = yPosition(for: lineValues[min(max(highlightIndex, 0), lineValues.count - 1)], min: minVal, span: span, inset: inset, height: H)
				Path { p in
					p.move(to: CGPoint(x: mX, y: inset))
					p.addLine(to: CGPoint(x: mX, y: inset + H))
				}
				.stroke(Color.white.opacity(0.9), style: StrokeStyle(lineWidth: 1.5))

				Circle()
					.fill(Color.white)
					.frame(width: 14, height: 14)
					.overlay(Circle().stroke(Color.black.opacity(0.75), lineWidth: 2))
					.position(x: mX, y: mY)
			}
		}
	}

	private func yPosition(for value: Double, min: Double, span: Double, inset: CGFloat, height: CGFloat) -> CGFloat {
		let normalized = CGFloat((value - min) / span)
		return inset + (height - normalized * height)
	}

	private func catmullRomBezierPath(points: [CGPoint]) -> Path {
		var path = Path()
		guard points.count > 1 else { return path }
		path.move(to: points[0])
		let n = points.count
		for i in 0..<(n - 1) {
			let p0 = i == 0 ? points[i] : points[i - 1]
			let p1 = points[i]
			let p2 = points[i + 1]
			let p3 = (i + 2 < n) ? points[i + 2] : points[i + 1]
			let c1 = CGPoint(
				x: p1.x + (p2.x - p0.x) / 6.0,
				y: p1.y + (p2.y - p0.y) / 6.0
			)
			let c2 = CGPoint(
				x: p2.x - (p3.x - p1.x) / 6.0,
				y: p2.y - (p3.y - p1.y) / 6.0
			)
			path.addCurve(to: p2, control1: c1, control2: c2)
		}
		return path
	}
}

#Preview {
	PortfolioChart(
		barValues: [10,20,14,18,22,17,23,28,25,30,33],
		lineValues: [10,18,15,20,19,22,27,31,30,34,36],
		highlightIndex: 8
	)
	.frame(height: 220)
	.background(Color.black)
} 