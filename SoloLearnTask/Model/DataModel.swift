//
//  DataModel.swift
//  SoloLearnTask
//
//  Created by Tigran  Simonyan on 4/23/19.
//  Copyright © 2019 Tigran  Simonyan. All rights reserved.
//

import Foundation

struct DataModel : Codable {
    var status: String
    var userTier: String
    var total: Int
    var startIndex: Int
    var pageSize: Int
    var currentPage: Int
    var pages: Int
    var orderBy: String!
    var results: [ArticleModel]
}
