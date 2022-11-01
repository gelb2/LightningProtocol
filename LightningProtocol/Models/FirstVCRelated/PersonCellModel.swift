//
//  PersonCellModel.swift
//  LightningProtocol
//
//  Created by pablo.jee on 2022/11/01.
//

import Foundation

class PersonCellModel {
    var name: String
    var location: String
    var email: String
    var uuid: String
    var thumbImageURLString: String
    var mediumImageURLString: String
    var largeImageURLString: String
    
    init() {
        self.name = ""
        self.location = ""
        self.email = ""
        self.uuid = ""
        self.thumbImageURLString = ""
        self.mediumImageURLString = ""
        self.largeImageURLString = ""
    }
}

extension PersonCellModel: Equatable {
    
    static func == (lhs: PersonCellModel, rhs: PersonCellModel) -> Bool {
        print("cellModel equatable check \(lhs.uuid == rhs.uuid)")
        return lhs.uuid == rhs.uuid
    }
    
}
