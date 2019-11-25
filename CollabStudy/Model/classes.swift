//
//  classes.swift
//  CollabStudy
//
//  Created by Kunj Patel on 11/23/19.
//  Copyright © 2019 ASU. All rights reserved.
//

import Foundation


class classes {
    
    var list: [String] = []
    
    
    func getCount() -> Int {
        return list.count
    }
    
    func addClass(className: String) {
        list.append(className)
    }
    
    func getObjectAt(index: Int) -> String {
        return list[index]
    }
    
    
}
