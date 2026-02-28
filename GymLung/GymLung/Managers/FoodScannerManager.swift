//
//  FoodScannerManager.swift
//  GymLung
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

    func scan(imageData: Data, toneMode: ToneMode = .normal, region: Region = .hk) async throws -> FoodScanResult {
        let compressedData = compressImage(imageData, maxDimension: 1024)
        let base64String = compressedData.base64EncodedString()

        let request = ScanFoodRequest(
            image_base64: base64String,
            meal_type: nil,
            tone_mode: toneMode.rawValue,
            region: region.rawValue
        )
        let result: FoodScanResult = try await SupabaseConfig.client.functions.invoke(
            "scan-food",
            options: FunctionInvokeOptions(body: request)
        )
        return result
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
