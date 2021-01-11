//
//  GridView.swift
//  Instagrid
//
//  Created by vincent santos on 10/12/2020.
//

import UIKit


class GridView: UIView {
    
    @IBOutlet var viewTopLeft :UIView!
    @IBOutlet var viewTopRight :UIView!
    @IBOutlet var viewBottomLeft :UIView!
    @IBOutlet var viewBottomRight :UIView!
    
    @IBOutlet var photos : [UIImageView]!
 
    @IBOutlet var selectedRight :UIView!
    @IBOutlet var selectedMidle :UIView!
    @IBOutlet var selectedLeft :UIView!
    
    enum Style {
        case Leftmodel, Midlemodel, Rightmodel
    }
    
    var style :Style = .Leftmodel {
        didSet {
            setStyle(style)
        }
    }
    
    // fonction déclaration vrai is hidden
    func model(topLeft: Bool, topRight: Bool, bottomLeft: Bool, bottomRight: Bool) {
        viewTopLeft.isHidden = topLeft
        viewTopRight.isHidden = topRight
        viewBottomLeft.isHidden = bottomLeft
        viewBottomRight?.isHidden = bottomRight
    }
    
    // fonction qui change la disposition
    func setStyle(_ style: Style) {
        switch style {
        case .Leftmodel:
            model(topLeft: true, topRight: false, bottomLeft: false, bottomRight: false)
        case .Midlemodel:
            model(topLeft: false, topRight: false, bottomLeft: true, bottomRight: false)
        case .Rightmodel:
            model(topLeft: false, topRight: false, bottomLeft: false, bottomRight: false)
        }
    }

    // fonction determine quel model selon le hidden
    func selected(style: Style) {
        self.style = style
        selectedLeft.isHidden = style != .Leftmodel
        selectedMidle.isHidden = style != .Midlemodel
        selectedRight.isHidden = style != .Rightmodel
    }

    func checkCompleteGrid() -> Bool {
        switch style {
        case .Leftmodel:
            if photos[1].image == nil || photos[2].image == nil || photos[3].image == nil {
                return false
            }
        case .Midlemodel:
            if photos[0].image == nil || photos[1].image == nil || photos[3].image == nil {
                return false
            }
        case .Rightmodel:
            if photos[0].image == nil || photos[1].image == nil || photos[2].image == nil || photos[3].image == nil {
                return false
            }
        }
        return true 
    }
    
    
}
