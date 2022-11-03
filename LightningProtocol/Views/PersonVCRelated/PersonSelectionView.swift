//
//  PersonSelectionView.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/01.
//

import UIKit
import SwiftUI

class PersonSelectionView: UIView, PersonSelectionViewStyling {

    //input
    var viewModel: PersonSelectionViewModel
    
    //output
    
    //properties
    var maleButton: UIButton = UIButton()
    var femaleButton: UIButton = UIButton()
    
    init(viewModel: PersonSelectionViewModel) {
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

extension PersonSelectionView: Presentable {
    func initViewHierarchy() {
        self.addSubview(maleButton)
        self.addSubview(femaleButton)
        
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        femaleButton.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraints) }
        
        constraints += [
            maleButton.topAnchor.constraint(equalTo: self.topAnchor),
            maleButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            maleButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        constraints += [
            femaleButton.topAnchor.constraint(equalTo: self.topAnchor),
            femaleButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            femaleButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        constraints += [
            maleButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            femaleButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5)
        ]
    }
    
    func configureView() {
        maleButton.addStyles(style: manButtonStyle)
        femaleButton.addStyles(style: womanButtonStyle)
    }
    
    func bind() {
        maleButton.addTarget(self, action: #selector(maleButtonAction(_:)), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(femaleButtonAction(_:)), for: .touchUpInside)
        
        viewModel.populateSelectedTypeToSelectionView = { [weak self] genderType in
            guard let self = self else { return }
            switch genderType {
            case .male:
                self.maleButton.isSelected = true
                self.femaleButton.isSelected = false
            case .female:
                self.maleButton.isSelected = false
                self.femaleButton.isSelected = true
            }
        }
        
        viewModel.didSegmentChange(.male)
    }
    
    @objc func maleButtonAction(_ sender: UIButton) {
        viewModel.didSegmentChange(.male)
    }
    
    @objc func femaleButtonAction(_ sender: UIButton) {
        viewModel.didSegmentChange(.female)
    }
    
    
}

#if canImport(SwiftUI) && DEBUG
struct PersonSelectionViewPreview<View: UIView>: UIViewRepresentable {
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
struct PersonSelectionViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        PersonSelectionViewPreview {
            let view = PersonSelectionView(viewModel: PersonSelectionViewModel())
            return view
        }.previewLayout(.fixed(width: 390, height: 100))
    }
}


#endif
