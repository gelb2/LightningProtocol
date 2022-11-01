//
//  ViewController.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/30.
//

import UIKit

class FirstViewController: UIViewController, FirstViewControllerRoutable {

    var model: FirstModel
    
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
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(manContentView)
        scrollView.addSubview(womanContentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        manContentView.translatesAutoresizingMaskIntoConstraints = false
        womanContentView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        constraint += [
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        
        // TODO: 스크롤뷰 서브뷰 관련 오토레이아웃 다시 확인
        
        constraint += [
            manContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            manContentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            manContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            manContentView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        ]
        
        constraint += [
            womanContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            womanContentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            womanContentView.leadingAnchor.constraint(equalTo: manContentView.trailingAnchor),
            womanContentView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        ]
    }
    
    func configureView() {
        view.backgroundColor = .white
    }
    
    func bind() {
        model.routeSubject = { [weak self] sceneCategory in
            guard let self = self else { return }
            self.route(to: sceneCategory)
        }
    }
}

