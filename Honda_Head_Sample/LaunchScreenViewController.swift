//
//  LaunchScreenViewController.swift
//  HondaHead
//
//  Created by Ryan Sady on 2/1/21.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 0.5) {
            self.imageView.alpha = 0
            self.imageView.transform = .init(scaleX: 2, y: 2)
        } completion: { [weak self] (_) in
            guard let weakSelf = self else { return }
            let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBar")
            tabBarController.modalTransitionStyle = .crossDissolve
            tabBarController.modalPresentationStyle = .fullScreen
            weakSelf.present(tabBarController, animated: true, completion: nil)
        }

    }

}
