//
//  WorldExtensions.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 24/04/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

import Foundation

extension World {
    override var description : String {
        get {
            return "\n".join(self.agents.values.array.map{ $0.description })
        }
    }
}