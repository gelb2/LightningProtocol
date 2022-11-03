//
//  PopupView.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/02.
//

import UIKit

class PopupView: UIView {

    var viewModel: PopupViewModel
    
    var listButton: UIButton = UIButton()
    var gridButton: UIButton = UIButton()
    
    var verticalStackView: UIStackView = UIStackView()
    
    init(viewModel: PopupViewModel) {
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

extension PopupView: Presentable {
    func initViewHierarchy() {
        self.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        verticalStackView.addArrangedSubview(listButton)
        verticalStackView.addArrangedSubview(gridButton)
        verticalStackView.arrangedSubviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        constraint += [
            verticalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
    }
    
    func configureView() {
        // TODO: styling
        self.backgroundColor = .white
        verticalStackView.axis = .vertical
        
        listButton.setTitle("리스트", for: .normal)
        listButton.setTitleColor(.black, for: .normal)
        gridButton.setTitle("그리드", for: .normal)
        gridButton.setTitleColor(.black, for: .normal)
    }
    
    func bind() {
        listButton.addTarget(self, action: #selector(listAction), for: .touchUpInside)
        gridButton.addTarget(self, action: #selector(gridAction), for: .touchUpInside)
    }
    
    @objc func listAction() {
        viewModel.didReceiveButtonTap(.list)
    }
    
    @objc func gridAction() {
        viewModel.didReceiveButtonTap(.grid)
    }
    
    
}
