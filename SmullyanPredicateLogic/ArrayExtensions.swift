//
//  ArrayExtensions.swift
//  SmullyanPredicateLogic
//
//  Created by Søren Lind Kristiansen on 11/05/15.
//  Copyright (c) 2015 Guts & Glory ApS. All rights reserved.
//

import Foundation

extension Array {
    
    /// Return a value indicating whether `predicate(x)` is `true` for all elements `x` of `self`.
    func all(predicate : T -> Bool) -> Bool {
        return self.reduce(true, combine: { (reduced : Bool, element : T) -> Bool in return reduced && predicate(element) })
    }
    
    /// Return the number of elements `x` of `self` for which `predicate(x)` is `true`.
    func count(predicate : T -> Bool) -> Int {
        
        return self.reduce(0, combine: { $0 + (predicate($1) ? 1 : 0) })
    }
}
