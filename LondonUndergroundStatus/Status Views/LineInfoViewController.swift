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

        lineInfoView.backgroundColor = TubeLineColors(rawValue: line.identifier)?.value
        lineTitleLabel?.text = line.name
        let status = line.lineStatuses.first?.statusSeverityDescription
        let goodService = status == "Good Service"

        lineStatusIconImageView.image = goodService ? UIImage(named: "GoodService") : UIImage(named: "Warning")

        lineStatusDescriptionLabel.text = goodService ? String(.goodService) : line.lineStatuses.first?.reason

        lineStatusDescriptionLabel.sizeToFit()
    }

    @IBAction func closeView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
