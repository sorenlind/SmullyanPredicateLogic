//
//  PredicateLogicExtensions.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 07/05/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

extension PredicateLogic {
    
    /// Create an expression asking agent with name `agentName` whether `question`.
    class func questionToAgentWithName(
        agentName: String,
        question : LogicExpression)
        -> LogicExpression {
            
            let truthTellerFunction = PredicateLogic.predicateForAgent(agentName, predicateName: Agent.truthTellerFamily)
            let questionFunction = PredicateLogic.biConditionalWithAntecedent(truthTellerFunction, consequent: question)
            
            return questionFunction
    }
    
    /// Create a bi-conditional (an 'if and only if then') with `antecedent` and `consequent`.
    class func biConditionalWithAntecedent(
        antecedent : (World, Dictionary<String, String>) -> Bool,
        consequent right : (World, Dictionary<String, String>) -> Bool)
        -> ((World, Dictionary<String, String>) -> Bool) {
            
            let function = { (world : World, bound : Dictionary<String, String>) -> Bool in
                return antecedent(world, bound) == right(world, bound)
            }
            
            return function
    }
    
    /// Create nested universal quantifiers which bind the `variableNames` in `openExpression`.
    class func forAll<S : SequenceType where S.Generator.Element == String>(
        variableNames: S,
        openExpression: (World, Dictionary<String, String>) -> Bool) ->
        ((World, Dictionary<String, String>) -> Bool) {
            
            var expression = openExpression
            
            for variableName in variableNames {
                expression = PredicateLogic.forAll(variableName, openExpression: expression)
            }
            
            return expression
    }
    
    /// Create an expression stating that `predicateName` is true for exactly one agent.
    class func exactlyOneAgentHasPredicate(predicateName : String) -> ((World, Dictionary<String, String>) -> Bool) {
        
        let x = "x"
        let y = "y"
        
        let predicateTrueForX = PredicateLogic.predicateForVariable(x, predicateName: predicateName)
        let predicateTrueForY = PredicateLogic.predicateForVariable(y, predicateName: predicateName)
        
        // (Ex Predicate(x))
        let agentWithPredicateExists = PredicateLogic.exists(x, openExpression: predicateTrueForX)
        
        // Predicate(x) & Predicate(y)
        let predicateTrueForXY = PredicateLogic.conjunctionWithLeftConjunct(predicateTrueForX, rightConjunct: predicateTrueForY)
        
        // x == y
        let variablesXYAreEqual = PredicateLogic.equalityWithLeftVariableName(x, rightVariableName: y)
        
        // Predicate(x) & Predicate(y) -> x == y
        let predicateTrueForXYImplieesXYEqual = PredicateLogic.conditionalWithAntecedent(predicateTrueForXY, consequent: variablesXYAreEqual)
        
        // (Ax (Ay Predicate(x) & Predicate(y) -> x == y ))
        let forAllXYPredicateTrueForXYImpliesXYEqual = PredicateLogic.forAll([x, y], openExpression: predicateTrueForXYImplieesXYEqual)
        
        // (Ex Predicate(x)) & (Ax (Ay Predicate(x) & Predicate(y) -> x == y ))
        let predicateTrueForExactlyOne = PredicateLogic.conjunctionWithLeftConjunct(
            agentWithPredicateExists,
            rightConjunct: forAllXYPredicateTrueForXYImpliesXYEqual)
        
        return predicateTrueForExactlyOne
    }
    
    /// Create an expression stating that `predicateName` is true for exactly `n` agents.
    class func exactlyNAgentsHavePredicate(predicateName : String, n : Int) -> ((World, Dictionary<String, String>) -> Bool) {
        
        let function = { (world : World, bound : Dictionary<String, String>) -> Bool in
            
            return world.agents.values.array.count({ ($0).hasPredicate("")}) == n
        }
        
        return function
    }
}