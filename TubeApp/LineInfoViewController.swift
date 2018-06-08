//
//  File.swift
//  TubeApp
//
//  Created by Rachel McGreevy on 02/06/2018.
//  Copyright © 2018 knoxx. All rights reserved.
//

import Foundation
import UIKit

public class LineInfoViewController: UIViewController {

    let line: Line

    @IBOutlet var lineInfoView: UIView!
    @IBOutlet var lineTitleLabel: UILabel!
    @IBOutlet var lineStatusIconImageView: UIImageView!
    @IBOutlet var lineStatusDescriptionLabel: UILabel!

    init(line: Line) {
        self.line = line
        super.init(nibName: "LineInfoView", bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        view.backgroundColor = UIColor.white.withAlphaComponent(0.7)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tapGesture)

        lineInfoView.layer.cornerRadius = 11.0
        lineInfoView.backgroundColor = TubeLineColors(rawValue: line.name.lowercased())?.value
        lineTitleLabel?.text = line.name
        lineStatusIconImageView.image = line.status == "Good Service" ? UIImage(named: "GoodService") : UIImage(named: "Warning")
        lineStatusDescriptionLabel.text = line.status == "Good Service" ? line.status : line.disruptionDescription
        lineStatusDescriptionLabel.sizeToFit()
    }

    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
