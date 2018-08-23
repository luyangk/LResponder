//
//  Array+removeObject.swift
//  LResponder
//
//  Created by Lucca Lu on 2018/8/20.
//  Copyright © 2018 Lucca Lu. All rights reserved.
//

extension Array {
    mutating func removeObject<U: Equatable>(_ object: U) {
        var index: Int?
        for (idx, objectToCompare) in self.enumerated() {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if(index != nil) {
            self.remove(at: index!)
        }
    }
}
