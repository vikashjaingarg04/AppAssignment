import SwiftUI

struct RecordScreen: View {
	@State private var selectedFilter: RecordFilter = .all
	@EnvironmentObject private var theme: ThemeManager

	var filteredTransactions: [TransactionItem] {
		switch selectedFilter {
		case .all: return MockData.transactions
		case .receive: return MockData.transactions.filter { $0.type == .receive }
		case .send: return MockData.transactions.filter { $0.type == .send }
		}
	}

	var body: some View {
		NavigationStack {
			ScrollView(showsIndicators: false) {
				VStack(alignment: .leading, spacing: 16) {
					Text("Record")
						.font(.title2.weight(.semibold))
						.padding(.top, 6)

					HStack(spacing: 10) {
						ForEach(RecordFilter.allCases, id: \.self) { filter in
							FilterChip(title: filter.title, isSelected: selectedFilter == filter) {
								withAnimation(.easeInOut(duration: 0.2)) { selectedFilter = filter }
							}
						}
					}

					VStack(spacing: 12) {
						ForEach(filteredTransactions) { tx in
							TransactionRow(item: tx)
						}
					}
				}
				.padding(16)
			}
			.background(AppBackgroundWithGlow())
		}
	}
}

enum RecordFilter: CaseIterable { case all, receive, send }
extension RecordFilter { var title: String { switch self { case .all: return "All"; case .receive: return "Receive"; case .send: return "Send" } } }

private struct FilterChip: View {
	var title: String
	var isSelected: Bool
	var action: () -> Void

	var body: some View {
		Button(action: action) {
			Text(title)
				.font(.subheadline.weight(isSelected ? .semibold : .regular))
				.padding(.horizontal, 12)
				.padding(.vertical, 8)
				.background(
					Capsule().fill(isSelected ? Color.white.opacity(0.15) : Color.white.opacity(0.05))
				)
		}
		.buttonStyle(.plain)
	}
}

#Preview {
	RecordScreen()
		.environmentObject(ThemeManager())
		.background(AppBackgroundWithGlow())
} 