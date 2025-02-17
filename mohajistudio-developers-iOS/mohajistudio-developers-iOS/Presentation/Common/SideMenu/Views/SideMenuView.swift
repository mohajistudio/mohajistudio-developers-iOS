//
//  BaseView.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 1/22/25.
//

import UIKit

class SideMenuView: UIView {
    
    private var shadowView: UIView!
    private var menuView = MenuView()
    private var trailingConstraint: NSLayoutConstraint!
    private var isExpanded: Bool = false
    
    private var tapGesture: UITapGestureRecognizer?
    
    private let menuWidth: CGFloat = 345

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func setupUI() {
        setupShadowView()
        setupMenuView()
        setupConstraints()
    }
    
    private func setupShadowView() {
        shadowView = UIView()
        shadowView.backgroundColor = .black
        shadowView.alpha = 0.0
        shadowView.insetsLayoutMarginsFromSafeArea = false
        
        addSubview(shadowView)
        
        shadowView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupMenuView() {
        menuView.backgroundColor = UIColor(named: "Bg 1")
        addSubview(menuView)
    }
    
    private func setupConstraints() {
        menuView.insetsLayoutMarginsFromSafeArea = false
        
        menuView.snp.makeConstraints {
            $0.width.equalTo(menuWidth)
            $0.verticalEdges.equalToSuperview()
        }
        
        trailingConstraint = menuView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: menuWidth)
        trailingConstraint.isActive = true
    }
    
    @objc private func handleTap() {
        if isExpanded {
            toggleMenu()
        }
    }
    
    func getMenuView() -> MenuView {
        return menuView
    }
    
    func toggleMenu() {
        
        print("toggleMenu")
        
        isExpanded.toggle()
        
        isUserInteractionEnabled = isExpanded
        
        if isExpanded {
            menuView.tableView.reloadData()
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            shadowView.addGestureRecognizer(tapGesture!)
        } else {
            if let gesture = tapGesture {
                shadowView.removeGestureRecognizer(gesture)
            }
        }
        
        let targetPosition = isExpanded ? 0 : menuWidth
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews) {
            self.trailingConstraint.constant = targetPosition
            self.layoutIfNeeded()
            self.shadowView.alpha = self.isExpanded ? 0.6 : 0.0
        }
    }
    
}

