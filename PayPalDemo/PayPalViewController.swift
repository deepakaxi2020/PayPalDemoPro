//
//  PayPalViewController.swift
//  PayPalDemo
//
//  Created by Sandeep Kharbanda on 14/07/16.
//  Copyright © 2016 Sandeep Kharbanda. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class PayPalViewController: UIViewController {

    @IBOutlet weak var priceLbl: UILabel!
    
    var accessToken: String = ""

    var price : String!
    
    var paypalInfo : PaypalCreditModal!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        priceLbl.text = price
        
        SwiftSpinner.show("Please wait...")
        oAuthForPaypal()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okBtnTapped(sender: AnyObject) {
        
        callPayment()
    }

    func callPayment()    {
        
        SwiftSpinner.show("Connecting with Paypal...")
        let value = self.price.stringByReplacingOccurrencesOfString("$", withString: "")

        let data:[String:AnyObject] = [
                "intent":"sale",
                "redirect_urls":[
                    "return_url":"http://www.google.com",
                    "cancel_url":"http://www.facebook.com"
                ],
                "payer":[
                    "payment_method":"paypal"
                ],
                "transactions":[
                                    [
                                        "amount":[
                                            "total":value,
                                            "currency":"USD"
                                        ],
                                        "description":"This is the payment transaction description."
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
                
                let result = response.result.value
                if (result is Dictionary<String, AnyObject>){
                    
                    let paypalResponse = result as! Dictionary<String, AnyObject>
                    self.paypalInfo = PaypalCreditModal(info: paypalResponse)
                    
                    if let _ = self.paypalInfo.links{
                        for (_, link) in self.paypalInfo.links!.enumerate(){
                            if link.rel == "approval_url"{
                                
                                let alert = UIAlertController(title: nil, message: ("Please open given url in browser \"" + link.href!) + "\"", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                                break;
                            }
                        }
                    }
                }
        }
    }
    
    func oAuthForPaypal() {
        
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
                
                SwiftSpinner.hide()
                let result = response.result.value
                if (result is Dictionary<String, AnyObject>){
                    
                    var sessionResponse = result as! Dictionary<String, AnyObject>
                    
                    self.accessToken = sessionResponse["access_token"] as? String ?? ""
                    
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
