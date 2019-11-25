//
//  posts.swift
//  CollabStudy
//
//  Created by Kunj Patel on 11/23/19.
//  Copyright © 2019 ASU. All rights reserved.
//

import Foundation

class posts {
    
    var posts: [Any] = []
    
    
    func getCount() -> Int {
        return posts.count
    }
    
    func getObjectAt(index: Int) -> Any {
        return posts[index]
    }
    
    func addPost(post: Any) {
        posts.append(post)
    }
   
    
}
