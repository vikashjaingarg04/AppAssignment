import Foundation
import SwiftUI

struct Asset: Identifiable, Hashable {
	let id = UUID()
	let symbol: String
	let name: String
	let iconSystemName: String
	let priceINR: Double
	let changePercent: Double
}

struct TransactionItem: Identifiable, Hashable {
	let id = UUID()
	let type: TransactionType
	let date: Date
	let tokenSymbol: String
	let amountToken: Double
}

enum TransactionType: String, CaseIterable { case receive, send }

extension TransactionType {
	var icon: String { self == .receive ? "arrow.down" : "arrow.up" }
	var title: String { self == .receive ? "Receive" : "Send" }
}

struct ExchangeRateSummary {
	let rateINRPerETH: Double
	let spread: Double
	let gasFeeINR: Double
}

enum MockData {
	static let assets: [Asset] = [
		Asset(symbol: "BTC", name: "Bitcoin", iconSystemName: "bitcoinsign.circle.fill", priceINR: 7562500, changePercent: 3.2),
		Asset(symbol: "ETH", name: "Ether", iconSystemName: "e.circle.fill", priceINR: 179100, changePercent: -1.1),
		Asset(symbol: "SOL", name: "Solana", iconSystemName: "s.circle.fill", priceINR: 12500, changePercent: 2.4),
		Asset(symbol: "USDT", name: "Tether", iconSystemName: "t.circle.fill", priceINR: 83.1, changePercent: 0.0)
	]

	static let transactions: [TransactionItem] = [
		TransactionItem(type: .receive, date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 20))!, tokenSymbol: "BTC", amountToken: 0.002126),
		TransactionItem(type: .send, date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 19))!, tokenSymbol: "ETH", amountToken: 0.003126),
		TransactionItem(type: .send, date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 18))!, tokenSymbol: "LTC", amountToken: 0.02126)
	]

	static let exchangeSummary = ExchangeRateSummary(rateINRPerETH: 176138.80, spread: 0.002, gasFeeINR: 422.73)

	static var portfolioINR: Double { 157342.05 }
	static var portfolioBTC: Double { 0.015 }
}

extension Double {
	var inrString: String {
		let f = NumberFormatter()
		f.numberStyle = .currency
		f.locale = Locale(identifier: "en_IN")
		f.currencySymbol = "₹ "
		f.maximumFractionDigits = 2
		return f.string(from: NSNumber(value: self)) ?? "₹ 0.00"
	}

	func format(maxFraction: Int = 6) -> String {
		let f = NumberFormatter()
		f.minimumFractionDigits = 0
		f.maximumFractionDigits = maxFraction
		return f.string(from: NSNumber(value: self)) ?? "0"
	}
} 