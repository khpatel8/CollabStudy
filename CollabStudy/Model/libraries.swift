//
//  libraries.swift
//  CollabStudy
//
//  Created by Kunj Patel on 11/23/19.
//  Copyright © 2019 ASU. All rights reserved.
//

import Foundation

class libraries {
    
    var library: [String] = []
    
    
    func getCount() -> Int {
        return library.count
    }
    
    func getObjectAt(index: Int) -> String {
        return library[index]
    }
    
    func addObject(object: String) {
        library.append(object)
    }
    
    
}
