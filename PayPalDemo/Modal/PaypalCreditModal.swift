//
//  PaypalCreditModal.swift
//  PayPalDemo
//
//  Created by Sandeep Kharbanda on 15/07/16.
//  Copyright © 2016 Sandeep Kharbanda. All rights reserved.
//

import UIKit

class PaypalCreditModal {
    
    var createTime: String?
    var id : String!
    var intent: String!
    var links: Array<Links>?
    var paymentMethod: String!
    var payerId: String!
    var state: String?
    var transactions: Array<Transaction>?
    var updateTime: String?
    
    
    init(){
        
    }
    
    
    init(info:AnyObject){
        if info is Dictionary<String, AnyObject> {
            let creditInfo = info as! Dictionary<String, AnyObject>
            
            
            if let _ = creditInfo["create_time"]{
                self.createTime = creditInfo["create_time"] as? String
                
            }
            
            self.id = creditInfo["id"] as! String
            self.intent = creditInfo["intent"] as! String
            
            
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
            
            if let _ = creditInfo["payer"]!["payment_method"]{
                self.paymentMethod = creditInfo["payer"]!["payment_method"] as? String
            }
            
            
            if let _ = creditInfo["state"]{
                self.state = creditInfo["state"] as? String
            }
            
            
            if let _ = creditInfo["transactions"]{
                let creditCardTransactions = creditInfo["transactions"]
                
                if  creditCardTransactions is Array<Dictionary<String,AnyObject>> {
                    let cardTransactions = creditCardTransactions as! Array<Dictionary<String,AnyObject>>
                    
                    self.transactions = Array<Transaction>()
                    for (_, transaction) in cardTransactions.enumerate() {
                        self.transactions?.append(Transaction(info: transaction))
                    }
                }
            }
        }
    }
}

class Transaction {
    var currency: String?
    
    var total : String?
    
    var description : String?
    
    init(){
        
    }
    
    
    init(info:AnyObject){
        if info is Dictionary<String, AnyObject> {
            
            let transactionInfo = info as! Dictionary<String, AnyObject>

            if let _ = transactionInfo["amount"]!["currency"]{
                self.currency = transactionInfo["amount"]!["currency"] as? String
            }
            
            if let _ = transactionInfo["amount"]!["total"]{
                self.total = transactionInfo["amount"]!["total"] as? String
            }

            if let _ = transactionInfo["description"]{
                self.description = transactionInfo["description"] as? String
            }
        }
        
    }
    
}
