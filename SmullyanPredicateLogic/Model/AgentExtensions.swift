//
//  AgentExtensions.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 24/04/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

extension Agent {
    
    /// True if and only if the agent is a truth-teller.
    var truthTeller : Bool {
        get { return self.predicates.contains(Agent.truthTellerFamily) }
    }
    
    /// The family name of `self`.
    var familyName : String {
        get { return self.truthTeller ? Agent.truthTellerFamily : Agent.liarFamily }
    }
    
    /// Return a value indicating whether `predicateName` is true for `self`.
    func hasPredicate(predicateName : String) -> Bool {
        return self.predicates.contains(predicateName)
    }

    /// A textual repressentation of `self`.
    override var description : String {
        get {
            let text = ", ".join(self.predicates.subtract([Agent.truthTellerFamily]))
            return "{\(self.name)} ({\(self.familyName)}): {\(text)}"
        }
    }
}