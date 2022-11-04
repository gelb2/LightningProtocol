//
//  ProfileZoomContentView.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/02.
//

import UIKit

class ProfileZoomContentView: UIView {
    
    //input
    
    //output
    
    //properties
    
    var viewModel: ProfileZoomContentViewModel
    var scrollView: UIScrollView = UIScrollView()
    var imageView: CacheImageView = CacheImageView()

    init(viewModel: ProfileZoomContentViewModel) {
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

extension ProfileZoomContentView: Presentable {
    func initViewHierarchy() {
        self.addSubview(scrollView)
        self.scrollView.addSubview(imageView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        constraint += [
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        constraint += [
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ]
    }
    
    func configureView() {
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
    
    func bind() {
        scrollView.delegate = self
        
        viewModel.loadImage = { [weak self] urlString in
            guard let self = self else { return }
            self.imageView.loadImage(urlString: urlString)
        }
    }
}

extension ProfileZoomContentView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
