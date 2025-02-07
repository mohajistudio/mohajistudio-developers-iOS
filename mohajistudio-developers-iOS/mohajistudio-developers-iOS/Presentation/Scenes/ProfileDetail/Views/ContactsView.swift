//
//  ContactsView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/7/25.
//

import Foundation
import UIKit

class ContactsView: UIView {
    
    // MARK: - Properties
    private let backgroundView = UIView().then {
        $0.backgroundColor = UIColor(named: "Surface 1")
        $0.layer.cornerRadius = 16
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fillEqually
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubview(backgroundView)
        backgroundView.addSubview(stackView)
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
    }
    
    // MARK: - Public Methods
    func configure(contacts: [Contact]) {
        // 기존 버튼들 제거
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        // 새로운 컨택트 버튼들 추가
        contacts.forEach { contact in
            let contactView = createContactView(for: contact)
            stackView.addArrangedSubview(contactView)
        }
    }
    
    // MARK: - Private Methods
    private func createContactView(for contact: Contact) -> UIView {
        let containerView = UIView()
        
        let iconImageView = UIImageView().then {
            $0.image = UIImage(named: contact.imageUrl)
            $0.contentMode = .scaleAspectFit
        }
        
        let titleLabel = UILabel().then {
            $0.text = contact.name.lowercased()
            $0.font = UIFont(name: "Pretendard-Medium", size: 14)
            $0.textColor = UIColor(named: "Gray 1")
        }
        
        let button = UIButton()
        button.backgroundColor = .clear
        
        containerView.addSubview(button)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        
        containerView.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
        
        // 버튼 터치 이벤트 처리
        button.addTarget(self, action: #selector(contactButtonTapped(_:)), for: .touchUpInside)
        button.tag = stackView.arrangedSubviews.count
        
        return containerView
    }
    
    @objc private func contactButtonTapped(_ sender: UIButton) {
        // 여기에 버튼 탭 이벤트 처리 로직 추가
        // URL 열기 등의 작업 수행
    }
    
    // MARK: - Helper Methods
    func getContactStackView() -> UIStackView {
        return stackView
    }
}
