public struct ForEach<T>: Interaction {
    let data: [T]
    let buildComponent: (T) -> Renderable
    let separator: String

    public var body: some Renderable {
        Text(data.map { buildComponent($0).render() }.joined(separator: separator))
            .align(alignment: .leading)
    }

    public init(_ data: [T], separator: String = "\n", @InteractionBuilder _ buildComponent: @escaping (T) -> Renderable) {
        self.data = data
        self.separator = separator
        self.buildComponent = buildComponent
    }
}