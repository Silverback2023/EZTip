import SwiftUI

struct ContentView: View {
    @State private var restaurantName = ""
    @State private var restaurantLocation = ""
    @State private var billAmount = ""
    @State private var customTipPercentage = ""
    @State private var total: Double? = nil // Total bill amount
    @State private var selectedServiceLevel: String? = nil // Track selected service level icon
    @State private var showManualTipInput = false // Track whether manual tip input is shown
    @State private var currentDate = Date() // Track current date

    // Define service level icons and colors
    private let serviceLevelIcons: [(String, String)] = [
        ("hand.thumbsup.fill", "Good Service (15%)"),
        ("star.fill", "Great Service (20%)"),
        ("crown.fill", "Awesome Service (30%)"),
        ("dollarsign.circle.fill", "Custom Tip (%)")
    ]

    private let percentageColor: [String: Color] = [
        "Good Service (15%)": .yellow,
        "Great Service (20%)": .orange,
        "Awesome Service (30%)": .blue,
        "Custom Tip (%)": .white
    ]

    @State private var history: [[String: String]] = [] // Declare history as @State

    var body: some View {
        NavigationView {
            VStack {
                Text("EZTip")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                TextField("Restaurant", text: $restaurantName)
                    .padding()
                
                TextField("Location", text: $restaurantLocation)
                    .padding()
                
                TextField("Bill Amount", text: $billAmount)
                    .padding()
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                    ForEach(serviceLevelIcons, id: \.0) { icon, percentage in
                        Button(action: {
                            if percentage == "Custom Tip (%)" {
                                showManualTipInput.toggle()
                                selectedServiceLevel = percentage // Set selectedServiceLevel to keep UI consistent
                            } else {
                                selectedServiceLevel = percentage
                            }
                        }) {
                            VStack {
                                if percentage == "Custom Tip (%)" {
                                    Image(systemName: icon)
                                        .font(.system(size: 40)) // Larger icon size
                                        .foregroundColor(.green)
                                        .frame(height: 100) // Increase height
                                    Text(percentage)
                                        .font(.headline) // Make font more readable
                                        .foregroundColor(.black) // Set font color to black
                                        .multilineTextAlignment(.center) // Center-align text
                                } else {
                                    Image(systemName: icon)
                                        .font(.system(size: 40)) // Larger icon size
                                        .foregroundColor(percentageColor[percentage] ?? .black)
                                        .frame(height: 100) // Increase height
                                    Text(percentage)
                                        .font(.headline) // Make font more readable
                                        .foregroundColor(.black) // Set font color to black
                                        .multilineTextAlignment(.center) // Center-align text
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                            .background(Color.white) // Set background color to white
                            .cornerRadius(10) // Set corner radius to 10
                            .foregroundColor(percentage == selectedServiceLevel ? .primary : .white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.primary, lineWidth: 5) // Set thicker border
                            )
                        }
                        .buttonStyle(PlainButtonStyle()) // Remove button styling
                    }
                }
                
                if showManualTipInput {
                    TextField("Custom Tip (%)", text: $customTipPercentage)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .multilineTextAlignment(.center)
                }
                
                HStack {
                    // Clear button
                    Button(action: {
                        clearFields()
                    }) {
                        Text("Clear")
                            .foregroundColor(.white) // Set font color to black
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2) // Add border
                            )
                    }
                    .padding()
                    
                    // Calculate button
                    Button(action: {
                        calculateTotal()
                        saveToHistory() // Save current input to history
                    }) {
                        Text("Calculate")
                            .foregroundColor(.white) // Set font color to black
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.yellow)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2) // Add border
                            )
                    }
                    .padding()
                    
                    // History button
                    NavigationLink(destination: HistoryView(history: $history)) { // Pass $history as binding
                        Text("History")
                            .foregroundColor(.white) // Set font color to black
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2) // Add border
                            )
                    }
                    .padding()
                }
                
                // Display total bill amount if calculated
                if let total = total {
                    Text("Total Bill: $\(total, specifier: "%.2f")")
                        .padding()
                }
                
                Spacer()
            }
            .background(Color.white) // Set background color to white
            .navigationTitle("") // Hide default navigation title
            .padding()
        }
    }
    
    // Function to clear all input fields
    private func clearFields() {
        restaurantName = ""
        restaurantLocation = ""
        billAmount = ""
        customTipPercentage = ""
        total = nil
        selectedServiceLevel = nil
        showManualTipInput = false // Reset manual tip input visibility
    }
    
    // Function to calculate total bill amount
    private func calculateTotal() {
        let bill = Double(billAmount) ?? 0
        let tipPercentage = Double(customTipPercentage) ?? 0
        let selectedPercentage = selectedServiceLevel.map { Double($0.components(separatedBy: "(").last?.dropLast(2) ?? "0") ?? 0 } ?? 0
        let tipAmount = bill * (tipPercentage + selectedPercentage) / 100
        total = bill + tipAmount
    }

    // Function to save current input to history
    private func saveToHistory() {
        if let selectedServiceLevel = selectedServiceLevel, let total = total {
            var item = [
                "restaurantName": restaurantName,
                "restaurantLocation": restaurantLocation,
                "billAmount": billAmount,
                "serviceLevel": selectedServiceLevel,
                "totalBill": String(format: "%.2f", total),
                "date": DateFormatter.localizedString(from: currentDate, dateStyle: .short, timeStyle: .short)
            ]
            if !customTipPercentage.isEmpty {
                item["customTipPercentage"] = customTipPercentage
            }
            history.append(item)
        }
    }
}
