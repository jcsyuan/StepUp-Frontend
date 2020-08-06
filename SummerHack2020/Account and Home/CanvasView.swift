//
//  CanvasView.swift
//  SummerHack2020
//
//  Created by Kelly Chiu on 6/16/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class CanvasView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // drawing line above the bottom buttons
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y:0))
        path.addLine(to: CGPoint(x: 420, y: 0))
        path.stroke()
    }

}
