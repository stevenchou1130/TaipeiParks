//
//  ParkModel.swift
//  TaipeiParks
//
//  Created by steven.chou on 2017/5/29.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

import Foundation

struct ParkModel {

    var parkName: String
    var name: String
    var image: String
    var introduction: String

    init(parkName: String, name: String,
         image: String, introduction: String) {

        self.parkName = parkName
        self.name = name
        self.image = image
        self.introduction = introduction
    }
}
