//
//  SceneCategory.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/30.
//

import Foundation

//앱 전반적으로 present, push될 뷰컨트롤러의 열거형들
enum SceneCategory {
    case main(mainScene)
    case detail(detailScene)
    case close //리프래시 등 아무것도 안 하고 닫는 경우
    case alert(alertScene)
    
    enum mainScene {
        case personViewController(context: SceneContext<PersonModel>)
        case personViewControllerWithAction(context: SceneContext<PersonSceneAction>)
    }
    
    enum detailScene {
        case profileZoomViewController(context: SceneContext<ProfileZoomModel>)
        case layoutSelectionViewController(context: SceneContext<LayoutSelectionModel>)
    }
    
    enum alertScene {
        case networkAlert(networkError)
        case itemAlert(itemRelated)
        
        enum networkError {
            case normalErrorAlert(AlertDependency)
        }
        
        enum itemRelated {
            case deleteSelectedItem(AlertDependency)
        }
        
        enum detailViewRelated {
            case notDefinedYet
        }
    }
    
}
