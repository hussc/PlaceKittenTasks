//
//  View+ActionTask.swift
//  PlaceKittenTasks
//
//  Created by Hussein AlRyalat on 29/08/2023.
//

import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    @Binding var error: Error?
    @State var isPresented: Bool = false
    
    func body(content: Content) -> some View {
        content.alert(error?.localizedDescription ?? "", isPresented: Binding(get: {
            self.error != nil
        }, set: { value in
            error = nil
        })) {
            Button("OK", action: { })
        } message: {
            Text("Something went wrong")
        }

    }
    
    init(error: Binding<Error?>) {
        self._error = error
    }
}

struct RefreshableThrowingView: ViewModifier {
    @State private var error: Error?
    let refresh: @Sendable () async throws -> Void
    
    func body(content: Content) -> some View {
        content.refreshable {
            do {
                try await self.refresh()
            } catch {
                self.error = error
            }
        }.errorAlert($error)
    }
}

extension View {
    func errorAlert(_ binding: Binding<Error?>) -> some View {
        self.modifier(ErrorAlertModifier(error: binding))
    }
    
    func errorAlert(_ error: Error?) -> some View {
        self.errorAlert(.constant(error))
    }
}


extension View {
    @_disfavoredOverload
    func refreshable(_ task: @Sendable @escaping @MainActor () async throws -> Void) -> some View {
        self.modifier(RefreshableThrowingView(refresh: task))
    }
}
