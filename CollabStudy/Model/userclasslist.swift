//
//  userclasslist.swift
//  CollabStudy
//
//  Created by Kunj Patel on 11/23/19.
//  Copyright © 2019 ASU. All rights reserved.
//

import Foundation

class userclasslist {
    
    var classlist: [String] = []
    
    func getCount() -> Int {
        return classlist.count
    }
    
    func getObjectAt(index: Int) -> String {
        return classlist[index]
    }
    
    func addObject(object: String) {
        classlist.append(object)
    }
    
}
