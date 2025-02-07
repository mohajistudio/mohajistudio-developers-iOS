//
//  ProfileViewController.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/6/25.
//

import UIKit

class ProfileViewController: UIViewController {

    private let profileView = ProfileView()
    private let viewModel: ProfileViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testUserDetail = UserDetailResponse(id: "1", nickname: "Kyu_Veloper", email: "sks565075@gmail.com", profileImageUrl: "", bio: "음악을 사랑하는 개발 지망생입니다!\n iOS 플랫폼 위주로 하고 있습니다.", role: "iOS Native Developer", contacts: nil)
        
        profileView.configure(userDetail: testUserDetail, contacts: viewModel.contacts)
    }
    
    override func loadView() {
        view = profileView
    }

    init(viewModel: ProfileViewModel = ProfileViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
}
