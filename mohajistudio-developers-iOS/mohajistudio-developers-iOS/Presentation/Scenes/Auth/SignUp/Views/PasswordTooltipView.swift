//
//  PasswordTooltipView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 1/8/25.
//

import UIKit

class PasswordTooltipView: UIView {

    private let contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont(name: "Pretendard-Regular", size: 12)
        $0.textColor = .gray
        $0.text = """
        • 8~20자
        • 영문 대/소문자
        • 숫자
        • 특수문자(@,$,!,%,*,?,&)
        """
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
    }
    
}
