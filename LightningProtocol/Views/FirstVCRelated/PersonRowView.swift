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
    @MainThreadActor var didReceiveViewModel: ((PersonCellModel) -> ())?
    
    //output
    
    //properties
    
    var nameLabel: UILabel = UILabel()
    var locationLabel: UILabel = UILabel()
    var emailLabel: UILabel = UILabel()
    var profileImageView = CacheImageView()
    var verticalStackView = UIStackView()
    
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
            profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor)
        ]
        
        constraint += [
            verticalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
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
            self.nameLabel.text = model.name
            self.locationLabel.text = model.location
            self.emailLabel.text = model.email
            self.profileImageView.loadImage(urlString: model.thumbImageURLString)
        }
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
        }.previewLayout(.fixed(width: 390, height: 100))
    }
}


#endif
