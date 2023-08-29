//
//  View+ContextTask.swift
//  PlaceKittenTasks
//
//  Created by Hussein AlRyalat on 29/08/2023.
//

import SwiftUI

extension View {
    
    /**
     * This is what we're gonna use when executing throwing tasks, another flavor from using ContextView directly.
     */
    @_disfavoredOverload
    func task(_ task: @Sendable @escaping @MainActor () async throws -> Void) -> some View {
        ContextView(task: task) {
            self
        }
    }
}

/**
 *  A context view only displays the view when the task is executed successfuly.
 */
struct ContextView<Content, ContentView: View>: View {
    enum ContentState {
        case failure(Error)
        case loading
        case content(Content)
    }
    
    @State private var error: Error? = nil
    @State private var isLoading = false
    @State private var contentState: ContentState = .loading
    
    private var task: @Sendable () async throws -> Content
    private var contentView: ((Content) -> ContentView)
    
    init(task: @escaping @Sendable () async throws -> Content,
         contentView: @escaping ((Content) -> ContentView)) {
        self.task = task
        self.contentView = contentView
    }
    
    init(task: @escaping @Sendable () async throws -> Content,
         contentView: @escaping @autoclosure (() -> ContentView)) {
        self.task = task
        self.contentView = { _ in contentView() }
    }
    
    var body: some View {
        Group {
            view(for: contentState)
        }.task {
            do {
                let content = try await self.task()
                self.contentState = .content(content)
            } catch {
                self.contentState = .failure(error)
            }
        }
    }
    
    @ViewBuilder func view(for state: ContentState) -> some View {
        switch state {
        case .loading:
            ProgressView()
                .progressViewStyle(.circular)
        case .failure(let error):
            ContentUnavailableView(error.localizedDescription, systemImage: "cat.fill")
        case .content(let content):
            self.contentView(content)
        }
    }
    
    private func retryAgain() {
        contentState = .loading
        Task {
            do {
                let content = try await self.task()
                self.contentState = .content(content)
            } catch {
                self.contentState = .failure(error)
            }
        }
    }
}
