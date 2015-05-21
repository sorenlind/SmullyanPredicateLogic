//
//  AgentExtensions.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 24/04/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

extension Agent {
    
    var truthTeller : Bool {
        get { return self.predicates.contains(Agent.truthTellerFamily) }
    }
    
    var familyName : String {
        get { return self.truthTeller ? Agent.truthTellerFamily : Agent.liarFamily }
    }
    
    func hasPredicate(predicateName : String) -> Bool {
        return self.predicates.contains(predicateName)
    }
    
    override var description : String {
        get {
            let text = ", ".join(self.predicates.subtract([Agent.truthTellerFamily]))
            return "{\(self.name)} ({\(self.familyName)}): {\(text)}"
        }
    }
}