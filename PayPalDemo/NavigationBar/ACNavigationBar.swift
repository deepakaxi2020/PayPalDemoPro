//
//  ACNavigationBar.swift
//  AeroCinema
//
//  Created by TTND on 06/02/16.
//  Copyright © 2016 TTND. All rights reserved.
//

import UIKit


@objc(ACNavigationBar)
protocol ACNavigationBarDelegate : class
{
    func leftMenuButtonTapped()
    optional func rightMenuButtonTapped()
}

class ACNavigationBar: UIControl {
    
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    
    @IBOutlet weak var backButtonImage: UIImageView!
    weak var delegate : ACNavigationBarDelegate?
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if context.previouslyFocusedView === self {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                context.previouslyFocusedView?.transform = CGAffineTransformMakeScale(1.0, 1.0)
            })
        }
        
        if context.nextFocusedView === self {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                context.nextFocusedView?.transform = CGAffineTransformMakeScale(1.4, 1.4)
            })
        }
    }
    /*
     override var preferredFocusedView: UIView?{
     return self.leftBtn
     }*/
    //***********************************************************************
    // MARK:
    // MARK: - Init Methods
    // MARK:
    //***********************************************************************
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    override func canBecomeFocused() -> Bool {
        return false
    }
   
    func loadViewFromNib() {
        // let view = NSBundle.mainBundle().loadNibNamed(kCVNavigationBar, owner: self, options: nil).first as! UIView
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ACNavigationBar", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIControl
        view.frame = bounds
        view.userInteractionEnabled = false
        //view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    //***********************************************************************
    // MARK:
    // MARK: - IBActions Methods
    // MARK:
    //***********************************************************************
    
    
    @IBAction func leftButtonTapped(sender: AnyObject) {
        
        delegate?.leftMenuButtonTapped()
        
    }
    
    @IBAction func rightButtonTapped(sender: AnyObject) {
        delegate?.rightMenuButtonTapped!()
    }
    
    
}
