//
//  postModel.swift
//  CollabStudy
//
//  Created by Kunj Patel on 11/18/19.
//  Copyright © 2019 ASU. All rights reserved.
//

import Foundation
import UIKit

class postModel {
    
    var postArr: [postDetail] = []
    
    
    init() {  }
    
    
    func getPostObj(_ index: Int) -> postDetail {
        return postArr[index]
    }
    
    func getCount() -> Int {
        return postArr.count
    }
    
    func addPostObj(_ text: String?,_ image: UIImage) {
        let p = postDetail(text, image)
        postArr.append(p)
    }
    
}

struct postDetail {
    var postText: String?
    var postImage: UIImage?
    
    init(_ t: String?,_ img: UIImage?) {
        self.postText = t
        self.postImage = img
    }
}
