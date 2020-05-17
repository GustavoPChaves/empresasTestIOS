//
//  UILabel+Extension.swift
//  empresas
//
//  Created by Gustavo Chaves on 16/05/20.
//  Copyright © 2020 Gustavo Chaves. All rights reserved.
//

import UIKit

extension UILabel{
    func setup(text: String?, color: UIColor, fontSize: CGFloat){
        self.font = UIFont(name: "Rubik-Regular", size: fontSize)
        self.textColor = color
        self.text = text ?? ""
    }
}
