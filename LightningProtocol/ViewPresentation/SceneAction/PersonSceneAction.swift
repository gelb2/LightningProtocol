//
//  PersonSceneAction.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/30.
//

import Foundation

enum PersonSceneAction: SceneAction {
    case refresh
    case refreshWithCollectionLayout(layout: collectionType)
}
