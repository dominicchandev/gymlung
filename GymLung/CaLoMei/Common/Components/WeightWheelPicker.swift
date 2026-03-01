//
//  WeightWheelPicker.swift
//  CaLoMei
//

import SwiftUI

struct WeightWheelPicker: View {
    @Binding var value: Double
    var range: ClosedRange<Int> = 35...150

    @State private var wholeKG: Int = 65
    @State private var decimalPart: Int = 0
    @State private var initialized = false

    var body: some View {
        HStack(spacing: 0) {
            Picker("", selection: $wholeKG) {
                ForEach(range, id: \.self) { kg in
                    Text("\(kg)")
                        .foregroundColor(.white)
                        .tag(kg)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 100)
            .clipped()

            Text(".")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)

            Picker("", selection: $decimalPart) {
                ForEach(0..<10, id: \.self) { d in
                    Text("\(d)")
                        .foregroundColor(.white)
                        .tag(d)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 60)
            .clipped()

            Text("kg")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Theme.textSecondary)
                .padding(.leading, 4)
        }
        .frame(height: 150)
        .onAppear {
            guard !initialized else { return }
            initialized = true
            let clamped = min(max(value, Double(range.lowerBound)), Double(range.upperBound) + 0.9)
            wholeKG = min(max(Int(clamped), range.lowerBound), range.upperBound)
            decimalPart = Int(round((clamped - Double(Int(clamped))) * 10)) % 10
        }
        .onChange(of: wholeKG) {
            syncToValue()
        }
        .onChange(of: decimalPart) {
            syncToValue()
        }
    }

    private func syncToValue() {
        let newValue = Double(wholeKG) + Double(decimalPart) / 10.0
        // Clamp to valid range
        let minVal = Double(range.lowerBound)
        let maxVal = Double(range.upperBound) + 0.9
        value = min(max(newValue, minVal), maxVal)
    }
}
