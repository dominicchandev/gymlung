//
//  FoodScannerManager.swift
//  CaLoMei
//
//  Created by Claude on 26/2/2026.
//

import SwiftUI
import PhotosUI
import Supabase

struct ScannedFoodItem: Decodable, Identifiable {
    var id: String { name_zh + name_en }
    let name_zh: String
    let name_en: String
    let estimated_calories: Int
    let protein_g: Double
    let carbs_g: Double
    let fat_g: Double
    let portion_description: String
    let confidence: Double
}

struct FoodScanResult: Decodable {
    let food_items: [ScannedFoodItem]
    let total_calories: Int
    let roast_comment: String
}

struct ScanFoodRequest: Encodable {
    let image_base64: String
    let meal_type: String?
    let tone_mode: String?
    let region: String?
}

@MainActor
class FoodScannerManager {

    private let TAG = "[FoodScanner]"

    func scan(imageData: Data, toneMode: ToneMode = .normal, region: Region = .hk) async throws -> FoodScanResult {
        // Check Supabase auth session
        do {
            let session = try await SupabaseConfig.client.auth.session
            let expiresAt = Date(timeIntervalSince1970: TimeInterval(session.expiresAt))
            let isExpired = expiresAt < Date()
            debugPrint("\(TAG) Session found — user: \(session.user.id), email: \(session.user.email ?? "nil")")
            debugPrint("\(TAG) Token expires: \(expiresAt), isExpired: \(isExpired)")
            debugPrint("\(TAG) Access token (first 20 chars): \(String(session.accessToken.prefix(20)))...")
        } catch {
            debugPrint("\(TAG) ⚠️ No active session — error: \(error.localizedDescription)")
        }

        let compressedData = compressImage(imageData, maxDimension: 1024)
        debugPrint("\(TAG) Image compressed: \(imageData.count) → \(compressedData.count) bytes")
        let base64String = compressedData.base64EncodedString()

        let request = ScanFoodRequest(
            image_base64: base64String,
            meal_type: nil,
            tone_mode: toneMode.rawValue,
            region: region.rawValue
        )
        debugPrint("\(TAG) Calling scan-food — tone: \(toneMode.rawValue), region: \(region.rawValue)")

        do {
            let result: FoodScanResult = try await SupabaseConfig.client.functions.invoke(
                "scan-food",
                options: FunctionInvokeOptions(body: request)
            )
            debugPrint("\(TAG) ✅ Scan success — \(result.food_items.count) items, \(result.total_calories) kcal")
            debugPrint("\(TAG) Roast: \(result.roast_comment)")
            return result
        } catch {
            debugPrint("\(TAG) ❌ Scan failed — \(error)")
            throw error
        }
    }

    private func compressImage(_ data: Data, maxDimension: CGFloat) -> Data {
        guard let uiImage = UIImage(data: data) else { return data }

        let size = uiImage.size
        let scale: CGFloat
        if size.width > size.height {
            scale = min(1.0, maxDimension / size.width)
        } else {
            scale = min(1.0, maxDimension / size.height)
        }

        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resized = renderer.image { _ in
            uiImage.draw(in: CGRect(origin: .zero, size: newSize))
        }

        return resized.jpegData(compressionQuality: 0.7) ?? data
    }
}
