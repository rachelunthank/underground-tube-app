//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"

        let lineModesNib = UINib(nibName: "SettingsLineModeTableViewCell", bundle: nil)

        tableView.register(lineModesNib, forCellReuseIdentifier: "settingsLineModeCell")

        let closeButton = UIBarButtonItem(barButtonSystemItem: .done,
                                          target: self,
                                          action: #selector(closeSettings))
        navigationItem.rightBarButtonItem = closeButton
    }

    @objc func closeSettings() {
        dismiss(animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LineModes.allCases.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Line Modes"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsLineModeCell",
                                                 for: indexPath) as? SettingsLineModeTableViewCell

        let modeType = LineModes.allCases[indexPath.row]
        let modeName = LineModeNames.allCases[indexPath.row].rawValue
        let lineModes = UserDefaults.standard.object(forKey: "lineModes") as? [String]
        cell?.configure(modeName: modeName,
                        modeType: modeType,
                        lineModes: lineModes)

        return cell ?? UITableViewCell()
    }
}
