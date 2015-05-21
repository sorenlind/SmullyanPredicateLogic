//
//  Agent.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 16/04/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

import Foundation

class Agent: NSObject {
    
    static let truthTellerFamily = "Mazdaysian"
    static let liarFamily = "Aharmanite"
    static let unknownFamily = "Unknown"
    
    let name : String
    let predicates : Set<String>
    
    init(name : String, predicates : [String]) {
        self.name = name
        self.predicates = Set<String>(predicates)
    }
}
