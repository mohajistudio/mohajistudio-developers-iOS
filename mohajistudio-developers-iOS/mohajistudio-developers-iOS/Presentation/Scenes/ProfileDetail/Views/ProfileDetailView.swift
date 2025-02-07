//
//  ProfileDetailView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/6/25.
//

import UIKit
import Tabman

final class ProfileDetailView: UIView {
    // MARK: - UI Components
    private let headerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let logo = UIImageView().then {
        $0.image = UIImage(named: "Logo")
    }
    
    private let editButton = UIButton().then {
        $0.setImage(UIImage(named: "Post"), for: .normal)
    }
    
    private let menuButton = UIButton().then {
        $0.setImage(UIImage(named: "Menu"), for: .normal)
    }
    
    // 탭바가 추가될 컨테이너
    let tabBarContainer = UIView().then {
        $0.backgroundColor = .white
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .white
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        addSubview(headerView)
        headerView.addSubview(logo)
        headerView.addSubview(editButton)
        headerView.addSubview(menuButton)
        addSubview(tabBarContainer)
    }
    
    private func setupConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        logo.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        menuButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        editButton.snp.makeConstraints {
            $0.trailing.equalTo(menuButton.snp.leading).offset(-16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        tabBarContainer.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-111)
            $0.height.equalTo(36)
        }
    }
    
    // MARK: - TabBar Configuration
    func configureTabBar(_ bar: TMBar.ButtonBar) {
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .leading
        bar.layout.contentMode = .fit
        bar.layout.interButtonSpacing = 20
        
        
        bar.backgroundView.style = .flat(color: .white)
        
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = UIColor(named: "Primary")
        
        bar.buttons.customize { button in
            button.tintColor = UIColor(named: "Gray 3")
            button.selectedTintColor = UIColor(named: "Black")
            button.font = UIFont(name: "Pretendard-Bold", size: 16) ?? .systemFont(ofSize: 16)
            button.selectedFont = UIFont(name: "Pretendard-Bold", size: 16) ?? .systemFont(ofSize: 16)
        }
    }
}
