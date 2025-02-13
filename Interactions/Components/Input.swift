//
//  Input.swift
//  Interactions
//
//  Created by CleverLemming1337 on 15.10.24.
//

import Foundation

public struct Button: Interaction, Formattable, Activatable {
    public func activate() {
        action()
    }
    
    let key: Key?
    let label: String
    let action: () -> Void
    let showShortcut: Bool
    
    public init(_ key: Key, _ label: String, showShortcut: Bool = true, _ action: @escaping () -> Void) {
        self.key = key
        self.label = label
        self.action = action
        self.showShortcut = showShortcut
    }
    
    public init(_ label: String, _ action: @escaping () -> Void) {
        self.key = nil
        self.label = label
        self.action = action
        self.showShortcut = false
    }

    public func render() -> String {
        if let key = key {
            bindActivation(with: key)
        }

        return body.render()
    }
    
    public var body: some Renderable {
        if key != nil {
            HStack(spacing: 0) {
                if showShortcut {
                    Text(key!.name)
                        .padding()
                        .other("[100m", end: "[49m")
                    
                }
                Text("\(label)")
                    .padding()
                    .reversed()
            }
        }
        else {
            Text(label)
                .tint()
                .bold()
        }
    }
    
}

public struct TextField: Interaction, Formattable {
    let key: Key
    let label: String
    let placeholder: String
    let showShortcut: Bool
    @Binding var text: String
    
    @LegacyEnvironment(\.renderer) var renderer
    
    public func focus() {
        renderer.showCursor()
        var pressedKey = Key.null
        while pressedKey != .newLine {
            pressedKey = readKey()
            if pressedKey == .backspace {
                _ = text.popLast()
            }
            else if pressedKey != .newLine && pressedKey != .carriageReturn{
                text += pressedKey.string
            }
        }
        renderer.hideCursor()
    }
    
    public init(_ key: Key, _ label: String, placeholder: String, text: Binding<String>, showShortcut: Bool = true) {
        self.key = key
        self.label = label
        self.placeholder = placeholder
        self.showShortcut = showShortcut
        _text = text
        
        @LegacyEnvironment(\.keyBinder) var keyBinder
        
        keyBinder.bind(with: key, to: focus)
    }
    
    public var body: some Renderable {
        HStack(spacing: 0) {
            Text(label)
                .padding()
                .reversed()
            if showShortcut {
                Text(key.name)
                    .padding()
                    .other("[100m", end: "[49m")
            }
            if text.count > 0 {
                Text(text)
                    .padding()
                    .reversed()
                    .tint()
            }
            else {
                Text(placeholder)
                    .padding()
                    .dark()
                    .reversed()
                    .tint()
            }
            
        }
    }
}

struct Test: Interaction {
    @State private var count = 0
    
    var body: some Renderable {
        TestB(count: $count)
        TestC(count: $count)
    }
}

struct TestB: Interaction {
    @Binding var count: Int
    
    var body: some Renderable {
        Text("\(count)")
    }
}

struct TestC: Interaction {
    @Binding var count: Int
    
    var body: some Renderable {
        Text("\(count)")
    }
    
    init(count: Binding<Int>) {
        self._count = count
    }
}


