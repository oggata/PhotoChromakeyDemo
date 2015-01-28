//
//  ViewController.swift
//  PhotoChromakeyDemo
//
//  Created by Fumitoshi Ogata on 2015/01/27.
//  Copyright (c) 2015年 Fumitoshi Ogata. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var backImageView : UIImageView!
    var shipImageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backImageView = UIImageView(image:UIImage(named:"back.png"))
        self.view.addSubview(self.backImageView)
        
        self.shipImageView = UIImageView(image:UIImage(named:"ship.png"))
        self.view.addSubview(self.shipImageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {        
        let t = touches.anyObject() as UITouch
        let point = t.locationInView(self.shipImageView)
        
        //get color you touched
        var color : UIColor! = self.shipImageView?.image!.getPixelColor(point)
        var filteredImage = self.shipImageView?.image!.getFilteredImage(color)
        self.shipImageView?.image = filteredImage
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
    }
}

