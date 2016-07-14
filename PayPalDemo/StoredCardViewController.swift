//
//  StoredCardViewController.swift
//  PayPalDemo
//
//  Created by Sandeep Kharbanda on 14/07/16.
//  Copyright © 2016 Sandeep Kharbanda. All rights reserved.
//

import UIKit
import Alamofire

class StoredCardViewController: UIViewController {
    
    
    @IBOutlet weak var priceLbl: UILabel!
    
    var accessToken: String = ""
    
    var price : String!
    
    
    override func viewDidLoad() {
        
        oAuthForPaypal()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        priceLbl.text = price
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                if (result is Dictionary<String, AnyObject>){
                    
                    var sessionResponse = result as! Dictionary<String, AnyObject>
                    
                    self.accessToken = sessionResponse["access_token"] as? String ?? ""
                    
                    if !self.accessToken.isEmpty{
                        
                        self.getStoredCredits()
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
                
                if statusCode == 200{
                    let result = response.result.value
                    
                    if result is Dictionary<String, AnyObject>{
                        var storedCardResults = result as! Dictionary<String, AnyObject>
                        print(storedCardResults["items"])
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
