//
//  World.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 16/04/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

import Foundation

class World: NSObject {
    
    let agents : Dictionary<String, Agent>
    
    init(agents : [Agent]) {
        
        var temp = Dictionary<String, Agent>()
        for agent in agents {
            temp[agent.name] = agent
        }
        
        self.agents = temp
    }
}
