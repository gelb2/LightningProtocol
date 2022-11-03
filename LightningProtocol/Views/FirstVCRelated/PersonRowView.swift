//
//  PersonRowView.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/01.
//

import UIKit
import SwiftUI

class PersonRowView: UIView, PersonRowCellStyling {
    
    //input
    var didReceiveViewModel: (PersonCellModel) -> () = { model in}
    
    //output
    var toggleUIAsSelectedEvent: (Bool) -> () = { isSelected in }
    
    //properties
    
    var nameLabel: UILabel = UILabel()
    var locationLabel: UILabel = UILabel()
    var emailLabel: UILabel = UILabel()
    var profileImageView = CacheImageView()
    var checkImageView = UIImageView()
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

extension PersonRowView: Presentable {
    func initViewHierarchy() {
        
        self.addSubview(profileImageView)
        self.addSubview(verticalStackView)
        profileImageView.addSubview(checkImageView)
        
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(locationLabel)
        verticalStackView.addArrangedSubview(emailLabel)
        
        self.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        verticalStackView.arrangedSubviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        checkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        constraint += [
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor)
        ]
        
        constraint += [
            checkImageView.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 4),
            checkImageView.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 4),
            checkImageView.widthAnchor.constraint(equalToConstant: 32),
            checkImageView.heightAnchor.constraint(equalTo: checkImageView.widthAnchor)
        ]
        
        constraint += [
            verticalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            verticalStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ]
        
    }
    
    // TODO: style
    func configureView() {
        
        profileImageView.addStyles(style: cellProfileImageViewStyling)
        
        verticalStackView.addStyles(style: cellVerticalStackViewStyling)
        checkImageView.addStyles(style: cellCheckImageViewStyling)
        
        nameLabel.addStyles(style: cellNameLabelStyling)
        locationLabel.addStyles(style: cellLocationLabelStyling)
        emailLabel.addStyles(style: cellEmailLabelStyling)
    }
    
    func bind() {
        
        didReceiveViewModel = { [weak self] model in
            guard let self = self else { return }
            self.privateCellViewModel = model
            self.nameLabel.text = self.privateCellViewModel.name
            self.locationLabel.text = self.privateCellViewModel.location
            self.emailLabel.text = self.privateCellViewModel.email
            self.profileImageView.loadImage(urlString: self.privateCellViewModel.thumbImageURLString)
            self.checkImageView.isHidden = !self.privateCellViewModel.isSelected
            self.privateCellViewModel.toggleUIAsSelectedEvent = self.toggleUIAsSelectedEvent
        }
        
        toggleUIAsSelectedEvent = { [weak self] isSelected in
            guard let self = self else { return }
            self.checkImageView.isHidden = !self.privateCellViewModel.isSelected
        }
    }
    
    @objc func tapMethod() {
    }
    
    
}

#if canImport(SwiftUI) && DEBUG
struct PersonRowViewPreview<View: UIView>: UIViewRepresentable {
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
struct PersonRowViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        PersonRowViewPreview {
            let view = PersonRowView()
            return view
        }.previewLayout(.fixed(width: 100, height: 100))
    }
}


#endif
