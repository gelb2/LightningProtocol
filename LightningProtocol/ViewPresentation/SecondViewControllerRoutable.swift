//
//  SecondViewControllerRoutable.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/30.
//

import Foundation
import UIKit

protocol SecondViewControllerRoutable: Routable, SecondViewControllerSceneBuildable { }

extension SecondViewControllerRoutable where Self: SecondViewController {
    
    func route(to Scene: SceneCategory) {
        switch Scene {
        case .close:
            self.dismiss(animated: true)
        case .closeWithAction(let scene):
            sendAction(scene: scene)
            self.navigationController?.popViewController(animated: true)
        case .alert:
            guard let scene = buildScene(scene: Scene) else { return }
            guard let nextVC = scene as? UIViewController else { return }
            present(nextVC, animated: true)
        case .detail(.thirdViewController):
            guard let nextScene = buildScene(scene: Scene) as? UIViewController else { return }
            self.navigationController?.pushViewController(nextScene, animated: true)
        default: break
        }
    }
    
    func sendAction(scene: SceneCategory) {
        switch scene {
        case .main(.firstViewControllerWithAction(let context)):
            guard let firstVC = self.navigationController?.viewControllers.first(where: { $0 is FirstViewController }) as? FirstViewController else { return }
            let action = context.dependency
            firstVC.model.didReceiveSceneAction(action)
            break
        default: break
        }
    }
}

protocol SecondViewControllerSceneBuildable: SceneBuildable {
    
}

extension SecondViewControllerSceneBuildable where Self: SecondViewController {
    func buildScene(scene: SceneCategory) -> Scenable? {
        var nextScene: Scenable?
        switch scene {
        case .alert(.networkAlert(.normalErrorAlert(let context))):
            nextScene = buildAlert(context: context)
        case .detail(.thirdViewController(let context)):
            nextScene = buildThirdScene(context: context)
        default: break
        }
        
        return nextScene
    }
}

extension SecondViewControllerSceneBuildable where Self: SecondViewController {
    
    func buildAlert(context: AlertDependency) -> Scenable {
        let nextScene: Scenable
        
        let alert = AlertFactory(dependency: context).createAlert()
        nextScene = alert
        return nextScene
    }
    
    func buildThirdScene(context: SceneContext<ThirdModel>) -> Scenable {
        var nextScene: Scenable
        let thirdModel = context.dependency
        let thirdVC = ThirdViewController(viewModel: thirdModel)
        nextScene = thirdVC
        
        return nextScene
    }
}