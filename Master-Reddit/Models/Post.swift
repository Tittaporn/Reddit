//
//  Post.swift
//  Master-Reddit
//
//  Created by Lee McCormick on 1/27/21.
//  Copyright © 2021 Cameron Stuart. All rights reserved.
//

import Foundation

struct TopLevelObject: Decodable {
    let data: SecondLevelObject
}

struct SecondLevelObject: Decodable {
    let children: [ThiredLevelObject]
}

struct ThiredLevelObject: Decodable {
    let data: Post
}

struct Post: Decodable {
    let title: String
    let ups: Int
    let thumbnail: String
}
