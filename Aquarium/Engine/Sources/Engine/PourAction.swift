public struct PourAction {
    let state: State
    let flow: [Point]
    let alt: [Point]

    var startPoint: Point { flow.first! }

    init(_ state: State, flow: [Point], alt: [Point] = []) {
        self.state = state
        self.flow = flow
        self.alt = alt
    }
}
