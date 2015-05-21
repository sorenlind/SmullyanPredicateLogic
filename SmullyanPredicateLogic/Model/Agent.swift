//
//  Agent.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 16/04/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

import Foundation

/// An agent with a name, family and predicates. 
class Agent: NSObject {
    
    /// The name of the family whose members always tell the truth.
    static let truthTellerFamily = "Mazdaysian"
    
    /// The name of the family whose members always lie.
    static let liarFamily = "Aharmanite"
    
    /// A value indicating an agent's family is unknown.
    static let unknownFamily = "Unknown"
    
    /// The name of the agent.
    let name : String
    
    // The predicates that are true for the agent.
    let predicates : Set<String>
    
    // Create an instance with `name` as its name and `predicates` as its predicates.
    init(name : String, predicates : [String]) {
        self.name = name
        self.predicates = Set<String>(predicates)
    }
}
