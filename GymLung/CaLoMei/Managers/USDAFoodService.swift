//
//  USDAFoodService.swift
//  GymLung
//
//  Created by Chan Tin Lok on 27/2/2026.
//

import Foundation

// MARK: - Public Result Type

struct USDAFoodResult: Identifiable, Sendable {
    let id: Int
    let name: String
    let calories: Int
    let proteinG: Double
    let carbsG: Double
    let fatG: Double
    let servingSize: String // always "100g"
}

// MARK: - Errors

enum USDAError: Error {
    case keyFailed(Int)       // single key returned 403/429
    case allKeysFailed        // all keys exhausted
    case invalidResponse
    case httpError(Int)
}

// MARK: - Service Actor

actor USDAFoodService {
    static let shared = USDAFoodService()

    private let apiKeys: [String] = {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
              let keys = plist["USDA_API_KEYS"] as? [String] else {
            return []
        }
        return keys
    }()

    private let endpoint = URL(string: "https://api.nal.usda.gov/fdc/v1/foods/search")!
    private var currentKeyIndex = 0

    private init() {}

    // MARK: - Search

    func search(query: String) async throws -> [USDAFoodResult] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }

        for attempt in 0..<apiKeys.count {
            let keyIndex = (currentKeyIndex + attempt) % apiKeys.count
            let key = apiKeys[keyIndex]

            do {
                let results = try await performSearch(query: trimmed, apiKey: key)
                currentKeyIndex = keyIndex // stick with working key
                return results
            } catch USDAError.keyFailed {
                continue
            } catch {
                throw error
            }
        }

        throw USDAError.allKeysFailed
    }

    // MARK: - Private

    private func performSearch(query: String, apiKey: String) async throws -> [USDAFoodResult] {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")

        let body = SearchRequest(
            query: query,
            pageSize: 20,
            dataType: ["Foundation", "SR Legacy"]
        )
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw USDAError.invalidResponse
        }

        if http.statusCode == 403 || http.statusCode == 429 {
            throw USDAError.keyFailed(0)
        }

        guard (200...299).contains(http.statusCode) else {
            throw USDAError.httpError(http.statusCode)
        }

        let decoded = try JSONDecoder().decode(SearchResponse.self, from: data)
        return decoded.foods.compactMap { mapFood($0) }
    }

    private func mapFood(_ item: FoodItem) -> USDAFoodResult? {
        let nutrients = item.foodNutrients ?? []

        let calories = nutrientValue(nutrients, name: "Energy", unit: "KCAL")
        let protein = nutrientValue(nutrients, name: "Protein")
        let fat = nutrientValue(nutrients, name: "Total lipid (fat)")
        let carbs = nutrientValue(nutrients, name: "Carbohydrate, by difference")

        // Skip items with no calorie data
        guard calories > 0 else { return nil }

        return USDAFoodResult(
            id: item.fdcId,
            name: item.description,
            calories: Int(calories),
            proteinG: round(protein * 10) / 10,
            carbsG: round(carbs * 10) / 10,
            fatG: round(fat * 10) / 10,
            servingSize: "100g"
        )
    }

    private func nutrientValue(_ nutrients: [Nutrient], name: String, unit: String? = nil) -> Double {
        nutrients.first { n in
            n.nutrientName == name && (unit == nil || n.unitName?.uppercased() == unit?.uppercased())
        }?.value ?? 0
    }
}

// MARK: - DTOs (private)

private struct SearchRequest: Encodable {
    let query: String
    let pageSize: Int
    let dataType: [String]
}

private struct SearchResponse: Decodable {
    let foods: [FoodItem]
}

private struct FoodItem: Decodable {
    let fdcId: Int
    let description: String
    let foodNutrients: [Nutrient]?
}

private struct Nutrient: Decodable {
    let nutrientName: String?
    let value: Double?
    let unitName: String?
}
