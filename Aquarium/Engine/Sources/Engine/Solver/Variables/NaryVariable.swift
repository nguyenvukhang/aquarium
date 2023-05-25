/**
 A variable which represents N variables at once.
 This uses Hidden Variable Encoding to convert N-ary constraints to Unary constraints.
 */
/*
protocol NaryVariable: Variable {
    associatedtype ValueType = NaryVariableDomainValue
    
    var associatedVariables: [any Variable] { get set }
}
 */

/*
class NaryVariable: Variable {
    var name: String
    var domainUndoStack: Stack<Set<NaryVariableDomainValue>>
    var constraints: [any Constraint]
    var associatedVariables: [any Variable]
    
    init(name: String, associatedVariables: [any Variable]) {
        self.name = name
        self.domainUndoStack = Stack()
        self.constraints = []
        self.associatedVariables = associatedVariables
    }
}

extension NaryVariable {
    /// Get: Returns all possible assignment scenarios for all variables in
    /// `associatedVariables`.
    /// Set: Infers the domains for each of the `associatedVariables` and
    /// sets all of their domains.
    var domain: Set<NaryVariableDomainValue> {
        get {
            // if any associated domain is empty, no possible domain values
            guard associatedDomains.allSatisfy({ $0.count > 0 }) else {
                return Set()
            }
            let permutations = Array<any Value>.possibleAssignments(domains: associatedDomains)
            let naryVariableDomainValues = permutations.map({ NaryVariableDomainValue(value: $0) })
            return Set(naryVariableDomainValues)
        }
        set {
            guard newValue.count == associatedVariables.count else {
                // TODO: throw error
                assert(false)
            }
            let associatedVariableDomains = getAssociatedVariableDomains(using: newValue)
            guard checkAssociatedVariableDomains(domains: associatedVariableDomains) else {
                // TODO: throw error
                assert(false)
            }
            setAssociatedDomains(associatedVariableDomains)
        }
    }
    
    /// Get: collects all the assignments from `associatedVariables` and returns them.
    /// Set: also sets assignments for all `associatedVariables`
    var assignment: NaryVariableDomainValue? {
        get {
            // if there are any unassigned associated variables,
            // this NaryVariable is not considered assigned
            if associatedVariables.contains(where: { !$0.isAssigned }) {
                return nil
            }
            let assignments: [any Value] = associatedVariables.compactMap({ $0.assignmentAsAnyValue })
            assert(assignments.count == associatedVariables.count)
            return NaryVariableDomainValue(value: assignments)
        }
        set {
            guard let unwrappedNewValue = newValue else {
                return
            }
            guard unwrappedNewValue.value.count == associatedVariables.count else {
                // TODO: throw error
                assert(false)
            }
            for idx in 0 ..< associatedVariables.count {
                guard associatedVariables[idx].assign(to: unwrappedNewValue.value[idx]) else {
                    // TODO: throw error
                    assert(false)
                }
            }
        }
    }
    
    /// Returns an array of domains for each variable in `associatedVariables` where
    /// the order of the domains matches the order in `associatedVariables`.
    var associatedDomains: [[any Value]] {
        associatedVariables.map({ $0.domainAsArray })
    }
    
    /// Given a set of `possibleAssignments`, looks at each associated variable
    /// and retrieves all its possible domain values.
    private func getAssociatedVariableDomains(using possibleAssignments: Set<NaryVariableDomainValue>) -> [[any Value]] {
        Array(0 ..< associatedVariables.count).map({ idx in
            possibleAssignments.map({ $0.value[idx] })
        })
    }
    
    /// Checks that all new domains are subsets of the respective variable's original domain.
    private func checkAssociatedVariableDomains(domains: [[any Value]]) -> Bool {
        Array(0 ..< associatedVariables.count).allSatisfy({ idx in
            associatedVariables[idx].canSetDomain(newDomain: domains[idx])
        })
    }
    
    ///
    private func setAssociatedDomains(_ associatedDomains: [[any Value]]) {
        var idx = 0
        for variable in associatedVariables {
            setNewDomain(for: variable, to: associatedDomains[idx])
        }
    }
    
    private func setNewDomain(for variable: some Variable, to newDomain: [any Value]) {
        let valueTypeSet = variable.createValueTypeSet(from: newDomain)
        variable.domain = valueTypeSet
    }
}
*/