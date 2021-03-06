//
//  AccountCard.swift
//  Knot
//
//  Created by Jessica Huynh on 2020-03-11.
//  Copyright © 2020 Jessica Huynh. All rights reserved.
//

import UIKit

class AccountCard: UIView {

    // MARK: - Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var institutionLabel: UILabel!
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("AccountCard", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds    
    }
    
    func drawCard(with colour: UIColor) {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        
        let cardLayer = CAShapeLayer()
        cardLayer.frame = contentView.bounds
        cardLayer.fillColor = colour.cgColor
        cardLayer.strokeColor = colour.cgColor
        cardLayer.lineWidth = 1.0
        cardLayer.path = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 10).cgPath
        contentView.layer.insertSublayer(cardLayer, at: 0)
    }

    func updateCard(using account: Account) {
        institutionLabel.text = account.institution.name
        accountTypeLabel.text = account.officialName ?? account.name
        
        if let mask = account.mask {
            accountNumberLabel.text = "**** **** **** \(mask)"
        } else {
            accountNumberLabel.text = ""
        }
        
        logoImage.image = UIImage.base64Convert(base64String: account.institution.logo)
        drawCard(with: UIColor(hexString: account.institution.colour).darken(by: 10))
    }
}
