//
//  PuzzleExtensions.swift
//  TinySmullyan
//
//  Created by Søren Lind Kristiansen on 11/05/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

extension Puzzle : Printable {
    
    static func puzzleWithAgentNames(agentNames : [String], predicates : [String])
        -> Puzzle {
        
        let predicatesIncludingTruthTeller = [Agent.truthTellerFamily] + predicates
        
        let worlds = WorldBuilder.worldsWithAgentNames(
            agentNames,
            predicates: predicatesIncludingTruthTeller)
        
        return Puzzle(worlds: worlds)
    }
    
    var description : String {
        get {
            
            var text = "Number of possible worlds: \(self.worlds.count)\n\n"
            
            let predicatesTrueForAtLeastOneAgentInAtLeastOneWorld =
            Array(Set(self.worlds.flatMap({ world -> [String] in
                world.agents.values.array.flatMap( { agent -> [String] in
                    Array(agent.predicates)
                })
            })))
            
            for agentName in self.worlds.first!.agents.values.map({ $0.name }) {
                
                let truthTellerWorldCount = self.worlds.filter({
                    $0.agents[agentName]!.truthTeller
                }).count
                
                let family = (truthTellerWorldCount == self.worlds.count) ?
                    Agent.truthTellerFamily :
                    (truthTellerWorldCount == 0 ? Agent.liarFamily : Agent.unknownFamily)
                
                text += "\(agentName) - \(family): "
                
                let predicatesKnownTrueForAgent =
                predicatesTrueForAtLeastOneAgentInAtLeastOneWorld.filter({
                    predicate -> Bool in
                    predicate != Agent.truthTellerFamily && self.worlds.all({
                        world -> Bool in
                        world.agents[agentName]!.hasPredicate(predicate)
                    })
                })
                
                let predicatesKnownFalseForAgent =
                predicatesTrueForAtLeastOneAgentInAtLeastOneWorld.filter({
                    predicate -> Bool in
                    predicate != Agent.truthTellerFamily && self.worlds.all({
                        world -> Bool in
                        !world.agents[agentName]!.hasPredicate(predicate)
                    })
                }).map({ "Not " + $0})
                
                let known = predicatesKnownTrueForAgent + predicatesKnownFalseForAgent
                if (known.count == 0) {
                    text += "\n"
                    continue
                }
                
                text += ", ".join(known)
                text += "\n"
            }
            
            return text
        }
    }
}