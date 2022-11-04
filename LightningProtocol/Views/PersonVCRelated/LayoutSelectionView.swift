//
//  LayoutSelectionView.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/02.
//

import UIKit

class LayoutSelectionView: UIView, LayoutSelectionViewStyling {

    var viewModel: LayoutSelectionViewModel
    
    var layoutButton: UIButton = UIButton(type: .custom)
    
    init(viewModel: LayoutSelectionViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        initViewHierarchy()
        configureView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LayoutSelectionView: Presentable {
    func initViewHierarchy() {
        self.addSubview(layoutButton)
        layoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        constraint += [
            layoutButton.topAnchor.constraint(equalTo: self.topAnchor),
            layoutButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            layoutButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            layoutButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
    }
    
    func configureView() {
        self.backgroundColor = .clear
        layoutButton.addStyles(style: flotingButtonStyle)
    }
    
    func bind() {
        layoutButton.addTarget(self, action: #selector(layoutButtonAction), for: .touchUpInside)
    }
    
    @objc func layoutButtonAction() {
        viewModel.didReceiveTapEvent()
    }
}
