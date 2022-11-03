//
//  PersonCellModel.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/01.
//

import Foundation

class PersonCellModel {
    //input
    var didReceiveSelectedEvent: (Bool) -> () = { isSelected in }
    var didReceiveProfileTapEvent: () -> () = { }
    var propergateProfileTapEvent: (String) -> () = { largeImageURL in }
    
    //output
    
    
    //properties
    var toggleUIAsSelectedEvent: (Bool) -> () = { isSelected in }
    
    var name: String
    var location: String
    var email: String
    var uuid: String
    var thumbImageURLString: String
    var mediumImageURLString: String
    var largeImageURLString: String
    var mobilePhone: String
    var isSelected: Bool
    
    init() {
        self.name = ""
        self.location = ""
        self.email = ""
        self.uuid = ""
        self.thumbImageURLString = ""
        self.mediumImageURLString = ""
        self.largeImageURLString = ""
        self.mobilePhone = ""
        self.isSelected = false
        
        bind()
    }
    
    func bind() {
        didReceiveSelectedEvent = { [weak self] value in
            guard let self = self else { return }
            print("cellModel isSelected : \(value)")
            self.isSelected = value
            print("cellModel isSelected : -> \(self.isSelected)")
            self.toggleUIAsSelectedEvent(self.isSelected)
        }
        
        didReceiveProfileTapEvent = { [weak self] in
            guard let self = self else { return }
            print("cellModel tapEvent")
            self.propergateProfileTapEvent(self.largeImageURLString)
        }
    }
}

extension PersonCellModel: Equatable {
    
    static func == (lhs: PersonCellModel, rhs: PersonCellModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
}
