//
//  DataManager.swift
//  CustomTransitionDemo
//
//  Created by Tung on 10.11.19.
//  Copyright © 2019 Tung. All rights reserved.
//

import Foundation

// Yes, it's a singleton.
// But it doesn't matter since this tutorial is about the Animation transition :)

class DataManager {

    private init() {}

    static let data: [CellData] = [
        .init(image: #imageLiteral(resourceName: "images/1"), title: "Seychelles"),
        .init(image: #imageLiteral(resourceName: "images/2"), title: "Königssee"),
        .init(image: #imageLiteral(resourceName: "images/5"), title: "Zanzibar"),
        .init(image: #imageLiteral(resourceName: "images/6"), title: "Serengeti"),
        .init(image: #imageLiteral(resourceName: "images/3"), title: "Castle"),
        .init(image: #imageLiteral(resourceName: "images/4"), title: "Kyiv"),
        .init(image: #imageLiteral(resourceName: "images/7"), title: "Munich"),
        .init(image: #imageLiteral(resourceName: "images/8"), title: "Lake")
    ]

}
