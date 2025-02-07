//
//  PostDetailViewController.swift
//  mohajistudio-developers-iOS
//
//  Created by 송규섭 on 2/3/25.
//

import UIKit

class PostDetailViewController: UIViewController {

    private let postDetailView = PostDetailView()
    
    override func loadView() {
        view = postDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
