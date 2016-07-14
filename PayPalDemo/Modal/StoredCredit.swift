//
//  StoredCredit.swift
//  PayPalDemo
//
//  Created by Sandeep Kharbanda on 15/07/16.
//  Copyright © 2016 Sandeep Kharbanda. All rights reserved.
//

import UIKit

class StoredCredit {
    
    var billingAddress : BillingAddress?
    var createTime: String?
    var expireMonth: String!
    var expireYear: String!
    var firstName: String!
    var id : String!
    var lastName: String!
    var links: Array<Links>?
    var number: String!
    var payerId: String!
    var state: String?
    var type: String!
    var updateTime: String?
    var validUntil: String?
    
    init(){
        
    }
    
    
    init(info:AnyObject){
        if info is Dictionary<String, AnyObject> {
            let creditInfo = info as! Dictionary<String, AnyObject>
            
            if let _ = creditInfo["billing_address"]{
                self.billingAddress = BillingAddress(info: creditInfo["billing_address"]!)
                
            }
            
            if let _ = creditInfo["create_time"]{
                self.createTime = creditInfo["create_time"] as? String
                
            }
            
            self.expireMonth = creditInfo["expire_month"] as! String
            self.expireYear = creditInfo["expire_year"] as! String
            self.firstName = creditInfo["first_name"] as! String
            self.id = creditInfo["id"] as! String
            self.lastName = creditInfo["last_name"] as! String
            self.number = creditInfo["number"] as! String
            self.payerId = creditInfo["payer_id"] as? String ?? ""
            self.state = creditInfo["state"] as? String
            self.type = creditInfo["type"] as? String
            self.updateTime = creditInfo["update_time"] as? String
            self.validUntil = creditInfo["valid_until"] as? String

        }
    }

}

class BillingAddress {
    
    var city : String?
    var country_code : String?
    var line1 : String?
    var postal_code : String?
    var state: String?
    
    init(){
        
    }
    
    
    init(info:AnyObject){
        if info is Dictionary<String, AnyObject> {
            let billing = info as! Dictionary<String, AnyObject>
            
        }
    }
}

class Links {
    
    var href : String?
    var method : String?
    var rel : String?
    
    init(){
        
    }
    
    init(info:AnyObject){
        if info is Dictionary<String, AnyObject> {
            let link = info as! Dictionary<String, AnyObject>
            
        }
    }
}