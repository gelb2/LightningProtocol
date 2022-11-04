//
//  PersonGridCell.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/02.
//

import UIKit

class PersonGridCell: UICollectionViewCell {
    
    var cellView: PersonGridView = PersonGridView()
    
    var viewModel = PersonCellModel() {
        didSet {
            cellView.didReceiveViewModel(viewModel)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewHierarchy()
        configureView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PersonGridCell: Presentable {
    func initViewHierarchy() {
        self.addSubview(cellView)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        constraint += [
            cellView.topAnchor.constraint(equalTo: self.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
    }
    
    func configureView() {
        
    }
    
    func bind() {
        
    }
    
    func configureCell(viewModel: PersonCellModel) {
        self.viewModel = viewModel
    }
}

