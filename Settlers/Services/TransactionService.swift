//
//  TransactionService.swift
//  Settlers
//
//  Created by Tyler Kaye on 10/17/18.
//  Copyright © 2018 Tyler Kaye. All rights reserved.
//

import Foundation
import StitchCore
import StitchRemoteMongoDBService

class TransactionService {
    static func insert(groupID: ObjectId, transaction: Document, successHandler: @escaping () -> Void, failureHandler: @escaping (StitchError) -> Void) {
        let stitchClient = Stitch.defaultAppClient!
        let mongoClient = stitchClient.serviceClient(fromFactory: remoteMongoClientFactory, withName: "mongodb-atlas")
        let groupCollection = mongoClient.db("settlers").collection("groups")
        
        let update = Document(["$push": Document(["transactions": transaction])])
        groupCollection.updateOne(
            filter: ["_id": groupID],
            update: update,
            options: nil,
            {result in
                switch result {
                case .success(_):
                    successHandler()
                case .failure(let error):
                    failureHandler(error)
                }
        })
    }
    
    static func delete(groupID: ObjectId, transactionID: ObjectId, handler: @escaping () -> Void) {
        let stitchClient = Stitch.defaultAppClient!
        let mongoClient = stitchClient.serviceClient(fromFactory: remoteMongoClientFactory, withName: "mongodb-atlas")
        let groupCollection = mongoClient.db("settlers").collection("groups")
        
        let matchDoc = Document([Group.Keys.idKey: groupID])
        let matchDoc2 = Document([Transaction.Keys.idKey: transactionID])
        let updateDoc = Document(["$pull": Document(["transactions": matchDoc2])])
        groupCollection.updateOne(filter: matchDoc, update: updateDoc, {result in
            switch result {
            case .success(_):
                handler()
            case .failure(let error):
                print("failed to delete item with error: \(error)")
            }
        })
    }
}
