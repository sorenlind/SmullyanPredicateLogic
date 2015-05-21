//
//  PredicateLogic.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 06/05/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

import Foundation

/// The type of expression function used in the logic.
typealias LogicExpression = ( World, Dictionary<String, String>) -> Bool

/// A model checker for monadic predicate logic with identity.
class PredicateLogic: NSObject {
    
    // MARK: - Propositional logic
    
    /// Create a conditional (an 'if then') with `antecedent` and `consequent`.
    class func conditionalWithAntecedent(antecedent : LogicExpression, consequent: LogicExpression) -> LogicExpression {
        
        return { world, bound in return (!antecedent(world, bound)) || consequent(world, bound) }
    }

    /// Create function that negates the value returned by `operand`.
    class func negationWithOperand(operand : LogicExpression) -> LogicExpression {
        
        return { world, bound in return !operand(world, bound) }
    }
    
    /// Create a conjunction (a logical AND) using `left` and `rightConjunct`.
    class func conjunctionWithLeftConjunct(left : LogicExpression, rightConjunct right : LogicExpression) -> LogicExpression {
        
        return { world, bound in return left(world, bound) && right(world, bound) }
    }
    
    /// Create a disjunction (a logical OR) using `left` and `rightDisjunct`.
    class func disjunctionWithLeftDisjunct(left : LogicExpression, rightDisjunct right : LogicExpression) -> LogicExpression {
        
        return { world, bound in return left(world, bound) || right(world, bound) }
    }
    
    /// Create a proposition with name `propositionName`.
    class func propositionWithName(propositionName: String) -> LogicExpression {
        
        return { world, bound in return world.propositions.contains(propositionName) }
        
    }
    
    // MARK: - Quantifiers, predicates and variables
    
    /// Create a universal quantifier which binds `variableName` in `openExpression`.
    class func forAll(variableName: String, openExpression: LogicExpression) -> LogicExpression {
        
        return { world, boundVariables in
            
            for (agentName, _ ) in world.agents {
                
                if boundVariables[variableName] != nil {
                    // Variable has already been bound. We cannot compute an answer. For simplicity we return
                    // false.
                    return false
                }
                
                // Dictionaries are value types and so we can easily create a copy
                var tempBound = boundVariables
                tempBound[variableName] = agentName
                
                if !openExpression(world, tempBound) {
                    return false
                }
            }
            
            return true
        }
    }
    
    /// Create an existential quantifier which binds `variableName` in `openExpression`.
    class func exists(variableName: String, openExpression: LogicExpression) -> LogicExpression {
        
        return { world, boundVariables in
            
            if boundVariables[variableName] != nil {
                // Variable has already been bound. We cannot compute an answer. For simplicity we return
                // false.
                return false
            }
            
            for (agentName, _ ) in world.agents {
                
                var tempBound = boundVariables
                tempBound[variableName] = agentName
                
                if openExpression(world, tempBound) {
                    return true
                }
            }
            
            return false
        }
    }
    
    /// Create an open predicate expression `predicateName(variableName)`.
    class func predicateForVariable(variableName: String, predicateName: String) -> LogicExpression {
        
        return { world, bound in
            
            if let agentName = bound[variableName], agent = world.agents[agentName] {
                
                return agent.hasPredicate(predicateName)
            }
            
            // The variable was not bound or the agent was not found. For simplicity we return false.
            return false
        }
    }
    
    /// Create a predicate expression `predicateName(agentName)`.
    class func predicateForAgent(agentName: String, predicateName: String) -> LogicExpression {
        
        return { world, _ in
            if let agent = world.agents[agentName] {
                return agent.hasPredicate(predicateName)
            }
            
            return false
        }
    }
    
    /// Create an equality expression `leftVariableName == rightVariableName`.
    class func equalityWithLeftVariableName(leftVariableName : String, rightVariableName : String) -> LogicExpression {
        
        return { world, bound in
            
            if let agentNameLeft = bound[leftVariableName], agentNameRight = bound[rightVariableName] {
                
                return agentNameLeft == agentNameRight
            }
            
            // At least one of the variables was not bound. For simplicity we return false.
            return false
        }
    }
}
