//
//  Member.swift
//  Settlers
//
//  Created by Tyler Kaye on 10/16/18.
//  Copyright © 2018 Tyler Kaye. All rights reserved.
//

import Foundation
import StitchCore

struct Member {
    
    struct Keys {
        static let idKey = "user_id"
        static let nameKey = "name"
    }
    
    let id:  String
    let name: String
    
    //MARK: - Init
    init?(document: Document) {
        guard   let tObjectID = document[Keys.idKey] as? String,
            let tName = document[Keys.nameKey] as? String else {
                return nil
        }
        self.id = tObjectID
        self.name = tName
    }
    
    public static func newMember(name: String, id: String) -> Document {
        var doc = Document()
        doc[Keys.nameKey] = name
        doc[Keys.idKey] = id
        return doc
    }
}


extension Member: Comparable {
    public static func ==(lhs: Member, rhs: Member) -> Bool {
        return lhs.id == rhs.id
    }
    
    public static func < (lhs: Member, rhs: Member) -> Bool {
        return lhs.name < rhs.name
    }
}

