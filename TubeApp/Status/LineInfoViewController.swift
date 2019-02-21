//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import Foundation
import UIKit

public class LineInfoViewController: UIViewController {

    let line: Line

    @IBOutlet var lineInfoView: UIView! {
        didSet {
            lineInfoView.layer.cornerRadius = 11.0
        }
    }
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

        lineInfoView.backgroundColor = TubeLineColors(rawValue: line.name.lowercased())?.value
        lineTitleLabel?.text = line.name
        lineStatusIconImageView.image = line.status == "Good Service" ? UIImage(named: "GoodService") : UIImage(named: "Warning")
        lineStatusDescriptionLabel.text = line.status == "Good Service" ? line.status : line.disruptionDescription
        lineStatusDescriptionLabel.sizeToFit()
    }

    @IBAction func closeView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
