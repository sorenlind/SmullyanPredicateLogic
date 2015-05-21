//
//  WorldExtensions.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 24/04/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

extension World {
    
    /// A textual representation of `self`.
    override var description : String {
        get {
            let joinedProposition = ", ".join(self.propositions)
            let joinedAgents = "\n".join(self.agents.values.array.map{ $0.description })
            
            return "Proposition: \(joinedProposition)\n\(joinedAgents)"
        }
    }
}