//
//  SplashScreenView.swift
//  GymLung
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color(hex: "#FFAD33")
                .ignoresSafeArea()

            Image("AppLogo")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(Color(hex: "#1A1A1A"))
                .frame(width: 120, height: 120)
        }
    }
}
