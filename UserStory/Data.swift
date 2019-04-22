//
//  Data.swift
//  UserStory
//
//  Created by Android on 23/4/2562 BE.
//  Copyright © 2562 MelonDev. All rights reserved.
//

import Foundation
import UIKit

struct Data {
    var who :String
    var why :String
    var key :String
    var What :String
    var know :String
    var size :String
    var name :String
    
    init(slot :[String :AnyObject]? = nil) {
        if(slot != nil){
            self.who = slot!["who"] as! String
            self.why = slot!["why"] as! String
            self.key = slot!["key"] as! String
            self.What = slot!["what"] as! String
            self.know = slot!["know"] as! String
            self.size = slot!["size"] as! String
            self.name = slot!["name"] as! String

        }else {
            self.who = ""
            self.why = ""
            self.key = ""
            self.What = ""
            self.know = ""
            self.size = ""
            self.name = ""

        }
    }
    
}
