//
//  ArrayExtensions.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 11/05/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

import Foundation

extension Array {
    
    func all(predicate : T -> Bool) -> Bool {
        return self.reduce(true, combine: { (reduced : Bool, element : T) -> Bool in return reduced && predicate(element) })
    }
}
