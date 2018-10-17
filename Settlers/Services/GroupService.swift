//
//  GroupService.swift
//  Settlers
//
//  Created by Tyler Kaye on 10/17/18.
//  Copyright © 2018 Tyler Kaye. All rights reserved.
//

import Foundation
import StitchCore
import StitchRemoteMongoDBService

class GroupService {
    static func get(doneHandler: @escaping ([Group]) -> Void) {
        let stitchClient = Stitch.defaultAppClient!
        let mongoClient = stitchClient.serviceClient(fromFactory: remoteMongoClientFactory, withName: "mongodb-atlas")
        let groupCollection = mongoClient.db("settlers").collection("groups")
        
        groupCollection.find().asArray({ result in
            var groups: [Group] = []
            switch result {
            case .success(let result):
                for res in result {
                    groups.append(Group(document: res)!)
                }
            case .failure(let error):
                print("Error in finding documents: \(error)")
            }
            doneHandler(groups)
        })
    }
    
    static func insert(group: Document, doneHandler: @escaping () -> Void) {
        let stitchClient = Stitch.defaultAppClient!
        let mongoClient = stitchClient.serviceClient(fromFactory: remoteMongoClientFactory, withName: "mongodb-atlas")
        let groupCollection = mongoClient.db("settlers").collection("groups")
        
        groupCollection.insertOne(group, {result in
            switch result {
            case .success( _):
                print("successfully added group")
            case .failure(let error):
                print("failed logging out: \(error)")
            }
            doneHandler()
        })
    }

}
