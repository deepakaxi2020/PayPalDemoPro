//
//  ViewController.swift
//  PayPalDemo
//
//  Created by Sandeep Kharbanda on 14/07/16.
//  Copyright © 2016 Sandeep Kharbanda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func firstOptionSelected(sender: AnyObject) {
        
        self.performSegueWithIdentifier("pushToPaymentOption", sender: "$100")
    }
    
    @IBAction func secondOptionSelected(sender: AnyObject) {
        self.performSegueWithIdentifier("pushToPaymentOption", sender: "$200")

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushToPaymentOption" {
            let destinationVC = segue.destinationViewController as! PaymentOptionViewController
            destinationVC.price = sender as! String
        }
    }
}

