//
//  SecondViewControllerRoutable.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/30.
//

import Foundation
import UIKit

protocol SecondViewControllerRoutable: Routable, SecondViewControllerSceneBuildable { }

extension SecondViewControllerRoutable where Self: ProfileZoomViewController {
    
    func route(to Scene: SceneCategory) {
        switch Scene {
        case .close:
            self.dismiss(animated: true)
        case .alert:
            guard let scene = buildScene(scene: Scene) else { return }
            guard let nextVC = scene as? UIViewController else { return }
            present(nextVC, animated: true)
        case .detail(.layoutSelectionViewController):
            guard let nextScene = buildScene(scene: Scene) as? UIViewController else { return }
            self.navigationController?.pushViewController(nextScene, animated: true)
        default: break
        }
    }
    
    func sendAction(scene: SceneCategory) {
        switch scene {
        case .main(.personViewControllerWithAction(let context)):
            guard let firstVC = self.navigationController?.viewControllers.first(where: { $0 is PersonViewController }) as? PersonViewController else { return }
            let action = context.dependency
            firstVC.model.didReceiveSceneAction(action)
            break
        default: break
        }
    }
}

protocol SecondViewControllerSceneBuildable: SceneBuildable {
    
}

extension SecondViewControllerSceneBuildable where Self: ProfileZoomViewController {
    func buildScene(scene: SceneCategory) -> Scenable? {
        var nextScene: Scenable?
        switch scene {
        case .alert(.networkAlert(.normalErrorAlert(let context))):
            nextScene = buildAlert(context: context)
        case .detail(.layoutSelectionViewController(let context)):
            nextScene = buildThirdScene(context: context)
        default: break
        }
        
        return nextScene
    }
}

extension SecondViewControllerSceneBuildable where Self: ProfileZoomViewController {
    
    func buildAlert(context: AlertDependency) -> Scenable {
        let nextScene: Scenable
        
        let alert = AlertFactory(dependency: context).createAlert()
        nextScene = alert
        return nextScene
    }
    
    func buildThirdScene(context: SceneContext<LayoutSelectionModel>) -> Scenable {
        var nextScene: Scenable
        let thirdModel = context.dependency
        let thirdVC = LayoutSelectionViewController(viewModel: thirdModel)
        nextScene = thirdVC
        
        return nextScene
    }
}
