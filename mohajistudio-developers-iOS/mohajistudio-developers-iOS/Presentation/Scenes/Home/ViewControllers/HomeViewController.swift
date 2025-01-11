//
//  HomeViewController.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 1/6/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private let viewModel: HomeViewModel

    override func loadView() {
        view = homeView
    }
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        homeView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
}

extension HomeViewController: HomeViewDelegate {
    
    func homeViewDidTapLogin() {
        print("homeViewDidTapLogin 탭")
        
        let loginViewModel = LoginViewModel()
        let vc = LoginViewController(viewModel: loginViewModel)
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.setNavigationBarHidden(true, animated: false)
        
//        loginViewModel.loginSuccess = { [weak self] in
//            self?.dismiss(animated: true)
//            // 로그인 후 필요한 처리
//        }
        
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
}
