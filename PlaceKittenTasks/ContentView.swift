//
//  ContentView.swift
//  PlaceKittenTasks
//
//  Created by Hussein AlRyalat on 29/08/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        AllKittensView(kittensDataSource: DefaultKittensDataSource())
    }
}

#Preview {
    ContentView()
}
