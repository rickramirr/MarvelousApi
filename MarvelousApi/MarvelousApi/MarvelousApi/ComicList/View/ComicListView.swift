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
    
    private lazy var table: UITableView = {
        let table = UITableView()
        return table
    }()
    
    override func loadView() {
        super.loadView()
        setupUI()
        activateConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func updateUI(withComics comics: [Comic]) {
        var snapshot = NSDiffableDataSourceSnapshot<ComicSection,Comic>()
        snapshot.appendSections([.all])
        snapshot.appendItems(comics)
        dataSource?.apply(snapshot)
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
