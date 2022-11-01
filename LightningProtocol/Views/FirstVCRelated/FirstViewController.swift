//
//  ViewController.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/30.
//

import UIKit

class FirstViewController: UIViewController, FirstViewControllerRoutable {

    var model: FirstModel
    lazy var selectionView: PersonSelectionView = PersonSelectionView(viewModel: self.model.selectionViewModel)
    lazy var manContentView: PersonContentView = PersonContentView(viewModel: self.model.manViewModel)
    lazy var womanContentView: PersonContentView = PersonContentView(viewModel: self.model.womanViewModel)
    
    var scrollView: UIScrollView = UIScrollView()
    
    init(viewModel: FirstModel) {
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
        print("first vc viewDidLoad")
        model.populateData()
        // Do any additional setup after loading the view.
    }


}

extension FirstViewController: Presentable {
    func initViewHierarchy() {
        self.view = UIView()
        navigationItem.title = "목록"
        
        self.view.addSubview(selectionView)
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(manContentView)
        scrollView.addSubview(womanContentView)
        
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        
        manContentView.translatesAutoresizingMaskIntoConstraints = false
        womanContentView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        // TODO: 스크롤뷰 서브뷰 관련 오토레이아웃 다시 확인
        
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
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        // TODO: 스크롤뷰 좌우 스크롤 관련해서 더 자연스럽게 처리
        scrollView.isPagingEnabled = true
    }
    
    func bind() {
        model.routeSubject = { [weak self] sceneCategory in
            guard let self = self else { return }
            self.route(to: sceneCategory)
        }
    }
}

