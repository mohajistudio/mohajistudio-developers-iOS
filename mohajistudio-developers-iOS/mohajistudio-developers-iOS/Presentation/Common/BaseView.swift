//
//  BaseView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 1/22/25.
//

import UIKit

class BaseView: UIView {
    
    let headerView = UIView().then {
        $0.backgroundColor = UIColor(named: "Bg 1")
    }
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = UIColor(named: "Bg 1")
        $0.isUserInteractionEnabled = true
    }
    
    let contentView = UIView().then {
        $0.backgroundColor = UIColor(named: "Bg 1")
        $0.isUserInteractionEnabled = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBaseUI() {
        backgroundColor = UIColor(named: "Bg 1")
        
        setupHierarchy()
        setupConstraints()
        hideKeyboardWhenTappedBackground()
    }
    
    private func setupHierarchy() {
        addSubview(headerView)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func setupConstraints() {
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
    }
    
}

extension BaseView {
    func hideKeyboardWhenTappedBackground() {
        let tapEvent = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapEvent.cancelsTouchesInView = false
        addGestureRecognizer(tapEvent)
    }
    
    @objc func dismissKeyboard() {
        contentView.endEditing(true)
    }
}
