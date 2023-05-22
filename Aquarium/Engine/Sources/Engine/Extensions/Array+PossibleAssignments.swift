extension Array {
    /// Given an array of domains, where each domain is an array of values,
    /// returns an array of possible assignments.
    /// `e.g. domains = [[1, 2], [3, 4]]`
    /// `output = [[1, 3], [1, 4], [2, 3], [2, 4]]`
    static func possibleAssignments<T>(domains: [[T]]) -> [[T]] {
        if domains.count == 1 {
            return domains[0].map({ [$0] })
        }
        var subproblem = domains
        let lastDomain: [T] = subproblem.removeLast()
        let subproblemSolution: [[T]] = possibleAssignments(domains: subproblem)
        let output: [[T]] = lastDomain.flatMap({ domainValue in
            subproblemSolution.map({ $0 + [domainValue] })
        })
        return output
    }
}
