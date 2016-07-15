//
//  CreditCardInfoViewController.swift
//  PayPalDemo
//
//  Created by Sandeep Kharbanda on 14/07/16.
//  Copyright © 2016 Sandeep Kharbanda. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class CreditCardInfoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cardTxtFld: UITextField!
    @IBOutlet weak var cvvTxtFld: UITextField!
    @IBOutlet weak var visaTypeTxtFld: UITextField!
    @IBOutlet weak var mmTxtFld: UITextField!
    @IBOutlet weak var yearTxtFld: UITextField!
    @IBOutlet weak var firstNameTxtFld: UITextField!
    @IBOutlet weak var lastNameTxtFld: UITextField!
    
    var accessToken: String = ""
    
    var card = CreditCardModal()
    var selectedProduct :Product!

    
    var recallToken = false
    
    func getDataForPrefill() -> [String] {
        let array = ["4137355596240776",
                     "874",
                     "8",
                     "2021",
                     "Betsy",
                     "Buyer"]
        return array
    }
    func getTextFields() -> [UITextField]
    {
        return [cardTxtFld,
        cvvTxtFld,
        mmTxtFld,
        yearTxtFld,
        firstNameTxtFld,
        lastNameTxtFld]
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        for  textField in getTextFields()
        {
            textField.text = ""
        }
        // Do any additional setup after loading the view.
    }
    /*
     function to clear form data
     */
    @IBAction func clearClick(sender: AnyObject) {
        for  textField in getTextFields()
        {
            textField.text = ""
        }
    }
    
    /*
     function to autofill form data
 */
    @IBAction func autoFillClick(sender: AnyObject) {
        
        let dataArray = getDataForPrefill()
        let textFieldArray = getTextFields()
        for i in 0..<dataArray.count {
            textFieldArray[i].text = dataArray[i]
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        SwiftSpinner.show("Please wait...")
        oAuthForPaypal()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func goAheadBtnTapped(sender: AnyObject) {
        
        let validate = validateInfo()
        
        if validate.status && !self.accessToken.isEmpty {
            callPayment()
        }
        else if validate.status && self.accessToken.isEmpty {
            recallToken = true
            oAuthForPaypal()
        }
        else{
            let alert = UIAlertController(title: nil, message: validate.message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func validateInfo() -> (status: Bool, message: String){
        
        if (cardTxtFld.text!.isEmpty) {
            return (false, "Please enter CardInfo")
        }
        else if (cvvTxtFld.text!.isEmpty) {
            return (false, "Please enter CVV")
        }
        if (mmTxtFld.text!.isEmpty) {
            return (false, "Please enter Month")
        }
        if (yearTxtFld.text!.isEmpty) {
            return (false, "Please enter Year")
        }
        
        if (firstNameTxtFld.text!.isEmpty) {
            return (false, "Please enter First Name")
        }
        
        if (lastNameTxtFld.text!.isEmpty) {
            return (false, "Please enter last Name")
        }
        
        return (true, "User enter all inputs")
        
    }
    
    func callPayment()    {
        
        SwiftSpinner.show("Please wait ..")

        card.number = cardTxtFld.text
        card.expireMonth = mmTxtFld.text
        card.expireYear = yearTxtFld.text
        card.cvv = cvvTxtFld.text
        card.firstName = firstNameTxtFld.text
        card.lastName = lastNameTxtFld.text
        
        card.transaction = self.selectedProduct.price!.stringByReplacingOccurrencesOfString("$", withString: "")
        
        let data:[String:AnyObject] = ["intent": "sale",
                                       
                                       "payer":
                                        
                                        [
                                            
                                            "payment_method": "credit_card",
                                            
                                            "funding_instruments":
                                                
                                                [
                                                    
                                                    [
                                                        
                                                        "credit_card":
                                                            
                                                            [
                                                                
                                                                "number": card.number,
                                                                
                                                                "type": "visa",
                                                                
                                                                "expire_month": card.expireMonth,
                                                                
                                                                "expire_year": card.expireYear,
                                                                
                                                                "cvv2": card.cvv,
                                                                
                                                                "first_name": card.firstName,
                                                                
                                                                "last_name": card.lastName,
                                                                
                                                                "billing_address":
                                                                    
                                                                    [
                                                                        
                                                                        "line1": "111 First Street",
                                                                        
                                                                        "city": "Saratoga",
                                                                        
                                                                        "state": "CA",
                                                                        
                                                                        "postal_code": "95070",
                                                                        
                                                                        "country_code": "US"
                                                                        
                                                                ]
                                                                
                                                        ]
                                                        
                                                    ]
                                                    
                                            ]
                                            
            ],
                                       
                                       "transactions":
                                        
                                        [
                                            
                                            [
                                                
                                                "amount":
                                                    
                                                    [
                                                        
                                                        "total": card.transaction,
                                                        
                                                        "currency": "USD",
                                                        
                                                        "details":
                                                            
                                                            [
                                                                
                                                                "subtotal": card.transaction,
                                                                
                                                                "tax": "0.00",
                                                                
                                                                "shipping": "0.00"
                                                                
                                                        ]
                                                        
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
                for  textField in self.getTextFields()
                {
                    textField.text = ""
                }
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
    
    func oAuthForPaypal()
        
    {
        
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
                
                let statusCode = response.response?.statusCode

                if statusCode == 200{
                    if (result is Dictionary<String, AnyObject>){
                        
                        var sessionResponse = result as! Dictionary<String, AnyObject>
                        
                        self.accessToken = sessionResponse["access_token"] as? String ?? ""
                        
                        if !self.accessToken.isEmpty && self.recallToken{
                            self.recallToken = false
                            self.callPayment()
                        }
                        else{
                            SwiftSpinner.hide()
                        }
                    }
                }
                else{
                    SwiftSpinner.hide()
                }
                
        }
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case cardTxtFld:
            card.number = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString:string)
        case cvvTxtFld:
            let str =  (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString:string)
            if str.characters.count > 3 {
                return false
            }
            card.cvv = str

        case mmTxtFld:
            let str =  (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString:string)
            if str.characters.count > 2 {
                return false
            }
            
            card.expireMonth = str
        case yearTxtFld:
            
            let str =  (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString:string)
            if str.characters.count > 4 {
                return false
            }
            card.expireYear = str
        case firstNameTxtFld:
            card.firstName = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString:string)
        case lastNameTxtFld:
            card.lastName = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString:string)
        default:
            print("")
        }
        
        return true
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
