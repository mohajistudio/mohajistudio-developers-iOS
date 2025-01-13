//
//  HomeView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 1/12/25.
//

import UIKit

protocol HomeViewDelegate: AnyObject {
    func homeViewDidTapLogin()
}

class HomeView: UIView {

    weak var delegate: HomeViewDelegate?
    
    private let loginButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        $0.setImage(UIImage(systemName: "iphone.and.arrow.forward", withConfiguration: config), for: .normal)
        // 또는 "person.circle" 같은 다른 심볼로 테스트
        $0.tintColor = UIColor(named: "Primary")
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    // MARK: - UI 설정
    
    private func setupUI() {
        backgroundColor = UIColor(named: "Bg 1")
        
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        addSubview(loginButton)
    }
    
    private func setupConstraints() {
        loginButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
    
    @objc private func didTapLoginButton() {
        delegate?.homeViewDidTapLogin()
    }
}
