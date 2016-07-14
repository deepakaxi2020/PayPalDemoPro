//
//  StoredCredit.swift
//  PayPalDemo
//
//  Created by Sandeep Kharbanda on 15/07/16.
//  Copyright © 2016 Sandeep Kharbanda. All rights reserved.
//

import UIKit

class StoredCredit {
    
    var billing_address : String?
    var create_time: String?
    var expireMonth: String!
    var expireYear: String!
    var firstName: String!
    var id : String!
    var last_name: String!
    var links: String?
    var number: String!
    var payer_id: String!
    var state: String?
    var type: String!
    var updateTime: String?
    var valid_until: String?
    
    init(){
        
    }
    
    
    init(info:AnyObject){
        if info is Dictionary<String, AnyObject> {
            var creditInfo = info as! Dictionary<String, AnyObject>
            
        }
    }

}
