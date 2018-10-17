//
//  Transaction.swift
//  Settlers
//
//  Created by Tyler Kaye on 10/16/18.
//  Copyright © 2018 Tyler Kaye. All rights reserved.
//

import Foundation
import StitchCore

struct Transaction {
    
    struct Keys {
        static let descriptionKey = "description"
        static let amountKey = "amount"
        static let payerKey = "payer_id"
        static let payeeKey = "payee_id"
        static let titleKey = "title"
        static let idKey = "t_oid"
    }
    
    let objectID:  ObjectId
    let amount: Float
    let payer: String
    let payee: [String]
    let title: String
    let description: String
    
    //MARK: - Init
    init?(document: Document) {
        guard   let tObjectID = document[Keys.idKey] as? ObjectId,
            let tAmount = document[Keys.amountKey] as? Double,
            let tPayer = document[Keys.payerKey] as? String,
            let tPayee = document[Keys.payeeKey] as? [String],
            let tDescription = document[Keys.descriptionKey] as? String,
            let tTitle = document[Keys.titleKey] as? String else {
                return nil
        }
        self.objectID = tObjectID
        self.amount = Float(tAmount)
        self.payer = tPayer
        self.payee = tPayee
        self.title = tTitle
        self.description = tDescription

    }
    
    public static func newTransaction(title: String, description: String, amount: Double, payee: [String]) -> Document {
        var doc = Document()
        doc[Keys.titleKey] = title
        doc[Keys.descriptionKey] = description
        doc[Keys.amountKey] = amount
        doc[Keys.payeeKey] = payee
        doc[Keys.payerKey] = Stitch.defaultAppClient?.auth.currentUser?.id ?? ""
        doc[Keys.idKey] = ObjectId()
        return doc
    }
}


extension Transaction: Comparable {
    public static func ==(lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.objectID.oid == rhs.objectID.oid
    }
    
    public static func < (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.title < rhs.title
    }
}

