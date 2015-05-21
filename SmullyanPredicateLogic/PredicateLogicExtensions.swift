//
//  PredicateLogicExtensions.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 07/05/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

extension PredicateLogic {
    
    class func questionToAgentWithName(
        agentName: String,
        question : LogicExpression)
        -> LogicExpression {
            
            let truthTellerFunction = PredicateLogic.predicateForAgent(
                agentName,
                predicateName: Agent.truthTellerFamily)
            
            let questionFunction = PredicateLogic.biConditionalWithAntecedent(
                truthTellerFunction,
                consequent: question)
            
            return questionFunction
    }
}