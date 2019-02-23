//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet var lineStatusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        let networkService = LineStatusFetcher()

        networkService.update(completion: { (status, updateTime) in

            guard let status = status, updateTime != nil else {
                completionHandler(.failed)
                return
            }

            let disruptedLines = self.getLinesWithBadStatus(status)

            DispatchQueue.main.async {
                self.setUpLabel(with: disruptedLines)
            }
            completionHandler(.newData)
        })

        completionHandler(.noData)

    }

    func getLinesWithBadStatus(_ lines: [Line]) -> [String] {
        var disruptedLineNames = [String]()
        for line in lines where line.lineStatuses.first?.reason != "Good Service" {
            disruptedLineNames.append(line.name)
        }
        return disruptedLineNames
    }

    func setUpLabel(with lines: [String]) {
        if lines.count == 0 {
            lineStatusLabel.text = NSLocalizedString("good.service", comment: "")
            return
        }

        if lines.count == 1, let lineName = lines.first {
            let disruptionString = NSLocalizedString("one.disruption", comment: "")
            lineStatusLabel.text = disruptionString.replacingOccurrences(of: "{line}", with: lineName)
            return
        }

        var lineList = ""
        for index in 0..<lines.count {
            lineList.append(lines[index])
            if index < (lines.count - 2) {
                lineList.append(", ")
            } else if index == (lines.count - 2) {
                lineList.append(", and ")
            }
        }

        let multipleDisruptionsString = NSLocalizedString("many.disruptions", comment: "")
        lineStatusLabel.text = multipleDisruptionsString.replacingOccurrences(of: "{lines}", with: lineList)
    }

}
