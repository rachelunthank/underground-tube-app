//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet var LineStatusLabel: UILabel!
        
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

        LineStatusFetcher.update(completion: { (status, updateTime) in

            guard let status = status, let _ = updateTime else {
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
        for line in lines {
            if line.status != "Good Service" {
                disruptedLineNames.append(line.name)
            }
        }
        return disruptedLineNames
    }

    func setUpLabel(with lines: [String]) {
        if lines.count == 0 {
            LineStatusLabel.text = "There is a good service on all lines"
            return
        }

        if lines.count == 1, let lineName = lines.first {
            LineStatusLabel.text = "There is a disruption on the \(lineName) line, but a good service is running on all other lines"
            return
        }

        var lineList = ""
        for i in 0..<lines.count {
            lineList.append(lines[i])
            if i < (lines.count - 2) {
                lineList.append(", ")
            } else if i == (lines.count - 2) {
                lineList.append(", and ")
            }
        }

        LineStatusLabel.text = "The \(lineList) lines are disrupted, but a good service is running on all other lines"
    }
    
}
