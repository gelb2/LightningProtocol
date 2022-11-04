//
//  LayoutSelectionViewControllerRoutable.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/30.
//

import Foundation
import UIKit

protocol LayoutSelectionViewControllerRoutable: Routable, LayoutSelectionViewControllerSceneBuildable {
    
}
    
extension LayoutSelectionViewControllerRoutable where Self: LayoutSelectionViewController {
    func buildScene(scene: SceneCategory) -> Scenable? {
        var nextScene: Scenable?
        switch scene {
        default: break
        }
        return nextScene
    }
    
    func route(to Scene: SceneCategory) {
        switch Scene {
        case .close:
            self.dismiss(animated: true)
        case .main(.personViewControllerWithAction):
            sendAction(scene: Scene)
            self.dismiss(animated: true)
        case .alert:
            guard let scene = buildScene(scene: Scene) else { return }
            guard let nextVC = scene as? UIViewController else { return }
            present(nextVC, animated: true)
        default: break
        }
    }
    
    func sendAction(scene: SceneCategory) {
        switch scene {
        case .main(.personViewControllerWithAction(let context)):
            guard let presentingNavi = self.presentingViewController as? UINavigationController else { return }
            guard let firstVC = presentingNavi.viewControllers.first(where: { $0 is PersonViewController }) as? PersonViewController else { return }
            let action = context.dependency
            firstVC.model.didReceiveSceneAction(action)
            break
        default: break
        }
    }
}

protocol LayoutSelectionViewControllerSceneBuildable: SceneBuildable {
    
}

extension LayoutSelectionViewControllerSceneBuildable {
    func buildAlert(context: AlertDependency) -> Scenable {
        let nextScene: Scenable
        
        let alert = AlertFactory(dependency: context).createAlert()
        nextScene = alert
        return nextScene
    }
}
