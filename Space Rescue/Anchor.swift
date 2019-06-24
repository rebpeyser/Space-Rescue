//
//  Anchor.swift
//  Space Rescue
//
//  Created by Rebecca Peyser on 6/24/19.
//  Copyright © 2019 Rebecca Peyser. All rights reserved.
//

import ARKit

enum NodeType: String {
   case fuel = "fuel"
   case trappedDog = "trappedDog"
}

class Anchor: ARAnchor {
    var type: NodeType?
}
