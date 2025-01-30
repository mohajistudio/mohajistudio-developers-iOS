//
//  HeaderWithIconView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 1/24/25.
//

import UIKit

class HeaderWithIconView: UIView {

    private let icon = UIImageView().then {
        $0.tintColor = UIColor(named: "Primary")
    }
    
    private let headerLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Bold", size: 16)
        $0.textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func setupUI() {
        setupHierarchy()
        setupConstraints()
    }

    private func setupHierarchy() {
        addSubview(icon)
        addSubview(headerLabel)
    }
    
    private func setupConstraints() {
        icon.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        headerLabel.snp.makeConstraints {
            $0.leading.equalTo(icon.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(iconName: String, headerTitle: String) {
        icon.image = UIImage(named: iconName)
        headerLabel.text = headerTitle
    }
}
