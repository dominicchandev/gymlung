//
//  ProBadge.swift
//  GymLung
//

import SwiftUI

struct ProBadge: View {
    var body: some View {
        Text("PRO")
            .font(.system(size: 9, weight: .heavy))
            .foregroundColor(.black)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                Capsule().fill(Theme.neonGreen)
                    .overlay(Capsule().stroke(Theme.bg, lineWidth: 1.5))
            )
    }
}
