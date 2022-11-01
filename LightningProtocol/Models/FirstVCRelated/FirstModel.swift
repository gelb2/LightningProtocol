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
    
    @MainThreadActor var scrollSubject: ( (GenderType) -> () )?
    
    var selectionViewModel: PersonSelectionViewModel {
        return privateSelectionViewModel
    }
    
    var manViewModel: PersonListViewModel {
        return privateManViewModel
    }
    
    var womanViewModel: PersonListViewModel {
        return privateWomanViewModel
    }
    
    //properties
    private var repository: RepositoryProtocol
    
    private var privateSelectionViewModel: PersonSelectionViewModel = PersonSelectionViewModel()
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
        
        privateSelectionViewModel.propergateSelectedTypeToRelatedModel = { [weak self] genderType in
            guard let self = self else { return }
            self.scrollSubject?(genderType)
        }
        
        // TODO: viewmodel의 클로저가 호출되면 다시 viewModel의 didReceiveEntity를 또 부르는 구조...개선이 필요해 보인다...
        privateManViewModel.populatePageIndex = { [weak self] pageIndex in
            guard let self = self else { return }
            Task {
                print("firstModel Page index check : \(pageIndex)")
                await self.requestAPI_man_NextPage(pageIndex: pageIndex)
            }
        }
        
        privateWomanViewModel.populatePageIndex = { [weak self] pageIndex in
            guard let self = self else { return }
            Task {
                print("firstModel Page index check : \(pageIndex)")
                await self.requestAPI_woman_NextPage(pageIndex: pageIndex)
            }
        }
    }
    
    private func requestAPI_man_NextPage(pageIndex: Int) async {
        do {
            let manEntity: RandomPeopleEntity = try await repository.fetch(api: .randomUser(.man(resultCount: 10, pageIndex: pageIndex, gender: .male)))
            privateManViewModel.didReceiveEntity(manEntity)
        } catch let error {
            handleError(error: error)
        }
    }
    
    private func requestAPI_woman_NextPage(pageIndex: Int) async {
        do {
            let manEntity: RandomPeopleEntity = try await repository.fetch(api: .randomUser(.man(resultCount: 10, pageIndex: pageIndex, gender: .female)))
            privateWomanViewModel.didReceiveEntity(manEntity)
        } catch let error {
            handleError(error: error)
        }
    }
    
    private func requestAPI() async {
        
        // TODO: 엔티티를 이렇게 두 뷰모델에 그냥 넣어도 되나 좀 더 생각해보기...
        do {
            // TODO: add pageIndex, resultCount for man woman view
            // TODO: TaskGroup 이용한 동시성 처리 == 동시에 두 api 다 부르게 추가 수정
            let manEntity: RandomPeopleEntity = try await repository.fetch(api: .randomUser(.man(resultCount: 10, pageIndex: 1, gender: .male)))
            let womanEntity: RandomPeopleEntity = try await repository.fetch(api: .randomUser(.woman(resultCount: 10, pageIndex: 1, gender: .female)))
            
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
