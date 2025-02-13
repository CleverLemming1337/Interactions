//
//  Menu.swift
//  Interactions
//
//  Created by CleverLemming1337 on 16.10.24.
//

import Foundation
import Dependencies

public struct MenuOption {
    let name: String
    
    public init(name: String) {
        self.name = name
    }
}

public struct NavigationLink: Interaction, Activatable {
    let key: Key?
    let label: String
    let destination: any Renderable
    let title: String
    
    @LegacyEnvironment(\.settings) var settings
    @Environment(\.navigate) var navigate
    
    public func activate() {
        navigate(destination)
    }

    public var body: some Renderable {
        if key != nil {
            Button(key!, label) { [navigate] in
                navigate(destination)
            }
            .tint()
        }
        else {
            HStack {
                Text(label)
                    .align(width: AppRenderer.shared.terminalSize.0-6, alignment: .leading)
                Text("❯")
            }
        }
    }
    
    @available(*, deprecated, renamed: "init(key:label:destination:)", message: "Use init(key:label:destination:) instead.")
    public init(key: Key, name: String, title: String = "", @InteractionBuilder _ destination: () -> [Renderable]) {
        self.key = key
        self.label = name
        self.title = title
        self.destination = destination()
    }
    
    public init(key: Key? = nil, label: String, destination: any Scene) {
        self.key = key
        self.label = label
        self.title = destination.title
        self.destination = destination
    }

    public init(key: Key? = nil, _ label: String, @InteractionBuilder destination: () -> Renderable) {
        self.key = key
        self.label = label
        let destination = destination()
        self.title = (destination as? any Scene)?.title ?? ""
        self.destination = destination
    }
}

public struct NavigationStack: Interaction, @unchecked Sendable {
    @InternalState private var navigationPath: [Renderable]
    let content: Renderable

    public var body: some Renderable {
        if let last = navigationPath.last {
            last
                .environment(\.navigate, { navigationPath.append($0) })
        }
        else {
            content
                .environment(\.navigate, { navigationPath.append($0) })
        }
    }

    public init(@InteractionBuilder content: () -> Renderable, file: String = #file, line: Int = #line) {
        self.content = content()
        _navigationPath = InternalState<[Renderable]>(wrappedValue: [Renderable](), id: "\(file):\(line)")
    }
}

@available(*, deprecated, renamed: "NavigationLink", message: "Use NavigationLink instead")
public struct Navigation: Interaction {
    @LegacyEnvironment(\.keyBinder) var keyBinder
    @LegacyEnvironment(\.renderer) var renderer
    
    let options: [MenuOption]
    public var body: some Renderable {
        for (index, option) in options.prefix(9).enumerated() {
            Button(Key(rawValue: UInt16(index+49)) ?? .null, option.name) {
                renderInteraction {
                    Text("You chose: \(option.name)")
                }
                for index in 0..<options.count {
                    keyBinder.unbind(key: Key(rawValue: UInt16(index+49)) ?? .null)
                }
                renderer.renderApp()
            }
            .tint()
        }
        
    }
    
    public init(options: [MenuOption]) {
        self.options = options
    }
}

