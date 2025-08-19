import SwiftUI

struct WalletScreen: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Wallet")
                    .font(.title2.weight(.semibold))
                Text("Your assets and balances will appear here.")
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding()
            .background(Color.black)
        }
    }
}

#Preview { WalletScreen() } 