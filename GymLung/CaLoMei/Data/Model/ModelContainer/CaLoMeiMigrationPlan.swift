//
//  CaLoMeiMigrationPlan.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 28/2/2026.
//

import SwiftData

enum CaLoMeiMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] = [
        SchemaV1.self,
    ]

    static var stages: [MigrationStage] = []
}
