//
//  FirstModel.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/30.
//

import Foundation

class FirstModel: SceneActionReceiver {
    
    //input
    var didReceiveSceneAction: (SceneAction) -> () = { action in }
    
    //output
    @MainThreadActor var routeSubject: ( (SceneCategory) -> () )?
    
    var manViewModel: PersonListViewModel {
        return privateManViewModel
    }
    
    var womanViewModel: PersonListViewModel {
        return privateWomanViewModel
    }
    
    //properties
    private var repository: RepositoryProtocol
    
    private var privateManViewModel: PersonListViewModel = PersonListViewModel()
    private var privateWomanViewModel: PersonListViewModel = PersonListViewModel()
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
        bind()
    }
    
    func populateData() {
        Task {
            await requestAPI()
        }
    }
    
    private func bind() {

    }
    
    private func requestAPI() async {
        
        // TODO: 엔티티를 이렇게 두 뷰모델에 그냥 넣어도 되나 좀 더 생각해보기...
        do {
            // TODO: add pageIndex, resultCount for man woman view
            // TODO: TaskGroup 이용한 동시성 처리 == 동시에 두 api 다 부르게 추가 수정
            let manEntity: RandomPeopleEntity = try await repository.fetch(api: .randomUser(.man(resultCount: 10, pageIndex: 1, gender: "male")))
            let womanEntity: RandomPeopleEntity = try await repository.fetch(api: .randomUser(.woman(resultCount: 10, pageIndex: 1, gender: "female")))
            
            privateManViewModel.didReceiveEntity(manEntity)
            privateWomanViewModel.didReceiveEntity(womanEntity)
            
        } catch let error {
            handleError(error: error)
        }
    }
    
    private func handleError(error: Error) {
        
        let error = error as? HTTPError
        
        switch error {
        case .invalidURL, .errorDecodingData, .badResponse, .badURL, .iosDevloperIsStupid:
            let okAction = AlertActionDependency(title: "ok", style: .default, action: nil)
            let cancelAction = AlertActionDependency(title: "cancel", style: .cancel, action: nil)
            let alertDependency = AlertDependency(title: String(describing: error), message: "check error wisely", preferredStyle: .alert, actionSet: [okAction, cancelAction])
            routeSubject?(.alert(.networkAlert(.normalErrorAlert(alertDependency))))
        case .none:
            break
        }
    }
}
