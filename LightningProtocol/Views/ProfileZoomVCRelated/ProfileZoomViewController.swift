//
//  ProfileZoomViewController.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/30.
//

import UIKit

class ProfileZoomViewController: UIViewController {

    var model: ProfileZoomModel
    
    lazy var contentView: ProfileZoomContentView = ProfileZoomContentView(viewModel: model.profileZoomContentViewModel)
    
    init(viewModel: ProfileZoomModel) {
        self.model = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileZoomViewController: Presentable {
    func initViewHierarchy() {
        self.view = UIView()
        self.view.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        constraint += [
            contentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
    }
    
    func configureView() {
        view.backgroundColor = .white
        navigationItem.title = "프로필이미지"
    }
    
    func bind() {
        
    }
    
    
}
