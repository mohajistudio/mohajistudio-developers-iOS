//
//  AuthButton.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 12/18/24.
//

import UIKit

class AuthButton: UIButton {

    let title: String
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        
        setupUI()
        configureTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor(named: "ButtonColor")
        self.layer.cornerRadius = 8.0
        self.layer.cornerCurve = .continuous
        self.tintColor = .white
        self.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    
    private func configureTitle() {
        self.setTitle(title, for: .normal)
    }

}
