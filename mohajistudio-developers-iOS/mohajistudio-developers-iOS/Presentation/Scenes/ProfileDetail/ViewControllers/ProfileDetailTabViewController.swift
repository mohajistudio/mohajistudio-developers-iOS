//
//  ProfileDetailTabViewController.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/6/25.
//

import UIKit
import Tabman
import Pageboy

class ProfileDetailTabViewController: UIViewController {
    private let viewModel: ProfileDetailViewModel
    
    private let headerView = UIView().then {
        $0.backgroundColor = UIColor(named: "Bg 1")
    }
    
    private let logoButton = UIButton().then {
        $0.setImage(UIImage(named: "Logo"), for: .normal)
    }
    
    private let editButton = UIButton().then {
        $0.setImage(UIImage(named: "Post"), for: .normal)
    }
    
    private let menuButton = UIButton().then {
        $0.setImage(UIImage(named: "Menu"), for: .normal)
    }
    
    // tabBar의 위치가 커스텀되기 때문에 놓아줄 자리
    private let tabBarContainer = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let tabmanVC = TabmanViewController()
    
    private lazy var viewControllers: [UIViewController] = [
        BlogViewController(),
        ProfileViewController(),
        CommentsViewController()
    ]
    
    // MARK: - Initialization
    init(viewModel: ProfileDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTabman()
        setupAction()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(named: "Bg 1")
        
        setupHeaderView()
        setupTabmanViewController()
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        headerView.addSubview(logoButton)
        headerView.addSubview(editButton)
        headerView.addSubview(menuButton)
        view.addSubview(tabBarContainer)
        
        let safeAreaLayoutHeight = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.safeAreaInsets.top ?? 0
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(60 + safeAreaLayoutHeight)
        }
        
        logoButton.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(safeAreaLayoutHeight/2)
            $0.leading.equalToSuperview().offset(20)
        }
        
        menuButton.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(safeAreaLayoutHeight/2)
            $0.trailing.equalToSuperview().offset(-20)
            $0.size.equalTo(24)
        }
        
        editButton.snp.makeConstraints {
            $0.trailing.equalTo(menuButton.snp.leading).offset(-16)
            $0.centerY.equalToSuperview().offset(safeAreaLayoutHeight/2)
            $0.size.equalTo(24)
        }
        
        tabBarContainer.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(36)
        }
    }
    
    private func setupTabmanViewController() {
        addChild(tabmanVC)
        view.addSubview(tabmanVC.view)
        
        tabmanVC.view.snp.makeConstraints {
            $0.top.equalTo(tabBarContainer.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        tabmanVC.didMove(toParent: self)
    }
    
    private func setupTabman() {
        tabmanVC.dataSource = self
        
        let bar = TMBar.ButtonBar()
        configureTabBar(bar)
        tabmanVC.addBar(bar, dataSource: self, at: .custom(view: tabBarContainer, layout: nil))
        
        tabmanVC.scrollToPage(.at(index: 0), animated: false)
    }
    
    private func configureTabBar(_ bar: TMBar.ButtonBar) {
        bar.layout.transitionStyle = .progressive
        bar.layout.alignment = .leading
        bar.layout.contentMode = .intrinsic
        bar.layout.interButtonSpacing = 16
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        bar.backgroundView.style = .flat(color: UIColor(named: "Bg 1")!)
        
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = UIColor(named: "Primary")
        
        bar.buttons.customize { button in
            button.tintColor = UIColor(named: "Gray 3")
            button.selectedTintColor = UIColor(named: "Black")
            button.font = UIFont(name: "Pretendard-Bold", size: 16) ?? .systemFont(ofSize: 16, weight: .bold)
            button.selectedFont = UIFont(name: "Pretendard-Bold", size: 16) ?? .systemFont(ofSize: 16, weight: .bold)
        }
    }
    
    private func setupAction() {
        logoButton.addTarget(self, action: #selector(didTapLogoButton), for: .touchUpInside)
    }
    
    @objc private func didTapLogoButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - DataSource
extension ProfileDetailTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 0)
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: viewModel.tabTitles[index])
    }
}
