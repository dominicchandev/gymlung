//
//  ReviewRequestPage.swift
//  GymLung
//

import SwiftUI

struct ReviewRequestPage: View {
    var onProceed: () -> Void

    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }

    @State private var showContent = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                // Star icon
                ZStack {
                    Circle()
                        .fill(Theme.neonGreen.opacity(0.15))
                        .frame(width: 120, height: 120)

                    Image(systemName: "star.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Theme.neonGreen)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)

                VStack(spacing: 12) {
                    Text("鍾意呢個App？")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)

                    Text("俾個評分支持下我哋啦 🙏")
                        .font(.system(size: 16))
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 15)

                // Star row decoration
                HStack(spacing: 8) {
                    ForEach(0..<5) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Theme.neonGreen)
                    }
                }
                .opacity(showContent ? 1 : 0)
            }

            Spacer()

            VStack(spacing: 12) {
                ActionButton(title: "好呀 去評分 ⭐") {
                    onProceed()
                }

                Button(action: onProceed) {
                    Text("下次先啦")
                        .font(.system(size: 15))
                        .foregroundColor(Theme.textSecondary)
                }
            }
            .padding(.horizontal, 24)
            .opacity(showContent ? 1 : 0)

            Spacer().frame(height: 40)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                showContent = true
            }
        }
    }
}
