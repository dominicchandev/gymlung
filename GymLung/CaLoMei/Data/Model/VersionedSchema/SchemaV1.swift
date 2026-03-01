//
//  SchemaV1.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 28/2/2026.
//

import SwiftData

enum SchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] = [
        UserProfile.self,
        FoodEntry.self,
        WeightEntry.self,
    ]
}
