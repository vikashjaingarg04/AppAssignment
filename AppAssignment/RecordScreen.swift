import SwiftUI

struct RecordScreen: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Record")
                    .font(.title2.weight(.semibold))
                Text("This is a placeholder for records/history.")
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding()
            .background(Color.black)
        }
    }
}

#Preview { RecordScreen() } 