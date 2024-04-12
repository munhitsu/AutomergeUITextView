//
//  ContentView.swift
//  AutomergeUITextView
//
//  Created by Mateusz Łapsa-Malawski on 12/04/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var documentTS = DocumentTextStorage(string: "Hello World")
    var documentCachingTS = DocumentCachingTextStorage(string: "Hello World")
    var proxyTS = ProxyTextStorage(string: "Hello World")
    var nativeTS = NSTextStorage(string: "Hello World")

    var body: some View {
        TabView {
            VStack {
                Text("NSTextStorage")
                DocumentTextView(textStorage: nativeTS)
            }
            .tabItem { Label("Native", systemImage: "cpu") }
            VStack {
                Text("Proxy to NSTextStorage")
                DocumentTextView(textStorage: proxyTS)
            }
            .tabItem { Label("Proxy", systemImage: "cpu.fill") }
            VStack {
                Text("Automerge Document")
                DocumentTextView(textStorage: documentTS)
            }
            .tabItem { Label("document", systemImage: "arrow.left.arrow.right") }
            VStack {
                Text("Automerge Document Cached")
                DocumentTextView(textStorage: documentCachingTS)
            }
            .tabItem { Label("cached", systemImage: "memorychip") }

        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
