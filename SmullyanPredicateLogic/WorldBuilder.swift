//
//  WorldBuilder.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 13/05/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

import Foundation

/// Machinery for building possible worlds.
class WorldBuilder: NSObject {
    
    /// Create all possible worlds that can be created using combinations of `propositions`, `agentNames` and `predicates`.
    class func worldsWithPropositions(propositions : [String], agentNames : [String], predicates : [String]) -> [World] {
        
        let predicateCombinations = combinations(predicates)
        let agentArrays = agentsWithNames(agentNames, predicateCombinations: predicateCombinations)
        
        let propositionCombinations = combinations(propositions)
        
        return propositionCombinations.flatMap({ propositionCombination -> [World] in
            
            return agentArrays.map({ agents -> World in
                
                return World(propositions: propositionCombination, agents: agents)
            })
        })
    }
    
    private class func agentsWithNames(agentNames : [String], predicateCombinations : [[String]], current : [[Agent]] = [[]]) -> [[Agent]] {
        
        if let head = agentNames.first {
            
            let headAgents = predicateCombinations.map({ predicates -> Agent in Agent(name: head, predicates: predicates)  })
            
            let next = headAgents.flatMap({ headAgent -> [[Agent]] in
                current.map({ innerAgentArray -> [Agent] in [headAgent] + innerAgentArray })
            })
            
            return agentsWithNames(Array(dropFirst(agentNames)), predicateCombinations: predicateCombinations, current: next)
        }
        
        return current
    }
    
    private class func combinations<T>(values : [T], current : [[T]] = [[]]) -> [[T]] {
        
        if let head = values.first {
            
            let headAdded = current.map({ x -> [T] in x + [head] })
            
            var tail = Array(dropFirst(values))
            return combinations(tail, current: headAdded + current)
        }
        
        return current
    }
}
