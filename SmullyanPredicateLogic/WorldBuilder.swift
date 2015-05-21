//
//  WorldBuilder.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 13/05/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

import Foundation

class WorldBuilder: NSObject {
    
    class func worldsWithAgentNames(agentNames : [String], predicates : [String])
        -> [World] {
            
            let predicateCombinations = combinations(predicates)
            let agentArrays = agentsWithNames(
                agentNames,
                predicateCombinations: predicateCombinations)
            
            return agentArrays.map({ agents -> World in World(agents: agents) })
    }
    
    class func agentsWithNames(
        agentNames : [String],
        predicateCombinations : [[String]],
        current : [[Agent]] = [[]])
        -> [[Agent]] {
            
            if let head = agentNames.first {
                
                let headAgents = predicateCombinations.map({
                    predicates -> Agent in Agent(name: head, predicates: predicates)
                })
                
                let next = headAgents.flatMap({ headAgent -> [[Agent]] in
                    current.map({ innerAgentArray -> [Agent] in
                        [headAgent] + innerAgentArray })
                })
                
                return agentsWithNames(
                    Array(dropFirst(agentNames)),
                    predicateCombinations: predicateCombinations,
                    current: next)
            }
            
            return current
    }
    
    class func combinations<T>(values : [T], current : [[T]] = [[]]) -> [[T]] {
        
        if let head = values.first {
            
            let headAdded = current.map({ x -> [T] in x + [head] })
            var tail = Array(dropFirst(values))
            
            return combinations(tail, current: headAdded + current)
        }
        
        return current
    }
}