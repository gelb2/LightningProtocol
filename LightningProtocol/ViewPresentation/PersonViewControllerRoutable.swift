//
//  PersonViewControllerRoutable.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/30.
//

import Foundation
import UIKit

protocol PersonViewControllerRoutable: Routable, PersonViewControllerSceneBuildable {
    
}

extension PersonViewControllerRoutable where Self: PersonViewController {
    func buildScene(scene: SceneCategory) -> Scenable? {
        var nextScene: Scenable?
        switch scene {
        case .detail(.profileZoomViewController(let context)):
            nextScene = buildSecondScene(context: context)
        case .alert(.itemAlert(.deleteSelectedItem(let context))):
            nextScene = buildAlert(context: context)
        case .detail(.layoutSelectionViewController(let context)):
            nextScene = buildThirdScene(context: context)
        default: break
        }
        return nextScene
    }
    
    func route(to Scene: SceneCategory) {
        switch Scene {
        case .detail(.profileZoomViewController):
            let nextScene = buildScene(scene: Scene)
            guard let nextVC = nextScene as? UIViewController else { return }
            self.navigationController?.pushViewController(nextVC, animated: true)
        case .alert:
            guard let scene = buildScene(scene: Scene) else { return }
            guard let nextVC = scene as? UIViewController else { return }
            present(nextVC, animated: true)
        case .detail(.layoutSelectionViewController):
            let nextScene = buildScene(scene: Scene)
            guard let nextVC = nextScene as? UIViewController else { return }
            nextVC.modalPresentationStyle = .overFullScreen
            nextVC.modalTransitionStyle = .crossDissolve
            self.present(nextVC, animated: true)
        default: break
        }
    }
}

protocol PersonViewControllerSceneBuildable: SceneBuildable {
    
}

extension PersonViewControllerSceneBuildable {
    
    func buildAlert(context: AlertDependency) -> Scenable {
        let nextScene: Scenable
        
        let alert = AlertFactory(dependency: context).createAlert()
        nextScene = alert
        return nextScene
    }
    
    func buildSecondScene(context: SceneContext<ProfileZoomModel>) -> Scenable {
        var nextScene: Scenable
        let secondModel = context.dependency
        let secondVC = ProfileZoomViewController(viewModel: secondModel)
        nextScene = secondVC
        
        return nextScene
    }
    
    func buildThirdScene(context: SceneContext<LayoutSelectionModel>) -> Scenable {
        var nextScene: Scenable
        let model = context.dependency
        let thirdVC = LayoutSelectionViewController(viewModel: model)
        nextScene = thirdVC
        
        return nextScene
    }
}
