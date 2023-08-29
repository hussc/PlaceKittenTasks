//
//  KittenView.swift
//  PlaceKittenTasks
//
//  Created by Hussein AlRyalat on 29/08/2023.
//

import SwiftUI

struct KittenImage: View {
    let kitten: Kitten

    var body: some View {
        AsyncImage(url: kitten.imageURL) { phase in
            switch phase {
            case .empty:
                ProgressView() // Placeholder until the image loads
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
            case .failure:
                Image(systemName: "xmark.icloud")
            @unknown default:
                EmptyView()
            }
        }
    }
}
