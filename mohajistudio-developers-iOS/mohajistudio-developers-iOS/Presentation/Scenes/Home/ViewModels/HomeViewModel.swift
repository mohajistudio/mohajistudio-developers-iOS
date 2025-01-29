//
//  HomeViewModel.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 1/12/25.
//

import Foundation

final class HomeViewModel {
    
    private let homeRepository: HomeRepositoryProtocol
    private(set) var tags: [String] = ["iOS", "Android", "Web", "Server", "Design", "AI", "Database", "Frontend", "Backend", "HTML", "Javascript", "CSS", "Figma", "Coding"]
    
    private(set) var title: String = "UI/UX 디자인과 개발자 협업에 중요한 기초 상식"
    private(set) var date: String = "Jul 3. 2024"
//    private(set) var content: String = "팀 프로젝트를 위한 기초적인 상식에 대해 알아봅시다!"
    private(set) var postTags: [String] = ["Development", "Project", "Tech", "Design"]
    
    init(homeRepository: HomeRepositoryProtocol = HomeRepository()) {
        self.homeRepository = homeRepository
    }
    
    func filterPosts(by query: String) {
        // 검색어로 포스트 필터링
    }
    
    func filterPosts(byTag tag: String) {
        // 태그로 포스트 필터링
    }
    
}

// MARK: - Business Logic

extension HomeViewModel {
    
    
    
}
