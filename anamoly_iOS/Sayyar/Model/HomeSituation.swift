//
//  HomeSituation.swift
//  Sayyar
//
//  Created by Atri Patel on 05/02/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit

class HomeSituation: NSObject {
    
    var homeSituationTitle : String!    = ""
    var homeSituationImage : UIImage!   = UIImage()
    var homeSituationCount : Int!       = 0
    
    init(homeSituationTitle : String, homeSituationImage : UIImage, count : Int) {
        self.homeSituationTitle = homeSituationTitle
        self.homeSituationImage = homeSituationImage
        self.homeSituationCount = count
    }

}
