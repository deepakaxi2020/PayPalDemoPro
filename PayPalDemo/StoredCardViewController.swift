//
//  StoredCardViewController.swift
//  PayPalDemo
//
//  Created by Sandeep Kharbanda on 14/07/16.
//  Copyright © 2016 Sandeep Kharbanda. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
class StoredCardViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var cardTxtFld: UITextField!
    @IBOutlet weak var cardsTblVw: UITableView!
    
    var selectedCard : StoredCredit!
    
    var accessToken: String = ""
    
    var selectedProduct :Product!

    var storedCards = Array<StoredCredit>()
    
    override func viewDidLoad() {
        
        oAuthForPaypal()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        priceLbl.text = selectedProduct.price
        productName.text = selectedProduct.productName
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func oAuthForPaypal()
    {
        
        SwiftSpinner.show("Please wait...")
        let clientKey = "Ab72r9x_EvXqOCuehK3pa64nkD7cLo7oJqItLJElOKQQayVHYenoidSKwZh5O63VsFmg7kfxBqxlvv_R"
        
        let clientSecret = "EMI_F-tF-SGWTfD3vnQdXg3ZiNsG0bibQnYDpMcEbKv4Bi9-YLGNI1B2Ey9pqUFxQe-Q4d2NLt7kdEMr"
        
        let data = ["grant_type": "client_credentials"]
        
        let path = "https://api.sandbox.paypal.com/v1/oauth2/token"
        
        let user = clientKey
        
        let password = clientSecret
        
        let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        
        let header = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(.POST, path,parameters: data, headers: header)
            
            .responseJSON { response in
                
                let result = response.result.value
                if (result is Dictionary<String, AnyObject>){
                    let statusCode = response.response?.statusCode
                    if statusCode == 200{
                        var sessionResponse = result as! Dictionary<String, AnyObject>
                        
                        self.accessToken = sessionResponse["access_token"] as? String ?? ""
                        
                        if !self.accessToken.isEmpty{
                            
                            self.getStoredCredits()
                        }
                    }
                    else{
                        SwiftSpinner.hide()
                    }
                   
                }
        }
    }
    
    func getStoredCredits(){
        let path = "https://api.sandbox.paypal.com/v1/vault/credit-card"
        let header = ["Content-Type": "application/json",
                      
                      "Authorization":  "Bearer " + self.accessToken ]
        
        Alamofire.request(.GET, path, parameters: nil, encoding: .JSON, headers: header)
            .responseJSON { (response) in
                
                let statusCode = response.response?.statusCode
                SwiftSpinner.hide()
                if statusCode == 200{
                    let result = response.result.value
                    
                    if result is Dictionary<String, AnyObject>{
                        var storedCardResults = result as! Dictionary<String, AnyObject>
                        
                        let items = storedCardResults["items"]
                        if items is Array<Dictionary<String, AnyObject>>{
                            let cardItems = items as! Array<Dictionary<String, AnyObject>>
                            for(_, card) in cardItems.enumerate(){
                                self.storedCards.append(StoredCredit(info: card))
                            }
                            
                            self.cardsTblVw.reloadData()
                        }
                    }
                }
                
                
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedCards.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cardCell")
        
        if cell == nil{
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cardCell")
        }
        cell!.textLabel?.font = UIFont(name: "Avenir", size: 35.0)
        cell!.textLabel?.text = storedCards[indexPath.row].number
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        cardTxtFld.text = storedCards[indexPath.row].number
        selectedCard = storedCards[indexPath.row]
        self.cardsTblVw.hidden = true
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.cardsTblVw.hidden = false
        return false
    }
    
    
    @IBAction func proceedBtbTapped(sender: AnyObject) {
        
        if (!cardTxtFld.text!.isEmpty) {
            callPayment()
        }
        else{
            let alert = UIAlertController(title: nil, message: "Please select any stored credit", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    func callPayment()    {
        
        SwiftSpinner.show("Payment in progress...")
        let value = self.selectedProduct.price!.stringByReplacingOccurrencesOfString("$", withString: "")
        
        let data:[String:AnyObject] = [
                                        "intent": "sale",
                                       "payer": [
                                            "payment_method": "credit_card",
                                            "funding_instruments":[
                                            [
                                                    "credit_card_token": [
                                                    "credit_card_id": selectedCard.id,
                                                    "payer_id": selectedCard.payerId
                                                ]
                                            ]
                                        ]
                                    ],
                                       "transactions":[
                                        [
                                            "amount":[
                                                "total": value,
                                                "currency": "USD"
                                            ],
                                            "description": "This is the payment transaction description."
                                        ]
                                    ]
                                ]
        
        let path = "https://api.sandbox.paypal.com/v1/payments/payment"
        
        
        print(data)
        let header = ["Content-Type": "application/json",
                      
                      "Authorization":  "Bearer " + accessToken ]
        
        Alamofire.request(.POST, path, parameters: data, encoding: .JSON, headers: header)
            
            .responseJSON { (response) in
                SwiftSpinner.hide()
                print(response.result.value)
                
                let result = response.result.value
                
                if result is Dictionary<String, AnyObject>{
                    var storedCardResults = result as! Dictionary<String, AnyObject>
                    
                    let state = storedCardResults["state"] as! String
                    
                    if state == "approved"{
                        
                        let message = "Your order has been placed successfully and your order is " + (storedCardResults["id"] as! String)
                        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
        
        }
    
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
