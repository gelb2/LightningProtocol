//
//  ViewController.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/30.
//

import UIKit

class PersonViewController: UIViewController, PersonViewControllerRoutable, PersonViewStyling {

    var model: PersonModel
    lazy var selectionView: PersonSelectionView = PersonSelectionView(viewModel: self.model.selectionViewModel)
    lazy var manContentView: PersonContentView = PersonContentView(viewModel: self.model.manViewModel)
    lazy var womanContentView: PersonContentView = PersonContentView(viewModel: self.model.womanViewModel)
    
    lazy var layoutSelectionView: LayoutSelectionView = LayoutSelectionView(viewModel: self.model.layoutSelectionViewModel)
    
    var scrollView: UIScrollView = UIScrollView()
    
    var trashButton = UIBarButtonItem()
    
    init(viewModel: PersonModel) {
        self.model = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        initViewHierarchy()
        configureView()
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.populateData()
        // Do any additional setup after loading the view.
    }


}

extension PersonViewController: Presentable {
    func initViewHierarchy() {
        self.view = UIView()
        
        self.view.addSubview(selectionView)
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(manContentView)
        scrollView.addSubview(womanContentView)
        
        self.view.addSubview(layoutSelectionView)
        
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        manContentView.translatesAutoresizingMaskIntoConstraints = false
        womanContentView.translatesAutoresizingMaskIntoConstraints = false
        
        layoutSelectionView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        constraint += [
            selectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            selectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            selectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            selectionView.heightAnchor.constraint(equalToConstant: 48)
        ]
        
        constraint += [
            scrollView.topAnchor.constraint(equalTo: self.selectionView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        
        constraint += [
            manContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            manContentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            manContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            manContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            manContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ]
        
        constraint += [
            womanContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            womanContentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            womanContentView.leadingAnchor.constraint(equalTo: manContentView.trailingAnchor),
            womanContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            womanContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            womanContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ]
        
        constraint += [
            layoutSelectionView.widthAnchor.constraint(equalToConstant: 40),
            layoutSelectionView.heightAnchor.constraint(equalToConstant: 40),
            layoutSelectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            layoutSelectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16)
        ]
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        navigationItem.title = "??????"
        
        trashButton.addStyles(style: trashButtonStyling)
        trashButton.target = self
        trashButton.action = #selector(trashAction)

        scrollView.isPagingEnabled = true
    }
    
    func bind() {
        scrollView.delegate = self
        
        model.routeSubject = { [weak self] sceneCategory in
            guard let self = self else { return }
            self.route(to: sceneCategory)
        }
        
        model.scrollSubject = { [weak self] genderType in
            guard let self = self else { return }
            switch genderType {
            case .male:
                self.scrollView.scrollToView(view: self.manContentView, animated: true)
            case .female:
                self.scrollView.scrollToView(view: self.womanContentView, animated: true)
            }
        }
        
        model.propergateTrashItemButtonShow = { [weak self] isHidden in
            guard let self = self else { return }
            if isHidden {
                self.navigationItem.setRightBarButton(self.trashButton, animated: true)
            } else {
                self.navigationItem.setRightBarButton(nil, animated: true)
                
            }
        }
    }
    
    @objc func trashAction() {
        model.didTapTrashItemButton()
    }
}

extension PersonViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let manViewFrame = scrollView.convert(manContentView.bounds, from: manContentView)
        let womanViewFrame = scrollView.convert(womanContentView.bounds, from: womanContentView)
        
        if manViewFrame.intersects(scrollView.bounds) {
            model.scrollToGenderTapMonitor(.male)
        }
        
        if womanViewFrame.intersects(scrollView.bounds) {
            model.scrollToGenderTapMonitor(.female)
        }
    }
}
