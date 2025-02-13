//
//  File.swift
//  Interactions
//
//  Created by CleverLemming1337 on 31.10.24.
//

import Foundation

public struct Toggle: Interaction, Activatable {
    let label: String?
    let key: Key?
    @Binding var isOn: Bool
    
    @LegacyEnvironment(\.terminalSize) var terminalSize
    
    public var body: some Renderable {
        HStack(spacing: 0) {
            if label != nil {
                let width = terminalSize.0 < 30 ? Int(terminalSize.0) : 30
                Text(label!+String(repeating: " ", count: width-label!.count-7 < 0 ? 1 : (width-label!.count-7)))
            }
            if isOn {
                Text("\(key?.name ?? "", width: 5)")
                    .background(.green)
            }
            Text("  ")
                .reversed()
            if !isOn {
                Text("\(key?.name ?? "", width: 5, alignment: .center)")
                    .other("[100m", end: "[49m")
            }
        }
    }
    
    public init(label: String? = nil, key: Key? = nil, isOn: Binding<Bool>) {
        self.label = label
        self.key = key

        _isOn = isOn
        
        if key != nil {
            bindActivation(with: key!)
        }
    }

    public func activate() {
        self.isOn.toggle()
    }
}
