//
//  PredicateLogic.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 06/05/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

import Foundation

typealias LogicExpression = World -> Bool

class PredicateLogic : NSObject {
    
    class func negationWithOperand(operand : LogicExpression) -> LogicExpression {
        
        return { world in return !operand(world) }
    }
    
    class func conjunctionWithLeftConjunct(
        left : LogicExpression,
        rightConjunct right : LogicExpression)
        -> LogicExpression {
            
            return { world in return left(world) && right(world) }
    }
    
    class func disjunctionWithLeftDisjunct(left : LogicExpression, rightDisjunct right : LogicExpression) -> LogicExpression {
        
        return { world in return left(world) || right(world) }
    }
    
    class func predicateForAgent(
        agentName: String,
        predicateName: String)
        -> LogicExpression {
            
            return { world in
                if let agent = world.agents[agentName] {
                    return agent.hasPredicate(predicateName)
                }
                
                return false
            }
    }
    
    class func biConditionalWithAntecedent(
        left : LogicExpression, consequent right : LogicExpression) -> LogicExpression {
            
            return { world in return left(world) == right(world) }
    }
}

