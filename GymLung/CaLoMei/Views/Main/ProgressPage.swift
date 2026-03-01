//
//  ProgressPage.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 27/2/2026.
//

import SwiftUI
import SwiftData
import Charts

struct ProgressPage: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WeightEntry.date, order: .forward) private var weightEntries: [WeightEntry]
    @Query private var profiles: [UserProfile]
    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue

    @State private var showWeightLog = false
    @State private var showPaywall = false
    @State private var chartRange: ChartRange = .ninety
    @State private var seeded = false

    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }
    private var profile: UserProfile? { profiles.first }

    private var latestWeight: Double? { weightEntries.last?.weightKG }
    private var startWeight: Double? { weightEntries.first?.weightKG }

    private var bmi: Double? {
        guard let p = profile, p.heightCM > 0, let w = latestWeight else { return nil }
        let hM = p.heightCM / 100
        return w / (hM * hM)
    }

    enum ChartRange: String, CaseIterable {
        case ninety = "90D"
        case sixMonths = "6M"
        case oneYear = "1Y"
        case all = "ALL"

        var days: Int? {
            switch self {
            case .ninety: return 90
            case .sixMonths: return 180
            case .oneYear: return 365
            case .all: return nil
            }
        }
    }

    private var filteredEntries: [WeightEntry] {
        guard let days = chartRange.days else { return weightEntries }
        let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return weightEntries.filter { $0.date >= cutoff }
    }

    // Progress fraction toward goal
    private var goalFraction: Double? {
        guard let profile, profile.goal != "維持體重",
              let target = profile.targetWeightKG,
              let start = startWeight,
              let current = latestWeight,
              abs(start - target) > 0.01 else { return nil }
        let totalChange = abs(start - target)
        let currentChange = abs(start - current)
        // Ensure we're moving in the right direction
        let rightDirection: Bool
        if profile.goal == "減脂" {
            rightDirection = current <= start
        } else {
            rightDirection = current >= start
        }
        if !rightDirection { return 0 }
        return min(currentChange / totalChange, 1.0)
    }

    private var goalPercentage: Int {
        guard let f = goalFraction else { return 0 }
        return Int(f * 100)
    }

    // Days until next weigh-in (weekly cadence)
    private var daysUntilWeighIn: Int {
        guard let last = weightEntries.last else { return 0 }
        let nextDate = Calendar.current.date(byAdding: .day, value: 7, to: last.date) ?? Date()
        let days = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: nextDate)).day ?? 0
        return max(0, days)
    }

    // Estimated goal date
    private var estimatedGoalDate: Date? {
        guard let profile, profile.goal != "維持體重",
              let target = profile.targetWeightKG,
              let current = latestWeight,
              abs(current - target) > 0.1 else { return nil }
        // Default rate: 0.5 kg/week
        let weeksNeeded = abs(current - target) / 0.5
        return Calendar.current.date(byAdding: .weekOfYear, value: Int(ceil(weeksNeeded)), to: Date())
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Card 1: Current Weight
                        currentWeightCard

                        // Card 2: Weight Chart
                        weightChartCard

                        // Card 3: BMI
                        bmiCard

                        // Log button
                        ActionButton(title: AppStrings.Progress.logTitle(mode)) {
                            if PurchaseManager.shared.isPro {
                                showWeightLog = true
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    showPaywall = true
                                }
                            }
                        }
                        .overlay(alignment: .topTrailing) {
                            if !PurchaseManager.shared.isPro {
                                ProBadge()
                                    .offset(x: -8, y: -8)
                            }
                        }
                        .padding(.horizontal, 20)

                        Spacer().frame(height: 20)
                    }
                    .padding(.top, 16)
                }
            }
            .navigationTitle(AppStrings.Progress.navTitle(mode))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showWeightLog) {
                WeightLogSheet()
            }
            .sheet(isPresented: $showPaywall) {
                PaywallSheet(trigger: .weightLog)
            }
            .onAppear { seedIfNeeded() }
        }
    }

    // MARK: - Seed Logic

    private func seedIfNeeded() {
        guard !seeded else { return }
        seeded = true
        guard weightEntries.isEmpty, let p = profile else { return }
        let entry = WeightEntry(weightKG: p.weightKG, date: p.createdAt)
        modelContext.insert(entry)
    }

    // MARK: - Card 1: Current Weight

    @ViewBuilder
    private var currentWeightCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text(AppStrings.Progress.currentWeight(mode))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                Spacer()
                // Next weigh-in badge
                Text(AppStrings.Progress.nextWeighIn(daysUntilWeighIn, mode))
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Theme.neonGreen)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Theme.neonGreen.opacity(0.15))
                    )
            }

            // Large weight display
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(String(format: "%.1f", latestWeight ?? 0))
                    .font(.system(size: 48, weight: .bold).monospacedDigit())
                    .foregroundColor(.white)
                Text("kg")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                Spacer()
            }

            if let profile, profile.goal != "維持體重", let target = profile.targetWeightKG, let start = startWeight {
                // Progress bar
                progressBar(start: start, goal: target)

                // Estimated goal date
                if let goalDate = estimatedGoalDate {
                    HStack {
                        Text(AppStrings.Progress.estimatedGoalDate(mode))
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textTertiary)
                        Spacer()
                        Text(goalDate, style: .date)
                            .font(.system(size: 12, weight: .medium).monospacedDigit())
                            .foregroundColor(Theme.textSecondary)
                    }
                }
            } else if profile?.goal == "維持體重" {
                Text(AppStrings.Progress.maintaining(mode))
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.bgCard)
        )
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func progressBar(start: Double, goal: Double) -> some View {
        VStack(spacing: 8) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Theme.bgElevated)
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Theme.neonGreen)
                        .frame(width: max(0, geo.size.width * (goalFraction ?? 0)), height: 8)
                        .neonGlow(Theme.neonGreen, radius: 6)
                }
            }
            .frame(height: 8)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(AppStrings.Progress.startWeight(mode))
                        .font(.system(size: 10))
                        .foregroundColor(Theme.textTertiary)
                    Text(String(format: "%.1f kg", start))
                        .font(.system(size: 12, weight: .semibold).monospacedDigit())
                        .foregroundColor(Theme.textSecondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(AppStrings.Progress.goalWeight(mode))
                        .font(.system(size: 10))
                        .foregroundColor(Theme.textTertiary)
                    Text(String(format: "%.1f kg", goal))
                        .font(.system(size: 12, weight: .semibold).monospacedDigit())
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
    }

    // MARK: - Card 2: Weight Chart

    @ViewBuilder
    private var weightChartCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text(AppStrings.Progress.chartTitle(mode))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                Spacer()
                if goalFraction != nil {
                    HStack(spacing: 4) {
                        Image(systemName: "flag.fill")
                            .font(.system(size: 10))
                        Text(AppStrings.Progress.goalProgress(goalPercentage, mode))
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(Theme.neonGreen)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Theme.neonGreen.opacity(0.15))
                    )
                }
            }

            // Time range selector
            HStack(spacing: 0) {
                ForEach(ChartRange.allCases, id: \.self) { range in
                    Button(action: { withAnimation { chartRange = range } }) {
                        Text(range.rawValue)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(chartRange == range ? Color(hex: "#111111") : Theme.textSecondary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(chartRange == range ? Theme.neonGreen : Color.clear)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(3)
            .background(
                Capsule()
                    .fill(Theme.bgElevated)
            )

            // Chart or empty state
            if filteredEntries.count >= 2 {
                weightChart
                    .frame(height: 200)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 32))
                        .foregroundColor(Theme.textTertiary)
                    Text(AppStrings.Progress.chartEmpty(mode))
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textTertiary)
                        .multilineTextAlignment(.center)
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.bgCard)
        )
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private var weightChart: some View {
        let entries = filteredEntries
        let weights = entries.map(\.weightKG)
        let minW = (weights.min() ?? 50) - 1
        let maxW = (weights.max() ?? 80) + 1

        Chart {
            ForEach(entries, id: \.id) { entry in
                AreaMark(
                    x: .value("日期", entry.date),
                    yStart: .value("Min", minW),
                    yEnd: .value("體重", entry.weightKG)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Theme.neonGreen.opacity(0.3), Theme.neonGreen.opacity(0.0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)

                LineMark(
                    x: .value("日期", entry.date),
                    y: .value("體重", entry.weightKG)
                )
                .foregroundStyle(Theme.neonGreen)
                .lineStyle(StrokeStyle(lineWidth: 2))
                .interpolationMethod(.catmullRom)

                PointMark(
                    x: .value("日期", entry.date),
                    y: .value("體重", entry.weightKG)
                )
                .foregroundStyle(Theme.neonGreen)
                .symbolSize(24)
            }

            // Goal weight rule mark
            if let profile, profile.goal != "維持體重", let target = profile.targetWeightKG {
                RuleMark(y: .value("目標", target))
                    .foregroundStyle(Theme.neonAmber.opacity(0.6))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 3]))
                    .annotation(position: .top, alignment: .trailing) {
                        Text(AppStrings.Progress.goalLine(mode))
                            .font(.system(size: 10))
                            .foregroundColor(Theme.neonAmber)
                    }
            }
        }
        .chartYScale(domain: minW...maxW)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 5)) { _ in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(Theme.bgDivider)
                AxisValueLabel()
                    .foregroundStyle(Theme.textTertiary)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .automatic(desiredCount: 4)) { _ in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(Theme.bgDivider)
                AxisValueLabel()
                    .foregroundStyle(Theme.textTertiary)
            }
        }
    }

    // MARK: - Card 3: BMI

    @ViewBuilder
    private var bmiCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text(AppStrings.Progress.bmiTitle(mode))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                Spacer()
            }

            if let bmi {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(String(format: "%.1f", bmi))
                        .font(.system(size: 40, weight: .bold).monospacedDigit())
                        .foregroundColor(Theme.bmiColor(bmi))

                    Text(AppStrings.HeightWeight.bmiCategory(bmi, mode))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.bmiColor(bmi))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Theme.bmiColor(bmi).opacity(0.15))
                        )
                    Spacer()
                }

                // BMI segmented bar
                bmiBar(bmi: bmi)

                // Legend
                bmiLegend
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.bgCard)
        )
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func bmiBar(bmi: Double) -> some View {
        let segmentColors: [Color] = [
            Theme.neonBlue,   // <18.5
            Theme.neonGreen,  // 18.5–24
            Theme.neonAmber,  // 24–28
            Theme.neonRed,    // 28+
        ]
        let boundaries: [Double] = [0, 18.5, 24, 28, 40]

        GeometryReader { geo in
            let gap: CGFloat = 2
            let totalGaps = gap * CGFloat(segmentColors.count - 1)
            let segWidth = (geo.size.width - totalGaps) / CGFloat(segmentColors.count)

            ZStack(alignment: .leading) {
                HStack(spacing: gap) {
                    ForEach(0..<segmentColors.count, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(segmentColors[i])
                            .frame(height: 10)
                    }
                }

                // Position the dot in the correct segment
                let clamped = min(max(bmi, boundaries.first!), boundaries.last!)
                let position: CGFloat = {
                    for i in 0..<(boundaries.count - 1) {
                        let lo = boundaries[i]
                        let hi = boundaries[i + 1]
                        if clamped >= lo && clamped <= hi {
                            let fractionInSeg = (clamped - lo) / (hi - lo)
                            let segStart = CGFloat(i) * (segWidth + gap)
                            return segStart + segWidth * fractionInSeg
                        }
                    }
                    return 0
                }()

                Circle()
                    .fill(.white)
                    .frame(width: 16, height: 16)
                    .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
                    .offset(x: min(max(position - 8, 0), geo.size.width - 16))
            }
        }
        .frame(height: 16)
    }

    @ViewBuilder
    private var bmiLegend: some View {
        HStack(spacing: 0) {
            bmiLegendItem(color: Theme.neonBlue, label: AppStrings.Progress.bmiUnderweight(mode), range: "<18.5")
            Spacer()
            bmiLegendItem(color: Theme.neonGreen, label: AppStrings.Progress.bmiNormal(mode), range: "18.5-24")
            Spacer()
            bmiLegendItem(color: Theme.neonAmber, label: AppStrings.Progress.bmiOverweight(mode), range: "24-28")
            Spacer()
            bmiLegendItem(color: Theme.neonRed, label: AppStrings.Progress.bmiObese(mode), range: "28+")
        }
    }

    private func bmiLegendItem(color: Color, label: String, range: String) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
            VStack(alignment: .leading, spacing: 0) {
                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                Text(range)
                    .font(.system(size: 9).monospacedDigit())
                    .foregroundColor(Theme.textTertiary)
            }
        }
    }
}
