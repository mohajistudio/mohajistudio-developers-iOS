//
//  DevelopersCell.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/13/25.
//

import UIKit

class DevelopersCell: UITableViewCell {
    
    static let identifier = "DevelopersCell"
    
    let containerView = UIView().then {
        $0.backgroundColor = UIColor(named: "Surface 1")
    }
    
    private let thumbnailImageView = UIImageView().then {
        $0.image = UIImage(named: "Default_profile")
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 17
    }
    
    private let nameLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.text = "Name"
        $0.textColor = UIColor(named: "Black")
    }
    
    private let roleLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.text = "Developer"
        $0.textColor = UIColor(named: "Gray 3")
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = UIColor(named: "Bg 1")
    }

    // 초기화 메서드. 스타일과 재사용 식별자를 매개변수로 받아 초기화를 수행합니다.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(named: "Bg 1")
        self.setupUI()  // 공통 초기화 작업을 수행하는 메서드 호출
    }
    
    // 초기화 메서드 (NSCoder를 사용한 초기화). 스토리보드나 xib 파일을 통해 생성된 경우 사용됩니다.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(thumbnailImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(roleLabel)
        containerView.addSubview(separatorView)
    }
    
    private func setupConstraints() {
        
        containerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview()
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(34)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
        roleLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        separatorView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func configure(user: User, isLastCell: Bool) {
        nameLabel.text = user.nickname
        roleLabel.text = user.role
        separatorView.isHidden = isLastCell
    }
    
}
