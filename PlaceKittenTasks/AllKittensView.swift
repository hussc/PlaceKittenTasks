//
//  KittensGridView.swift
//  PlaceKittenTasks
//
//  Created by Hussein AlRyalat on 29/08/2023.
//

import SwiftUI

struct AllKittensView: View {
    let kittensDataSource: KittensDataSourceProtocol
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2) // 2 columns
    
    // state indicators for the action
    @State private var error: Error?
    @State private var isLoading: Bool = false
    
    @State private var theAwesomeKitten: Kitten?
    @State private var kittens: [Kitten]?
    
    init(kittensDataSource: KittensDataSourceProtocol) {
        self.kittensDataSource = kittensDataSource
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if let kittens {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(kittens, id: \.self) { kitten in
                            KittenImage(kitten: kitten)
                        }
                    }
                    .padding()
                }
                
                Spacer(minLength: 100)
            }
            .overlay(alignment: .bottom) {
                VStack(alignment: .trailing, spacing: 4) {
                    HStack {
                        Spacer()
                        Button {
                            self.fetchAwesomeKitten()
                        } label: {
                            Group {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .tint(.white)
                                        .controlSize(.large)
                                } else {
                                    Image(systemName: "cat.fill")
                                }
                            }
                        }
                        .bold()
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle)
                        .tint(.red)
                        .controlSize(.large)
                    }

                    Text("Shows you one random awesome kitten")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background {
                    Rectangle()
                        .foregroundColor(Color(uiColor: .tertiarySystemBackground))
                        .ignoresSafeArea(edges: .all)
                }
            }
            .navigationTitle("Kittens")
            .sheet(item: $theAwesomeKitten, content: { kitten in
                NavigationStack {
                    KittenImage(kitten: kitten)
                        .navigationTitle("The Awesome Kitten!")
                        .presentationDetents([.medium])
                }
            })
            .errorAlert($error)
            .task {
                
                // here the task itself is throwing
                self.kittens = try await kittensDataSource.fetchKittens()
            }
        }
    }
    
    /**
     Frankly, idk how we can get rid of repeating common task behaviors like loading and error.
     */
    func fetchAwesomeKitten() {
        Task { @MainActor in
            isLoading = true
            do {
                theAwesomeKitten = try await kittensDataSource.fetchOneAwesomeKitten()
            } catch {
                self.error = error
            }
            
            isLoading = false
        }
    }
}

