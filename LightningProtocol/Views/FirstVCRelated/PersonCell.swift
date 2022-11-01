//
//  PersonCell.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/01.
//

import UIKit

class PersonCell: UICollectionViewCell {
    
    // TODO: cellViewModel and cellView
    
    var viewModel = PersonCellModel() {
        didSet {
            
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

extension PersonCell: Presentable {
    func initViewHierarchy() {
        
    }
    
    func configureView() {
        
    }
    
    func bind() {
        
    }
    
    func configureCell(viewModel: PersonCellModel) {
        self.viewModel = viewModel
    }
}
