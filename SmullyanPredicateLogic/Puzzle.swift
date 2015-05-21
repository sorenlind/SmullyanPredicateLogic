//
//  Puzzle.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 11/05/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

import Foundation

/// A collection of worlds which can be filtered by applying knowledge from a puzzle text.
struct Puzzle {
    
    /// The number of possible worlds in the puzzle.
    var count : Int { get { return self.worlds.count } }
    
    /// The possible worlds.
    private(set) var worlds : [World]
    
    /// Create an instance containing `worlds`.
    init(worlds: [World]) {
        self.worlds = worlds
    }
    
    /// Apply a filter by throwing away all worlds in which the specified filter expression is not true.
    mutating func applyExpressionFilter(filter : LogicExpression) {
        
        let boundFilter = { (world : World) -> Bool in
            return filter(world, [:])
        }
        
        self.worlds = self.worlds.filter(boundFilter)
    }
    
    /// Apply a filter by asking the agent with name `agentName` whether `question` is true. Remove all worlds in which the agent does
    /// not provide the answer 'true'.
    mutating func applyQuestionFilter(
        question : LogicExpression,
        agentName : String) {
            
            let questionToAgentInWorld = PredicateLogic.questionToAgentWithName(agentName, question: question)
            
            self.applyExpressionFilter(questionToAgentInWorld)
    }
    
    /// For each element `x` of `statements` temporarily apply a filter which requires that agent with name `agentName` would state `x`.
    /// If applying the filter makes the value of all elements in `checkExpressions` known, then permanently apply the filter and return.
    /// If none of the filters make all elements in `checkExpressions` known, remove all possible worlds.
    mutating func applyMetaPuzzleFilterStatements(
        statements : [LogicExpression],
        agentName : String,
        checkExpressions : [LogicExpression]) {
            
            self.worlds = self.calculateWorldsFromMetaPuzzleStatements(
                statements,
                agentName: agentName,
                checkExpressions: checkExpressions)
    }
    

    /// Query `self` for the value of `expression` over all worlds. Returns 'true' if `expression` is
    /// `true` in all worlds. Returns `false` if the expression is `false` in all worlds. Return `nil` otherwise.
    func query(expression : LogicExpression) -> Bool? {
        
        if self.expressionValueConstantOverAllWorlds(expression) {
            return expression(self.worlds[0], [:])
        }
        
        return nil
    }
    
    private func expressionValueConstantOverAllWorlds(expression : LogicExpression) -> Bool {
        
        let valueOfFirst = expression(self.worlds[0], [:])
        
        return self.worlds.all({ world -> Bool in expression(world, [:]) == valueOfFirst})
    }
    
    private func calculateWorldsFromMetaPuzzleStatements(
        statements : [LogicExpression],
        agentName : String,
        checkExpressions : [LogicExpression])
        -> [World] {
            
            for statement in statements {
                if let tempWorlds = self.filteredWorldsFromMetaPuzzleStatement(
                    statement,
                    agentName: agentName,
                    checkExpressions: checkExpressions) {
                        return tempWorlds
                }
            }
            
            return []
    }
    
    private func filteredWorldsFromMetaPuzzleStatement(
        statement : LogicExpression,
        agentName : String,
        checkExpressions : [LogicExpression])
        -> [World]? {
            
            var tempPuzzle = self
            tempPuzzle.applyQuestionFilter(statement, agentName: agentName)
            
            if tempPuzzle.count == 0 || !tempPuzzle.valueKnownForExpressions(checkExpressions) {
                // No possible worlds or not a constant value of at least one of the check expressions
                return nil
            }
            
            return tempPuzzle.worlds
    }
    
    private func valueKnownForExpressions(expressions : [LogicExpression]) -> Bool {
        
        return expressions.all({ expression -> Bool in
            
            self.expressionValueConstantOverAllWorlds(expression)
            
        })
    }
}