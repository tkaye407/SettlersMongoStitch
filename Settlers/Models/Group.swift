//
//  Group.swift
//  Settlers
//
//  Created by Tyler Kaye on 10/16/18.
//  Copyright © 2018 Tyler Kaye. All rights reserved.
//

import Foundation
import StitchCore

struct Group {
    
    struct Keys {
        static let idKey = "_id"
        static let titleKey = "title"
        static let membersKey = "members"
        static let descriptionKey = "description"
        static let transactionsKey = "transactions"
    }
    
    let objectID:  ObjectId
    let title: String
    var members: [Member]
    let description: String
    var transactions: [Transaction]
    
    //MARK: - Init
    init?(document: Document) {
        guard   let tObjectID = document[Keys.idKey] as? ObjectId,
            let tTitle = document[Keys.titleKey] as? String,
            let tDescription = document[Keys.descriptionKey] as? String else {
                return nil
        }
        self.objectID = tObjectID
        self.title = tTitle
        self.description = tDescription
        self.members = []
        for member in document[Keys.membersKey] as! [Document] {
            self.members.append(Member.init(document: member)!)
        }
        self.transactions = []
        for trans in document[Keys.transactionsKey] as! [Document] {
            self.transactions.append(Transaction.init(document: trans)!)
        }
    }
    
    public static func newGroup(title: String, description: String) -> Document {
        var doc = Document()
        doc[Keys.titleKey] = title
        doc[Keys.descriptionKey] = description
        doc[Keys.membersKey] = [Member.newMember(name: Stitch.defaultAppClient?.auth.currentUser?.profile.name ?? "", id: Stitch.defaultAppClient?.auth.currentUser?.id ?? "")]
        doc[Keys.idKey] = ObjectId()
        return doc
    }
}


extension Group: Comparable {
    public static func ==(lhs: Group, rhs: Group) -> Bool {
        return lhs.objectID.oid == rhs.objectID.oid
    }
    
    public static func < (lhs: Group, rhs: Group) -> Bool {
        return lhs.title < rhs.title
    }
}

