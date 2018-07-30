//
//  SvgModelView.swift
//  MHWDB
//
//  Created by Joe on 7/28/18.
//  Copyright © 2018 Gathering Hall Studios. All rights reserved.
//

import SVGKit

struct SVGImageModel {
    let name: String
    let color: UIColor?

    init(name: String, color: UIColor? = nil) {
        self.name = name
        self.color = color
    }
}

class SvgModelView: SVGKFastImageView {
    var imageName: String? // cache name so we don't reload same image

    init?(model: SVGImageModel) {
        imageName = model.name
        guard let image = SVGKImage(named: model.name) else { return nil }
        if let color = model.color?.cgColor {
            let layer = image.layer(withIdentifier: "base") as? CAShapeLayer
            layer?.fillColor = color
        }
        super.init(svgkImage: image)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(model: SVGImageModel) {
        guard let image = (imageName == model.name ? image : SVGKImage(named: model.name)) else { return }
        imageName = model.name
        if let color = model.color?.cgColor {
            let layer = image.layer(withIdentifier: "base") as? CAShapeLayer
            layer?.fillColor = color
        }
        self.image = image
    }
}
