//
//  PuzzleBook.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 15/05/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

import Foundation

class PuzzleBook: NSObject {
    
    class func puzzle76() {
        
        let agentNameA = "Bahman"
        let agentNameB = "Perviz"
        
        let married = "Married"
        
        var puzzle = Puzzle.puzzleWithAgentNames(
            [agentNameA, agentNameB],
            predicates: [married])
        
        println("Initial Puzzle State:")
        println(puzzle)
        
        // Add knowledge that A and B are of the same family.
        let expATruthTeller = PredicateLogic.predicateForAgent(agentNameA, predicateName: Agent.truthTellerFamily)
        let expBTruthTeller = PredicateLogic.predicateForAgent(agentNameB, predicateName: Agent.truthTellerFamily)
        let expSameFamily = PredicateLogic.biConditionalWithAntecedent(expATruthTeller, consequent: expBTruthTeller)
        puzzle.applyExpressionFilter(expSameFamily)
        
        // Add knowledge that A says A and B are married.
        let expMarriedA = PredicateLogic.predicateForAgent(agentNameA, predicateName: married)
        let expMarriedB = PredicateLogic.predicateForAgent(agentNameB, predicateName: married)
        let expMarriedAandB = PredicateLogic.conjunctionWithLeftConjunct(expMarriedA, rightConjunct: expMarriedB)
        puzzle.applyQuestionFilter(expMarriedAandB, agentName: agentNameA)
        
        // Add knowledige that B says he is not married.
        let expNotMarriedB = PredicateLogic.negationWithOperand(expMarriedB)
        puzzle.applyQuestionFilter(expNotMarriedB, agentName: agentNameB)
        
        println("State After Solving The Puzzle:")
        println(puzzle)
    }
    
    class func puzzle77() {
        
        let agentNameA = "Bahman"
        let agentNameB = "Perviz"
        let agentNames = [agentNameA, agentNameB]
        
        let married = "Married"
        let predicateNames = [married]
        
        var puzzle = Puzzle.puzzleWithAgentNames(agentNames, predicates: predicateNames)
        
        // Add knowledge that A and B are of the same family.
        let expATruthTeller = PredicateLogic.predicateForAgent(agentNameA, predicateName: Agent.truthTellerFamily)
        let expBTruthTeller = PredicateLogic.predicateForAgent(agentNameB, predicateName: Agent.truthTellerFamily)
        let expSameFamily = PredicateLogic.biConditionalWithAntecedent(expATruthTeller, consequent: expBTruthTeller)
        puzzle.applyExpressionFilter(expSameFamily)
        
        // Add knowledge that A says A and B are both married or they are both unmarried. That is, they have same marital status.
        let expMarriedA = PredicateLogic.predicateForAgent(agentNameA, predicateName: married)
        let expMarriedB = PredicateLogic.predicateForAgent(agentNameB, predicateName: married)
        let expSameMaritalStatus = PredicateLogic.biConditionalWithAntecedent(expMarriedA, consequent: expMarriedB)
        puzzle.applyQuestionFilter(expSameMaritalStatus, agentName: agentNameA)
        
        // Add knowledige that B says he is not married.
        let expNotMarriedB = PredicateLogic.negationWithOperand(expMarriedB)
        puzzle.applyQuestionFilter(expNotMarriedB, agentName: agentNameB)
        
        println(puzzle)
    }
    
    class func puzzle78() {
        
        let agentNameA = "Bahman"
        let agentNameB = "Perviz"
        let agentNames = [agentNameA, agentNameB]
        
        let married = "Married"
        let predicateNames = [married]
        
        var puzzle = Puzzle.puzzleWithAgentNames(agentNames, predicates: predicateNames)
        
        println("Initial Puzzle State:")
        println(puzzle)
        
        // Add knowledge that A and B are of the same family.
        let expATruthTeller = PredicateLogic.predicateForAgent(agentNameA, predicateName: Agent.truthTellerFamily)
        let expBTruthTeller = PredicateLogic.predicateForAgent(agentNameB, predicateName: Agent.truthTellerFamily)
        let expSameFamily = PredicateLogic.biConditionalWithAntecedent(expATruthTeller, consequent: expBTruthTeller)
        puzzle.applyExpressionFilter(expSameFamily)
        
        // Add knowledge that at least one of the two are married.
        let expMarriedA = PredicateLogic.predicateForAgent(agentNameA, predicateName: married)
        let expMarriedB = PredicateLogic.predicateForAgent(agentNameB, predicateName: married)
        let expMarriedAOrB = PredicateLogic.disjunctionWithLeftDisjunct(expMarriedA, rightDisjunct: expMarriedB)
        puzzle.applyQuestionFilter(expMarriedAOrB, agentName: agentNameA)
        
        // Add knowledige that B says he is married or he said that he was not married and
        // that this leads the investigator to deduce the marital status of both A and B.
        let expNotMarriedB = PredicateLogic.negationWithOperand(expMarriedB)
        puzzle.applyMetaPuzzleFilterStatements([expMarriedB, expNotMarriedB], agentName: agentNameB, checkExpressions: [expMarriedA, expMarriedB])
        
        println("State After Solving The Puzzle:")
        println(puzzle)
        
        let expBSaysMarriedB = PredicateLogic.questionToAgentWithName(agentNameB, question: expMarriedB)
        let deducedAnswer = puzzle.query(expBSaysMarriedB)        
        let deducedAnswerText =  (deducedAnswer! ? "" : "Not ") + married
        
        println("(\(agentNameB) said he was \(deducedAnswerText))")
    }
}
