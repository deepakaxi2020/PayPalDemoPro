//
//  PaymentOptionViewController.swift
//  PayPalDemo
//
//  Created by Sandeep Kharbanda on 14/07/16.
//  Copyright © 2016 Sandeep Kharbanda. All rights reserved.
//

import UIKit

class PaymentOptionViewController: UIViewController {
    
    var price : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func creditCardBtnTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("pushToCreditCard", sender: price)
    }
    
    @IBAction func storedCardBtnTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("pushToStoredCard", sender: price)
    }
    
    @IBAction func paypalBtnTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("pushToPayPal", sender: price)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier! {
        case "pushToCreditCard":
            let destinationVC = segue.destinationViewController as! CreditCardInfoViewController
            destinationVC.price = sender as! String
        case "pushToStoredCard":
            let destinationVC = segue.destinationViewController as! StoredCardViewController
            destinationVC.price = sender as! String
        default:
            let destinationVC = segue.destinationViewController as! PayPalViewController
            destinationVC.price = sender as! String
        }
    }
    

}
