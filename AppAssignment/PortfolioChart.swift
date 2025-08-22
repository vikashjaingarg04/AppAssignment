import SwiftUI

struct PortfolioChart: View {
    var barValues: [Double]
    var lineValues: [Double]
    var highlightIndex: Int
    var lineColor: Color = Color(red: 0.23, green: 0.85, blue: 0.55)
    var animationKey: Int = 0

    @State private var drawProgress: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height

            let maxVal = max((barValues.max() ?? 1), (lineValues.max() ?? 1))
            let minVal = min((barValues.min() ?? 0), (lineValues.min() ?? 0))
            let span = max(maxVal - minVal, 0.0001)
            let count = max(barValues.count, 1)

            // Layout config (vertical rectangle)
            let leftInset: CGFloat = 18
            let rightInset: CGFloat = 18
            let bottomInset: CGFloat = 16
            let topInset: CGFloat = 26
            let gap: CGFloat = 8
            let zoneW = width - leftInset - rightInset
            let barWidth = (zoneW - gap * CGFloat(count - 1)) / CGFloat(count)
            let chartHeight = height - topInset - bottomInset

            ZStack(alignment: .bottomLeading) {
                // Pure vertical rectangle bars
                ForEach(0..<count, id: \.self) { idx in
                    let x = leftInset + CGFloat(idx) * (barWidth + gap)
                    let value = barValues[idx]
                    let normalized = CGFloat((value - minVal) / span)
                    let barH = max(8, normalized * chartHeight)
                    Rectangle()
                        .fill(LinearGradient(colors: [
                            Color.white.opacity(0.20), Color.white.opacity(0.08)
                        ], startPoint: .top, endPoint: .bottom))
                        .frame(width: barWidth, height: barH)
                        .position(x: x + barWidth / 2, y: height - bottomInset - barH / 2)
                }

                // Line
                let points: [CGPoint] = lineValues.enumerated().map { idx, v in
                    let x = leftInset + CGFloat(idx) * (barWidth + gap) + barWidth / 2
                    let normalized = CGFloat((v - minVal) / span)
                    let y = height - bottomInset - normalized * chartHeight
                    return CGPoint(x: x, y: y)
                }

                catmullRomBezierPath(points: points)
                    .trim(from: 0, to: drawProgress)
                    .stroke(lineColor.opacity(0.97), style: StrokeStyle(lineWidth: 2.1, lineCap: .round, lineJoin: .round))
                    .shadow(color: lineColor.opacity(0.23), radius: 4)
                    .animation(.easeInOut(duration: 0.9), value: drawProgress)
                    .onAppear { drawProgress = 1 }
                    .onChange(of: animationKey) { _ in
                        drawProgress = 0
                        DispatchQueue.main.async { drawProgress = 1 }
                    }

                // Marker (highlight)
                if highlightIndex < points.count {
                    let marker = points[highlightIndex]
                    Path { p in
                        p.move(to: CGPoint(x: marker.x, y: topInset))
                        p.addLine(to: CGPoint(x: marker.x, y: height - bottomInset))
                    }
                    .stroke(Color.white.opacity(0.9), style: StrokeStyle(lineWidth: 1.9))

                    Circle()
                        .fill(Color.white)
                        .frame(width: 16, height: 16)
                        .overlay(Circle().stroke(Color.black.opacity(0.83), lineWidth: 2))
                        .position(marker)
                }
            }
        }
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
        barValues: [80, 120, 100, 140, 130, 150, 160, 180, 170, 190, 210],
        lineValues: [120, 150, 125, 170, 140, 175, 193, 210, 175, 200, 230],
        highlightIndex: 5,
        animationKey: 1
    )
    .frame(height: 220)
    .background(Color.black)
}
