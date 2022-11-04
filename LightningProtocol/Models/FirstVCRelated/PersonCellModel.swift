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
    var name: String {
        return "[\(title)]" + " " + firstName + " " + lastName
    }
    
    var location: String {
        return country + " / " + state + " / " + city
    }
    
    var mail: String {
        return email
    }
    
    var mobilePhone: String {
        return phone
    }
    
    var thumbImageURLString: String {
        return thumbURL
    }
    
    var largeImageURLString: String {
        return largeURL
    }
    
    
    //properties
    var toggleUIAsSelectedEvent: (Bool) -> () = { isSelected in }
    
    var title: String
    var firstName: String
    var lastName: String
    
    var country: String
    var state: String
    var city: String

    var email: String
    var uuid: String
    
    var thumbURL: String
    var mediumURL: String
    var largeURL: String
    
    var phone: String
    var isSelected: Bool
    
    init() {
        self.title = ""
        self.firstName = ""
        self.lastName = ""
        
        self.country = ""
        self.state = ""
        self.city = ""

        self.email = ""
        self.uuid = ""
        
        self.thumbURL = ""
        
        self.mediumURL = ""
        self.largeURL = ""
        
        self.phone = ""
        self.isSelected = false
        
        bind()
    }
    
    func bind() {
        didReceiveSelectedEvent = { [weak self] value in
            guard let self = self else { return }
            self.isSelected = value
            self.toggleUIAsSelectedEvent(self.isSelected)
        }
        
        didReceiveProfileTapEvent = { [weak self] in
            guard let self = self else { return }
            self.propergateProfileTapEvent(self.largeImageURLString)
        }
    }
}

extension PersonCellModel: Equatable {
    
    static func == (lhs: PersonCellModel, rhs: PersonCellModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
}
