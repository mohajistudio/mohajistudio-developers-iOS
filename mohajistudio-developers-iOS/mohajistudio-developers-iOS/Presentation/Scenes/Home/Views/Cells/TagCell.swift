//
//  TagCell.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 1/24/25.
//

import UIKit

class TagCell: UICollectionViewCell {
    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.textColor = UIColor(named: "Gray 1")
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(named: "Bg 2")
        contentView.layer.cornerRadius = 14
        contentView.clipsToBounds = true
        contentView.isUserInteractionEnabled = true
        isUserInteractionEnabled = true
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
        }
    }
    
    func configure(with title: String) {
        titleLabel.text = title
        setNeedsLayout()
    }
    
    override var isSelected: Bool {
        didSet {
            // 선택 상태에 따라 시각적 피드백 제공
            contentView.backgroundColor = isSelected ? UIColor(named: "Primary") : UIColor(named: "Bg 2")
            titleLabel.textColor = isSelected ? .white : UIColor(named: "Gray 1")
        }
    }
}
