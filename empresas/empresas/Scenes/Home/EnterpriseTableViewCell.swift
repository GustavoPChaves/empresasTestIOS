//
//  EnterpriseTableViewCell.swift
//  empresas
//
//  Created by Gustavo Chaves on 18/05/20.
//  Copyright © 2020 Gustavo Chaves. All rights reserved.
//

import UIKit

class EnterpriseTableViewCell: UITableViewCell {
    
    var background: UIView!
    var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(enterpriseName: String) {
        nameLabel.text = enterpriseName
    }
    
    func setupViewCell(){
        background = UIView()
        background.layer.cornerRadius = 4
        background.backgroundColor = UIColor(named: "backgroundColor\(Int.random(in: 1...3))")
        
        nameLabel = UILabel()
        nameLabel.setup(text: nil, color: .white, fontSize: 18)
        
        addSubviews([background, nameLabel])
        
        setupLayout()
    }
    
    func setupLayout(){
        background.translatesAutoresizingMaskIntoConstraints = false
        background.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        background.leadingAnchor.constraint(equalTo: contentView.superview?.leadingAnchor ?? contentView.leadingAnchor, constant: 0).isActive = true
        background.trailingAnchor.constraint(equalTo: contentView.superview?.trailingAnchor ?? contentView.trailingAnchor, constant: 0).isActive = true
        background.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: background.centerXAnchor).isActive = true
        
    }
    
}
