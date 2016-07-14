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
            
            if let _ = creditInfo["payer_id"]{
                self.payerId = creditInfo["payer_id"] as? String
            }
            
            self.number = creditInfo["number"] as! String
            
            if let _ = creditInfo["links"]{
                let infoLinks = creditInfo["links"]
                
                if  infoLinks is Array<Dictionary<String,AnyObject>> {
                    let cardLinks = infoLinks as! Array<Dictionary<String,AnyObject>>
                    
                    self.links = Array<Links>()
                    for (_, link) in cardLinks.enumerate() {
                        self.links?.append(Links(info: link))
                    }
                }
            }
            
            if let _ = creditInfo["state"]{
                self.state = creditInfo["state"] as? String
            }
            
            
            if let _ = creditInfo["type"]{
                self.type = creditInfo["type"] as? String
            }
            
            if let _ = creditInfo["update_time"]{
                self.updateTime = creditInfo["update_time"] as? String
            }
            
            if let _ = creditInfo["valid_until"]{
                self.validUntil = creditInfo["valid_until"] as? String
            }
            

        }
    }

}

class BillingAddress {
    
    var city : String?
    var countryCode : String?
    var line1 : String?
    var postalCode : String?
    var state: String?
    
    init(){
        
    }
    
    
    init(info:AnyObject){
        if info is Dictionary<String, AnyObject> {
            let billingInfo = info as! Dictionary<String, AnyObject>
            
            if let _ = billingInfo["city"]{
                self.city = billingInfo["city"] as? String
            }
            
            if let _ = billingInfo["country_code"]{
                self.countryCode = billingInfo["country_code"] as? String
            }
            
            if let _ = billingInfo["line1"]{
                self.line1 = billingInfo["line1"] as? String
            }
            
            if let _ = billingInfo["postal_code"]{
                self.postalCode = billingInfo["postal_code"] as? String
            }
            
            if let _ = billingInfo["state"]{
                self.state = billingInfo["state"] as? String
            }
            
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
            let linkInfo = info as! Dictionary<String, AnyObject>
            
            if let _ = linkInfo["href"]{
                self.href = linkInfo["href"] as? String
            }
            
            if let _ = linkInfo["method"]{
                self.method = linkInfo["method"] as? String
            }
            
            if let _ = linkInfo["rel"]{
                self.rel = linkInfo["rel"] as? String
            }
            
        }
    }
}