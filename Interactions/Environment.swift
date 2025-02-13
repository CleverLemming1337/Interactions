//
//  Environment.swift
//  Interactions
//
//  Created by CleverLemming1337 on 16.10.24.
//

import Foundation
import Dependencies

public typealias Environment = Dependency

public extension DependencyValues {
    var accentColor: Color {
        get { self[AccentColorKey.self] }
        set { self[AccentColorKey.self] = newValue }
    }
    
    var dismiss: Hook {
        get { self[DismissKey.self] }
        set { self[DismissKey.self] = newValue }
    }

    var navigate: @Sendable (Renderable) -> Void {
        get { self[NavigateKey.self] }
        set { self[NavigateKey.self] = newValue }
    }
}

private enum AccentColorKey: DependencyKey {
    static let liveValue: Color = .cyan
    static let testValue: Color = .red
}

private enum DismissKey: DependencyKey {
    static let liveValue: Hook = { AppRenderer.shared.back() }
    static let testValue: Hook = { AppRenderer.shared.back() }
}

private enum NavigateKey: DependencyKey {
    static let liveValue: @Sendable (Renderable) -> Void = { AppRenderer.shared.setScene($0) }
    static let testValue: @Sendable (Renderable) -> Void = { AppRenderer.shared.setScene($0) }
}

public extension Renderable {
    func environment<T>(_ path: WritableKeyPath<DependencyValues, T>, _ value: T) -> some Renderable {
        DependencyWrapper(content: self) {
            $0[keyPath: path] = value
        }
    }
}

private struct DependencyWrapper<Content: Renderable>: Renderable {
    let content: Content
    let modify: (inout DependencyValues) -> Void
    
    func render() -> String {
        withDependencies {
            modify(&$0)
        } operation: {
            content.render()
        }
    }
}

public typealias Hook = @Sendable () -> Void
