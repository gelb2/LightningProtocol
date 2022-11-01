//
//  PersonContentView.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/31.
//

import UIKit

class PersonContentView: UIView, PersonContentViewStyling {

    var viewModel: PersonListViewModel
    
    // TODO: 콜렉션뷰 컴포지셔널 레이아웃 도입 후 레이아웃 1단, 2단 변경 요구사항 구현 추가
    private let layout = UICollectionViewFlowLayout()
    lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private let reuseIdentifier = "PersonRowCell"
    
    init(viewModel: PersonListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        initViewHierarchy()
        configureView()
        bind()
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

}

extension PersonContentView: Presentable {
    func initViewHierarchy() {
        self.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraints) }
        
        constraints += [
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
    }
    
    func configureView() {
        self.backgroundColor = .white
        collectionView.addStyles(style: collectionViewStyle)
        
        layout.addStyles(style: collectionViewFlowLayoutStyle)
    }
    
    func bind() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PersonRowCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        viewModel.didReceiveViewModel = { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
    
    
}

extension PersonContentView: UICollectionViewDelegate {
    
}

extension PersonContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("viewModel count : \(viewModel.dataSource.count)")
        return viewModel.dataSource.count
    }
    
    // TODO: 컴포지셔널 레이아웃에 따른 셀 디큐 다르게 하기 처리?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PersonRowCell else {
            fatalError()
        }
        let model = viewModel.dataSource[indexPath.item]
        cell.configureCell(viewModel: model)
        return cell
    }
    
}
