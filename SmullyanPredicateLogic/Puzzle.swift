//
//  Puzzle.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 11/05/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

import Foundation

struct Puzzle {
    
    var count : Int { get { return self.worlds.count } }
    
    private(set) var worlds : [World]
    
    init(worlds: [World]) {
        self.worlds = worlds
    }
    
    mutating func applyExpressionFilter(filter : LogicExpression) {
        
        self.worlds = self.worlds.filter(filter)
    }
    
    mutating func applyQuestionFilter(
        question : LogicExpression,
        agentName : String) {
            
            let questionToAgentInWorld = PredicateLogic.questionToAgentWithName(
                agentName,
                question: question)
            
            self.applyExpressionFilter(questionToAgentInWorld)
    }
    
    mutating func applyMetaPuzzleFilterStatements(
        statements : [LogicExpression],
        agentName : String,
        checkExpressions : [LogicExpression]) {
            
            self.worlds = self.calculateWorldsFromMetaPuzzleStatements(
                statements,
                agentName: agentName,
                checkExpressions: checkExpressions)
    }
    
    func query(expression : LogicExpression) -> Bool? {
        
        if self.expressionValueConstantOverAllWorlds(expression) {
            return expression(self.worlds[0])
        }
        
        return nil
    }
    
    private func expressionValueConstantOverAllWorlds(expression : LogicExpression) -> Bool {
        
        let valueOfFirst = expression(self.worlds[0])
        
        return self.worlds.all({ world -> Bool in expression(world) == valueOfFirst})
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
            
            // We can easily create a copy because Puzzle is a struct
            var tempPuzzle = self
            tempPuzzle.applyQuestionFilter(statement, agentName: agentName)
            
            if tempPuzzle.count == 0 ||
                !tempPuzzle.valueKnownForExpressions(checkExpressions) {
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