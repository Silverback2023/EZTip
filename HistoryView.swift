import SwiftUI

struct HistoryView: View {
    @Binding var history: [[String: String]] // Binding to the history records

    private let serviceLevelIcons: [String: String] = [
        "Good Service (15%)": "hand.thumbsup.fill",
        "Great Service (20%)": "star.fill",
        "Awesome Service (30%)": "crown.fill",
        "Custom Tip (%)": "dollarsign.circle.fill"
    ]

    private let percentageColor: [String: Color] = [
        "Good Service (15%)": .yellow,
        "Great Service (20%)": .orange,
        "Awesome Service (30%)": .blue,
        "Custom Tip (%)": .green
    ]

    @Environment(\.presentationMode) var presentationMode // Access the presentation mode

    var body: some View {
        VStack {
            Text("History")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(history, id: \.self) { record in
                        HStack(alignment: .top, spacing: 10) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Restaurant Name: \(record["restaurantName"] ?? "")")
                                Text("Location: \(record["restaurantLocation"] ?? "")")
                                Text("Bill Amount: \(record["billAmount"] ?? "")")
                                Text("Total Bill: $\(record["totalBill"] ?? "")")
                                Text("Service Level: \(record["serviceLevel"] ?? "")")
                                if let customTip = record["customTipPercentage"], !customTip.isEmpty {
                                    Text("Custom Tip Percentage: \(customTip)%")
                                }
                                Text("Date: \(record["date"] ?? "")")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            if let serviceLevel = record["serviceLevel"] {
                                if let icon = serviceLevelIcons[serviceLevel] {
                                    Image(systemName: icon)
                                        .font(.system(size: 40))
                                        .foregroundColor(percentageColor[serviceLevel] ?? .black)
                                } else {
                                    Image(systemName: "questionmark.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                }
                            }

                            Button(action: {
                                // Add code to delete item
                                if let index = history.firstIndex(of: record) {
                                    history.remove(at: index)
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .multilineTextAlignment(.center)
                    }
                }
                .padding()
            }
            .frame(maxHeight: .infinity)
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Dismiss the view
                }) {
                    Image(systemName: "chevron.left") // Back button icon
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

