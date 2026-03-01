//
//  SupabaseManager.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import Foundation
import Supabase

enum SupabaseConfig {
    static let url = URL(string: "https://zyiolqmdzbxdgixxashi.supabase.co")!
    static let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp5aW9scW1kemJ4ZGdpeHhhc2hpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIwMzAyMDksImV4cCI6MjA4NzYwNjIwOX0.4Foics9EvwlDg69Ljzd12Q812Wkzf4CJIc-hHclk5Mc"

    static let client = SupabaseClient(
        supabaseURL: url,
        supabaseKey: anonKey,
        options: SupabaseClientOptions(
            auth: .init(
                flowType: .pkce
            )
        )
    )
}
