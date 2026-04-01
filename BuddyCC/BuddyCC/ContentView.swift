//
//  ContentView.swift
//  BuddyCC
//
//  Created by 刘颖 on 2026/4/1.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = CompanionStore.shared

    var body: some View {
        NavigationStack {
            CompanionCardView(store: store)
                .navigationTitle("Buddy")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        if let companion = store.companion {
                            Text(renderFace(bones: companion.bones))
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(companion.rarity.color)
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
