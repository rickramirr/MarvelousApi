//
//  ComicListView.swift
//  MarvelousApi
//
//  Created by Ricardo Ramirez on 10/09/21.
//

import UIKit
import Combine

class ComicListView: UIViewController {
    
    var coordinator: MainCoordinator?
    
    var viewModel = ComicListViewModel()
    
    var comicsCancellable: AnyCancellable?
        
    var isLoadingCancellable: AnyCancellable?
    
    var errorCancellable: AnyCancellable?
    
    private lazy var table: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        return table
    }()
    
    private lazy var loader = LoadingViewController()
    
    override func loadView() {
        super.loadView()
        setupUI()
        activateConstraints()
        configureTable()
        configureObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.requestComics()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        title = "Marvelous"
        view.backgroundColor = .systemBackground
        view.addSubview(table)
    }
    
    private func activateConstraints() {
        table.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureTable() {
        table.dataSource = self
        table.delegate = self
        table.register(ComicCell.self, forCellReuseIdentifier: ComicCell.cellIdentifier)
    }
    
    private func configureObservers() {
        comicsCancellable = viewModel.$comics
            .receive(on: DispatchQueue.main)
            .sink { [weak self] comics in
                self?.updateUI(withComics: comics)
            }
        isLoadingCancellable = viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.updateUI(withIsLoading: isLoading)
            }
        errorCancellable = viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let error = error else {
                    return
                }
                self?.updateUI(withError: error)
            }
    }
    
    func updateUI(withComics comics: [Comic]) {
        table.reloadData()
    }
    
    func updateUI(withIsLoading isLoading: Bool) {
        if isLoading {
            add(loader)
        } else {
            loader.remove()
        }
    }
    
    func updateUI(withError error: String) {
        coordinator?.showSimpleAlert(
            withTitle: "Error",
            message: "Something happened. Error: \(error)",
            actionTitle: "Ok"
        )
    }
    
}

extension ComicListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            viewModel.getComicsIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showComicDetail(viewModel.comics[indexPath.row])
    }
    
}

extension ComicListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.comics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: ComicCell.cellIdentifier, for: indexPath) as! ComicCell
        cell.updateUI(withComic: viewModel.comics[indexPath.row])
        return cell
    }
    
}
