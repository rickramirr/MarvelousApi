//
//  ComicListView.swift
//  MarvelousApi
//
//  Created by Ricardo Ramirez on 10/09/21.
//

import UIKit
import Combine

class ComicListView: UIViewController {
    
    var viewModel = ComicListViewModel()
    
    private enum ComicSection: CaseIterable {
        case all
    }
    
    private var dataSource: UITableViewDiffableDataSource<ComicSection,Comic>?
    
    var comicsCancellable: AnyCancellable?
        
    var isLoadingCancellable: AnyCancellable?
    
    private lazy var table: UITableView = {
        let table = UITableView()
        return table
    }()
    
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
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(table)
    }
    
    private func activateConstraints() {
        table.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureTable() {
        let dataSource = makeDataSource()
        self.dataSource = dataSource
        table.dataSource = dataSource
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
    }
    
    func updateUI(withComics comics: [Comic]) {
        var snapshot = NSDiffableDataSourceSnapshot<ComicSection,Comic>()
        snapshot.appendSections([.all])
        snapshot.appendItems(comics)
        dataSource?.apply(snapshot)
    }
    
    func updateUI(withIsLoading: Bool) {
        
    }
    
}

extension ComicListView: UITableViewDelegate {
    
}

private extension ComicListView {
    
    private func makeDataSource() -> UITableViewDiffableDataSource<ComicSection,Comic> {
        return UITableViewDiffableDataSource<ComicSection,Comic>(tableView: table) { (table, indexPath, comic) -> UITableViewCell? in
            let cell = table.dequeueReusableCell(withIdentifier: ComicCell.cellIdentifier, for: indexPath) as? ComicCell
            cell?.updateUI(withComic: comic)
            return cell
        }
    }
    
}
