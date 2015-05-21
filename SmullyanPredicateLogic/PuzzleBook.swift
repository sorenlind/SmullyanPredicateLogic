//
//  PuzzleBook.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 15/05/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

import Foundation

/// An implementation of a few of the puzzles from Smullyan's book, The Riddle of Scheherazade.
class PuzzleBook: NSObject {
    
    class func puzzle76() {
        
        let agentNameA = "Bahman"
        let agentNameB = "Perviz"
        let married = "Married"
        
        var puzzle = Puzzle.puzzleWithAgentNames([agentNameA, agentNameB], predicates: [married])
        
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
        let married = "Married"
        
        var puzzle = Puzzle.puzzleWithAgentNames([agentNameA, agentNameB], predicates: [married])
        
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
        let married = "Married"
        
        var puzzle = Puzzle.puzzleWithAgentNames([agentNameA, agentNameB], predicates: [married])
        
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
    
    class func puzzle80() {
        
        let agentNameA = "Agent A"
        let agentNameB = "Agent B"
        let agentNameC = "Agent C"
        let towncrier = "TownCrier"
        
        var puzzle = Puzzle.puzzleWithAgentNames([agentNameA, agentNameB, agentNameC], predicates: [towncrier])
        
        println("Initial Puzzle State:")
        println(puzzle)
        
        let x = "x"
        let y = "y"
        
        // Add knowledge that there is exactly one towncrier
        let exactlyOneTowncrier = PredicateLogic.exactlyOneAgentHasPredicate(towncrier)
        puzzle.applyExpressionFilter(exactlyOneTowncrier)
        
        // A says he is not the towncrier
        let expTowncrierA = PredicateLogic.predicateForAgent(agentNameA, predicateName: towncrier)
        let expNotTowncrierA = PredicateLogic.negationWithOperand(expTowncrierA)
        puzzle.applyQuestionFilter(expNotTowncrierA, agentName: agentNameA)
        
        // B says the town crier is a liar
        let expXIsTruthteller = PredicateLogic.predicateForVariable(x, predicateName: Agent.truthTellerFamily)
        let expXisLiar = PredicateLogic.negationWithOperand(expXIsTruthteller)
        let expXIsTowncrier = PredicateLogic.predicateForVariable(x, predicateName: towncrier)
        let expIfXTowncrierThenLiar = PredicateLogic.conditionalWithAntecedent(expXIsTowncrier, consequent: expXisLiar)
        let forAllXIfXTowncrierThenLiar = PredicateLogic.forAll(x, openExpression: expIfXTowncrierThenLiar)
        puzzle.applyQuestionFilter(forAllXIfXTowncrierThenLiar, agentName: agentNameB)
        
        // C says A, B and C are liars
        let forAllX_XIsLiar = PredicateLogic.forAll(x, openExpression: expXisLiar)
        puzzle.applyQuestionFilter(forAllX_XIsLiar, agentName: agentNameC)
        
        println("State After Solving The Puzzle:")
        println(puzzle)
        
        if let theTownCrierIsALiar = puzzle.query(forAllXIfXTowncrierThenLiar) {
            let text = theTownCrierIsALiar ? Agent.liarFamily : Agent.truthTellerFamily
            println("The town crier is a \(text).")
        }
        else {
            println("Its unknown whether the town crier is " +
                "\(Agent.truthTellerFamily) or \(Agent.liarFamily).")
        }
    }
    
    class func puzzle81() {
        
        let agentNameA = "Agent A"
        let agentNameB = "Agent B"
        let agentNameC = "Agent C"
        let towncrier = "TownCrier"
        
        var puzzle = Puzzle.puzzleWithAgentNames([agentNameA, agentNameB, agentNameC], predicates: [towncrier])
        
        println("Initial Puzzle State:")
        println(puzzle)
        
        let x = "x"
        let y = "y"
        
        // Add knowledge that there is exactly one towncrier
        let exactlyOneTowncrier = PredicateLogic.exactlyOneAgentHasPredicate(towncrier)
        
        puzzle.applyExpressionFilter(exactlyOneTowncrier)
        
        // A says he is not the towncrier
        let expTowncrierA = PredicateLogic.predicateForAgent(agentNameA, predicateName: towncrier)
        let expNotTowncrierA = PredicateLogic.negationWithOperand(expTowncrierA)
        puzzle.applyQuestionFilter(expNotTowncrierA, agentName: agentNameA)
        
        // B says the town crier is a liar
        let expXIsTruthteller = PredicateLogic.predicateForVariable(x, predicateName: Agent.truthTellerFamily)
        let expXisLiar = PredicateLogic.negationWithOperand(expXIsTruthteller)
        let expXIsTowncrier = PredicateLogic.predicateForVariable(x, predicateName: towncrier)
        let expIfXTowncrierThenLiar = PredicateLogic.conditionalWithAntecedent(expXIsTowncrier, consequent: expXisLiar)
        let forAllXIfXTowncrierThenLiar = PredicateLogic.forAll(x, openExpression: expIfXTowncrierThenLiar)
        puzzle.applyQuestionFilter(forAllXIfXTowncrierThenLiar, agentName: agentNameB)
        
        // C says A, B and C are liars
        let forAllX_XIsLiar = PredicateLogic.forAll(x, openExpression: expXisLiar)
        puzzle.applyQuestionFilter(forAllX_XIsLiar, agentName: agentNameC)
        
        // A says C is a liar
        let expCIsTruthTeller = PredicateLogic.predicateForAgent(agentNameC, predicateName: Agent.truthTellerFamily)
        let expCIsLiar = PredicateLogic.negationWithOperand(expCIsTruthTeller)
        puzzle.applyQuestionFilter(expCIsLiar, agentName: agentNameA)
        
        println("State After Solving The Puzzle:")
        println(puzzle)
        
    }
    
    class func puzzle82() {
        let agentNameA = "Agent A"
        let agentNameB = "Agent B"
        let agentNameC = "Agent C"        
        var puzzle = Puzzle.puzzleWithAgentNames([agentNameA, agentNameB, agentNameC], predicates: [])
        
        println("Initial Puzzle State:")
        println(puzzle)
        
        let exactlyTwoAreTruthtellers = PredicateLogic.exactlyNAgentsHavePredicate(Agent.truthTellerFamily, n: 2)
        puzzle.applyQuestionFilter(exactlyTwoAreTruthtellers, agentName: agentNameA)
        
        let exactlyOneIsTruthteller = PredicateLogic.exactlyNAgentsHavePredicate(Agent.truthTellerFamily, n: 1)
        puzzle.applyQuestionFilter(exactlyOneIsTruthteller, agentName: agentNameB)
        
        puzzle.applyQuestionFilter(exactlyOneIsTruthteller, agentName: agentNameC)
        
        println("State After Solving The Puzzle:")
        println(puzzle)
    }
}
