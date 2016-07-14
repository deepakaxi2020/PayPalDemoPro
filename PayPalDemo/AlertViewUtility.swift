//
//  AlertViewUtility.swift
//  AeroCinema
//
//  Created by TTND on 04/02/16.
//  Copyright © 2016 TTND. All rights reserved.
//

import Foundation

import UIKit

class AlertViewUtility: NSObject {
    typealias AlertViewHandler = (UIAlertAction) -> Void
    class func showAlertView(title:String?, message:String?, otherButtonTitles:String?..., cancelButtonTitle:String, controller:UIViewController) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        for title:String? in otherButtonTitles {
            if let value = title { //value != nil
                alert.addAction(UIAlertAction(title: value, style: UIAlertActionStyle.Default, handler: nil))
            }
        }
       
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.Cancel, handler: nil))
        
        controller.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func showAlertViewWithCancelAction(title:String?,
                                             message:String?,
                                             otherButtonTitles:String?...,
                                             cancelButtonTitle:String,
                                             controller:UIViewController ,
                                             cancelAction: UIAlertAction) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        for title:String? in otherButtonTitles {
            if let value = title { //value != nil
                alert.addAction(UIAlertAction(title: value, style: UIAlertActionStyle.Default, handler: nil))
            }
        }
        alert.addAction(cancelAction)
     
        controller.presentViewController(alert, animated: true, completion: nil)
    }
    /*
    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"AlertView in iOS 8"  message:nil  preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    */
}

