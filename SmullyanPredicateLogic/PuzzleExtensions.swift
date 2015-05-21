//
//  PuzzleExtensions.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 11/05/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

extension Puzzle : Printable {
    
    /// Create an instance with all possible combinations of `propositions`, `agentNames` and `predicates`.
    static func puzzleWithPropositions(propositions : [String], agentNames : [String], predicates : [String]) -> Puzzle {
        
        let predicatesIncludingTruthTeller = [Agent.truthTellerFamily] + predicates
        
        let worlds = WorldBuilder.worldsWithPropositions(propositions, agentNames: agentNames, predicates: predicatesIncludingTruthTeller)
        
        return Puzzle(worlds: worlds)
    }
    
    /// Create an instance with all possible combinations of `agentNames` and `predicates`.
    static func puzzleWithAgentNames(agentNames : [String], predicates : [String])
        -> Puzzle {
            
            return Puzzle.puzzleWithPropositions([], agentNames: agentNames, predicates: predicates)
    }
    
    /// A textual representation of the puzzle.
    var description : String {
        get {
            
            var temp = "Number of possible worlds: \(self.count)\n\n"
            
            let propositionsTrueInAtLeastOneModel = Array(Set(self.worlds.flatMap({ Array($0.propositions) })))
            
            if (propositionsTrueInAtLeastOneModel.count > 0)
            {
                let propositionsTrueInAllModels = propositionsTrueInAtLeastOneModel.filter({ p -> Bool in self.worlds.all({ w -> Bool in w.propositions.contains(p) }) })
                temp += ", ".join(propositionsTrueInAllModels)
                temp += "\n\n"
                
            }
            
            let predicatesTrueForAtLeastOneAgentInAtLeastOneWorld =
            Array(Set(self.worlds.flatMap({ world -> [String] in world.agents.values.array.flatMap( { agent -> [String] in Array(agent.predicates) }) })))
            
            if let firstWorld = self.worlds.first {
                
                let agents = firstWorld.agents.values.array;
                
                for agent in agents.sorted({ $0.name < $1.name }) {
                    
                    let agentName = agent.name
                    let truthTellerWorldCount = self.worlds.count({ return $0.agents[agentName]!.truthTeller })
                    let family = (truthTellerWorldCount == self.worlds.count) ? Agent.truthTellerFamily : (truthTellerWorldCount == 0 ? Agent.liarFamily : Agent.unknownFamily)
                    
                    temp += "\(agentName) - \(family): "
                    
                    
                    let predicatesKnownTrueForAgent =
                    predicatesTrueForAtLeastOneAgentInAtLeastOneWorld.filter({ predicate -> Bool in
                        predicate != Agent.truthTellerFamily && self.worlds.all({ world -> Bool in
                            world.agents[agentName]!.hasPredicate(predicate)
                        })
                    })
                    
                    let predicatesKnownFalseForAgent =
                    predicatesTrueForAtLeastOneAgentInAtLeastOneWorld.filter({ predicate -> Bool in
                        predicate != Agent.truthTellerFamily && self.worlds.all({ world -> Bool in
                            !world.agents[agentName]!.hasPredicate(predicate)
                        })
                    }).map({ "Not " + $0})
                    
                    let predicatesKnown = (predicatesKnownTrueForAgent + predicatesKnownFalseForAgent)
                    
                    if (predicatesKnown.count == 0) {
                        temp += "\n"
                        continue
                    }
                    
                    temp += ", ".join(predicatesKnown)
                    temp += "\n"
                }
                
                return temp
            }
            
            return "No possible worlds."
            
        }
    }
}