//
//  World.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 16/04/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

import Foundation

/// A configuration of propositions and agents.
class World: NSObject {
    
    /// The propositions that are true in the world.
    let propositions : Set<String>
    
    /// The agents in the world.
    let agents : Dictionary<String, Agent>
    
    /// Create an instance in which all elements of `propositions` are true and which contains the elements of `agents`.
    init(propositions: [String], agents : [Agent]) {
        
        self.propositions = Set(propositions)
        
        var temp = Dictionary<String, Agent>()
        for agent in agents {
            temp[agent.name] = agent
        }
        
        self.agents = temp
    }
}
