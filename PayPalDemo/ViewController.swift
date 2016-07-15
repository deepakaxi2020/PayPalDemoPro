//
//  ViewController.swift
//  PayPalDemo
//
//  Created by Sandeep Kharbanda on 14/07/16.
//  Copyright © 2016 Sandeep Kharbanda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    func productArray() -> [Product] {
        let p1 = Product()
        p1.price = "100"
        p1.productName = "Product 1"
        let p2 = Product()
        p2.price = "200"
        p2.productName = "Product 2"
        let array = [p1,p2]
        return array
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func firstOptionSelected(sender: AnyObject) {
        
        let p1 = Product()
        p1.price = "100"
        p1.productName = "Product 1"

        self.performSegueWithIdentifier("pushToPaymentOption", sender: p1)
    }
    
    @IBAction func secondOptionSelected(sender: AnyObject) {
        let p2 = Product()
        p2.price = "200"
        p2.productName = "Product 2"
        self.performSegueWithIdentifier("pushToPaymentOption", sender: p2)

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushToPaymentOption" {
            let destinationVC = segue.destinationViewController as! PaymentOptionViewController
            
            destinationVC.selectedProduct = sender as? Product
        }
    }
}

