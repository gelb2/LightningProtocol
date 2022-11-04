//
//  PersonContentView.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/31.
//

import UIKit

class PersonContentView: UIView, PersonContentViewStyling, ActivityIndicatorViewStyling {

    var viewModel: PersonListViewModel
    
    lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: createListLayout())
    
    var listLayout: UICollectionViewCompositionalLayout?
    var gridLayout: UICollectionViewCompositionalLayout?
    
    private let rowCellIdentitier = "PersonRowCell"
    private let gridCellIdentifier = "PersonGridCell"
    
    var layoutMode: collectionType = .list
    
    let refreshControl = UIRefreshControl()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    init(viewModel: PersonListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        initViewHierarchy()
        configureView()
        bind()
        
        listLayout = createListLayout()
        gridLayout = createGridLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private func createListLayout() -> UICollectionViewCompositionalLayout {
        let itemFractionalWidthFraction = 1.0
        let groupFractionalHeightFraction = 1.0 / 6.0
        let itemInset: CGFloat = 2.5
        
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemFractionalWidthFraction), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(groupFractionalHeightFraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func createGridLayout() -> UICollectionViewCompositionalLayout {

        let itemFractionalWidthFraction = 1.0 / 2.0
        let groupFractionalHeightFraction = 1.0 / 4.0
        let itemInset: CGFloat = 2.5
        
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemFractionalWidthFraction), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(groupFractionalHeightFraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    

}

extension PersonContentView: Presentable {
    func initViewHierarchy() {
        self.addSubview(collectionView)
        self.addSubview(activityIndicator)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraints) }
        
        constraints += [
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        constraints += [
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
    }
    
    func configureView() {
        self.backgroundColor = .white
        collectionView.addStyles(style: collectionViewStyle)
        activityIndicator.addStyles(style: indicatorStyle)
    }
    
    func bind() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PersonRowCell.self, forCellWithReuseIdentifier: rowCellIdentitier)
        collectionView.register(PersonGridCell.self, forCellWithReuseIdentifier: gridCellIdentifier)
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        viewModel.didReceiveViewModel = { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
        
        viewModel.didReceiveSomeItemTrashed = { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
        
        viewModel.turnOnRefreshControl = { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.refreshControl?.beginRefreshing()
        }
        
        viewModel.turnOffRefreshControl = { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.refreshControl?.endRefreshing()
        }
        
        viewModel.turnOnIndicator = { [weak self] _ in
            guard let self = self else { return }
            self.activityIndicator.startAnimating()
        }
        
        viewModel.turnOffIndicator = { [weak self] _ in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
        }
        
        viewModel.populateRefreshCollectionLayoutEvent = { [weak self] type in
            guard let self = self else { return }
            switch type {
            case .list:
                guard let listLayout = self.listLayout else { return }
                self.collectionView.setCollectionViewLayout(listLayout, animated: false)
                self.collectionView.reloadData()
                self.layoutMode = type
            case .grid:
                guard let gridLayout = self.gridLayout else { return }
                self.collectionView.setCollectionViewLayout(gridLayout, animated: false)
                self.collectionView.reloadData()
                self.layoutMode = type
            }
        }
    }
    
    @objc func refresh() {
        viewModel.didReceiveRefreshEvent()
    }
}

extension PersonContentView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(indexPath.item)
    }
}

extension PersonContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch layoutMode {
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rowCellIdentitier, for: indexPath) as? PersonRowCell else { fatalError() }
            let model = viewModel.dataSource[indexPath.item]
            cell.configureCell(viewModel: model)
            return cell
        case .grid:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCellIdentifier, for: indexPath) as? PersonGridCell else { fatalError() }
            let model = viewModel.dataSource[indexPath.item]
            cell.configureCell(viewModel: model)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.didReceiveIndexPathItem(indexPath.item)
    }
    
}
