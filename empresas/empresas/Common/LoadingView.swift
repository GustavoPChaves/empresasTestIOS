//
//  LoadingView.swift
//  empresas
//
//  Created by Gustavo Chaves on 18/05/20.
//  Copyright © 2020 Gustavo Chaves. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    var background: UIView!
    var innerCircleView: UIView!
    var outerCircleView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    init(view: UIView, hasBackground: Bool = true){
        super.init(frame: view.frame)
        createLoadingView(view: view, hasBackground: hasBackground)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMoveToSuperview(){
        if let superview = superview{
            innerCircleView.rotate(clockwise: false)
            outerCircleView.rotate(clockwise: true)
        }
        
    }
    
    func createLoadingView(view: UIView, hasBackground: Bool = true){
        innerCircleView = UIView(frame: view.frame)
        outerCircleView = UIView(frame: view.frame)
        
        let background = UIView(frame: view.frame)
        background.backgroundColor = UIColor(named: "transparentBlack")
        if hasBackground{
            self.addSubviews([background])
        }
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.frame.width/2, y: view.frame.height/2), radius: CGFloat(50), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2 * 0.75), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        // Change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        // You can change the stroke color
        shapeLayer.strokeColor = UIColor(named: "lightPink")?.cgColor
        // You can change the line width
        shapeLayer.lineWidth = 5.0
        
        innerCircleView.layer.addSublayer(shapeLayer)
        
        
        let circlePathInner = UIBezierPath(arcCenter: CGPoint(x: view.frame.width/2, y: view.frame.height/2), radius: CGFloat(30), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2 * 0.75), clockwise: true)
        
        let shapeLayerInner = CAShapeLayer()
        shapeLayerInner.path = circlePathInner.cgPath
        
        // Change the fill color
        shapeLayerInner.fillColor = UIColor.clear.cgColor
        // You can change the stroke color
        shapeLayerInner.strokeColor = UIColor(named: "lightPink")?.cgColor
        // You can change the line width
        shapeLayerInner.lineWidth = 5.0
        
        outerCircleView.layer.addSublayer(shapeLayerInner)
        self.addSubviews([innerCircleView, outerCircleView])
        
    }
}
