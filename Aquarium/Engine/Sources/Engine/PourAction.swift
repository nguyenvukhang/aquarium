public struct PourAction {
    let state: State
    let flow: [Point]

    var startPoint: Point { flow.first! }

    init(_ state: State, flow: [Point]) {
        self.state = state
        self.flow = flow
    }
}
