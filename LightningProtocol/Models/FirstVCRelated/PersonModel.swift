//
//  PersonModel.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/10/30.
//

import Foundation

class PersonModel: SceneActionReceiver {
    
    //input
    var didReceiveSceneAction: (SceneAction) -> () = { action in }
    
    var didTapTrashItemButton: () -> () = { }
    
    var scrollToGenderTapMonitor: (GenderType) -> () = { type in }
    
    //output
    @MainThreadActor var routeSubject: ( (SceneCategory) -> () )?
    
    @MainThreadActor var scrollSubject: ( (GenderType) -> () )?
    
    @MainThreadActor var propergateTrashItemButtonShow: ( (Bool) -> () )?
    
    var selectionViewModel: PersonSelectionViewModel {
        return privateSelectionViewModel
    }
    
    var manViewModel: PersonListViewModel {
        return privateManViewModel
    }
    
    var womanViewModel: PersonListViewModel {
        return privateWomanViewModel
    }
    
    var layoutSelectionViewModel: LayoutSelectionViewModel {
        return privateLayoutSelectionViewModel
    }
    
    //properties
    private var repository: RepositoryProtocol
    
    private var privateSelectionViewModel: PersonSelectionViewModel = PersonSelectionViewModel()
    private var privateManViewModel: PersonListViewModel = PersonListViewModel()
    private var privateWomanViewModel: PersonListViewModel = PersonListViewModel()
    
    private var privateLayoutSelectionViewModel: LayoutSelectionViewModel = LayoutSelectionViewModel()
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
        bind()
    }
    
    func populateData() {
        Task {
            await requestAPI_initial()
        }
    }
    
    private func requestAPI_initial() async {
        
        return await withTaskGroup(of: Void.self) { [weak self] group in
            guard let self = self else { return }
            
            group.addTask {
                await  self.requestAPI_woman()
            }
            
            group.addTask {
                await self.requestAPI_man()
            }
        }
    }

    private func bind() {
        
        scrollToGenderTapMonitor = { [weak self] type in
            guard let self = self else { return }
            self.privateSelectionViewModel.didSegmentChange(type)
        }
        
        privateSelectionViewModel.propergateSelectedTypeToRelatedModel = { [weak self] genderType in
            guard let self = self else { return }
            self.scrollSubject?(genderType)
        }
        
        privateManViewModel.populatePageIndex = { [weak self] pageIndex in
            guard let self = self else { return }
            Task {
                await self.requestAPI_man_NextPage(pageIndex: pageIndex)
            }
        }
        
        privateWomanViewModel.populatePageIndex = { [weak self] pageIndex in
            guard let self = self else { return }
            Task {
                await self.requestAPI_woman_NextPage(pageIndex: pageIndex)
            }
        }
        
        privateManViewModel.populateRefreshEvent = { [weak self] in
            guard let self = self else { return }
            Task {
                await self.requestAPI_man()
            }
        }
        
        privateWomanViewModel.populateRefreshEvent = { [weak self] in
            guard let self = self else { return }
            Task {
                await self.requestAPI_woman()
            }
        }
        
        privateManViewModel.propergateThereIsItemsToDelete = { [weak self] in
            guard let self = self else { return }
            self.validateTrashItemButtonShow()
        }
        
        privateWomanViewModel.propergateThereIsItemsToDelete = { [weak self] in
            guard let self = self else { return }
            self.validateTrashItemButtonShow()
        }
        
        privateManViewModel.propergateProfileTapEvent = { [weak self] urlString in
            guard let self = self else { return }
            let secondModel = ProfileZoomModel()
            secondModel.largeImageURLString = urlString
            let context = SceneContext(dependency: secondModel)
            self.routeSubject?(.detail(.profileZoomViewController(context: context)))
        }
        
        privateWomanViewModel.propergateProfileTapEvent = { [weak self] urlString in
            guard let self = self else { return }
            let secondModel = ProfileZoomModel()
            secondModel.largeImageURLString = urlString
            let context = SceneContext(dependency: secondModel)
            self.routeSubject?(.detail(.profileZoomViewController(context: context)))
        }
        
        privateLayoutSelectionViewModel.populateTapEvent = { [weak self] in
            guard let self = self else { return }
            let thirdModel = LayoutSelectionModel()
            let context = SceneContext(dependency: thirdModel)
            self.routeSubject?(.detail(.layoutSelectionViewController(context: context)))
        }
        
        didReceiveSceneAction = { [weak self] action in
            guard let self else { return }
            guard let action = action as? PersonSceneAction else { return }
            
            switch action {
            case .refresh:
                break
            case .refreshWithCollectionLayout(let layout):
                self.manViewModel.didReceiveRefreshCollectionLayoutEvent(layout)
                self.womanViewModel.didReceiveRefreshCollectionLayoutEvent(layout)
            }
        }
        
        didTapTrashItemButton = { [weak self] in
            guard let self = self else { return }
            self.showTrashItemConfirmAlert()
        }
    }
    
    private func requestAPI_man_NextPage(pageIndex: Int) async {
        do {
            let manEntity: RandomPeopleEntity = try await repository.fetch(api: .randomUser(.man(resultCount: 10, pageIndex: pageIndex, gender: .male)))
            privateManViewModel.didReceiveEntityToAppend(manEntity)
        } catch let error {
            handleError(error: error)
        }
    }
    
    private func requestAPI_woman_NextPage(pageIndex: Int) async {
        do {
            let manEntity: RandomPeopleEntity = try await repository.fetch(api: .randomUser(.man(resultCount: 10, pageIndex: pageIndex, gender: .female)))
            privateWomanViewModel.didReceiveEntityToAppend(manEntity)
        } catch let error {
            handleError(error: error)
        }
    }
    
    private func requestAPI_man() async {
        do {
            let manEntity: RandomPeopleEntity = try await repository.fetch(api: .randomUser(.man(resultCount: 10, pageIndex: 1, gender: .male)))
            privateManViewModel.didReceiveEntityToRefreshAll(manEntity)
        } catch let error {
            handleError(error: error)
        }
    }
    
    private func requestAPI_woman() async {
        do {
            let womanEntity: RandomPeopleEntity = try await repository.fetch(api: .randomUser(.woman(resultCount: 10, pageIndex: 1, gender: .female)))
            privateWomanViewModel.didReceiveEntityToRefreshAll(womanEntity)
        } catch let error {
            handleError(error: error)
        }
    }
    
    private func validateTrashItemButtonShow() {
        let markedMan = privateManViewModel.dataSource.filter { $0.isSelected == true }
        let markedWoman = privateWomanViewModel.dataSource.filter { $0.isSelected == true }
        if markedMan.count > 0 || markedWoman.count > 0 {
            propergateTrashItemButtonShow?(true)
        } else {
            propergateTrashItemButtonShow?(false)
        }
        
    }
    
    private func showTrashItemConfirmAlert() {
        let okAction = AlertActionDependency(title: "ok", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.privateManViewModel.didReceiveTrashItemEvent()
            self.privateWomanViewModel.didReceiveTrashItemEvent()
            self.validateTrashItemButtonShow()
        }
        
        let cancelAction = AlertActionDependency(title: "cancel", style: .cancel, action: nil)
        
        let alertDependency = AlertDependency(title: "??????", message: "????????? ??????????????????????", preferredStyle: .alert, actionSet: [okAction, cancelAction])
        
        routeSubject?(.alert(.itemAlert(.deleteSelectedItem(alertDependency))))
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
