//
//  PersonGridView.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/02.
//

import UIKit
import SwiftUI

class PersonGridView: UIView, PersonGridCellStyling {
    
    //input
    var didReceiveViewModel: (PersonCellModel) -> () = { model in}
    
    //output
    
    //properties
    
    var nameLabel: UILabel = UILabel()
    var locationLabel: UILabel = UILabel()
    var emailLabel: UILabel = UILabel()
    var profileImageView = CacheImageView()
    var verticalStackView = UIStackView()
    
    private var privateCellViewModel: PersonCellModel = PersonCellModel()
    
    init() {
        super.init(frame: .zero)
        initViewHierarchy()
        configureView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PersonGridView: Presentable {
    func initViewHierarchy() {
        
        self.addSubview(profileImageView)
        self.addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(locationLabel)
        verticalStackView.addArrangedSubview(emailLabel)
        
        self.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        verticalStackView.arrangedSubviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        constraint += [
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor)
        ]
        
        constraint += [
            verticalStackView.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 8),
            verticalStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ]
        
    }
    
    func configureView() {
        
        profileImageView.addStyles(style: cellProfileImageViewStyling)
        
        verticalStackView.addStyles(style: cellVerticalStackViewStyling)
    }
    
    func bind() {
        
        didReceiveViewModel = { [weak self] model in
            guard let self = self else { return }
            self.privateCellViewModel = model
            self.nameLabel.text = self.privateCellViewModel.name
            self.locationLabel.text = self.privateCellViewModel.location
            self.emailLabel.text = self.privateCellViewModel.email
            self.profileImageView.loadImage(urlString: self.privateCellViewModel.thumbImageURLString)
        }
    }
    
    @objc func tapMethod() {
    }
    
    
}

#if canImport(SwiftUI) && DEBUG
struct PersonGridViewPreview<View: UIView>: UIViewRepresentable {
    let view: View
    
    init(_ builder: @escaping () -> View) {
        self.view = builder()
    }
    
    func makeUIView(context: Context) -> some UIView {
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

#endif

#if canImport(SwiftUI) && DEBUG
struct PersonGridViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        PersonGridViewPreview {
            let view = PersonGridView()
            return view
        }.previewLayout(.fixed(width: 160, height: 160))
    }
}


#endif
