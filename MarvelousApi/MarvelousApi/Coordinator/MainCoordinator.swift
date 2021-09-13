//
//  MainCoordinator.swift
//  MarvelousApi
//
//  Created by Ricardo Ramirez on 11/09/21.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ComicListView()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showComicDetail(_ comic: Comic) {
        let vc = ComicDetailView()
        vc.coordinator = self
        vc.updateUI(withComic: comic)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showSimpleAlert(withTitle title: String, message: String, actionTitle: String, actionCompletion: (() -> Void)? = nil) {
        let vc = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        vc.addAction(
            UIAlertAction(
                title: actionTitle,
                style: .default,
                handler: { action in
                    if let completion = actionCompletion {
                        completion()
                    }
                }
            )
        )
        navigationController.present(vc, animated: true, completion: nil)
    }
    
}
