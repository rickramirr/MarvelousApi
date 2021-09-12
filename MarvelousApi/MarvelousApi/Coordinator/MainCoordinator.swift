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
    
    func viewComicDetail(_ comic: Comic) {
        let vc = ComicDetailView()
        vc.coordinator = self
        vc.updateUI(withComic: comic)
        navigationController.pushViewController(vc, animated: true)
    }
    
}
