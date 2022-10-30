//
//  SecondViewController.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/30.
//

import UIKit

class SecondViewController: UIViewController {

    var model: SecondModel
    
    init(viewModel: SecondModel) {
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

extension SecondViewController: Presentable {
    func initViewHierarchy() {
        
    }
    
    func configureView() {
        
    }
    
    func bind() {
        
    }
    
    
}
