//
//  SettingsLineModeTableViewCell.swift
//  LondonUndergroundStatus
//
//  Created by Rachel McGreevy on 25/02/2019.
//

import UIKit

class SettingsLineModeTableViewCell: UITableViewCell {

    @IBOutlet var lineModeLabel: UILabel!
    @IBOutlet var lineModeEnabledSwitch: UISwitch!

    public var modeType: LineModes?

    public func configure(modeName: String, modeType: LineModes, lineModes: [String]?) {
        self.modeType = modeType

        configureSwitch(with: lineModes)
        lineModeLabel.text = modeName
    }

    func configureSwitch(with lineModes: [String]?) {
        guard let mode = modeType?.rawValue else { return }
        let modeIsInUserDefaults = lineModes?.contains(mode) == true

        if modeType == .tube {
            lineModeEnabledSwitch.isOn = true
            lineModeEnabledSwitch.isEnabled = false
        } else {
            lineModeEnabledSwitch.isOn = modeIsInUserDefaults
        }
    }

    @IBAction func updateLineModeState(_ sender: UISwitch) {

        guard let mode = modeType?.rawValue else { return }

        let modeIsEnabled = sender.isOn

        let lineModes = UserDefaults.standard.object(forKey: "lineModes") as? [String]
        let modeIsInUserDefaults = lineModes?.contains(mode)

        if modeIsEnabled == false && modeIsInUserDefaults == true {
            removeModeFromUserDefaults(modeType)
        } else if modeIsEnabled == true && modeIsInUserDefaults == false {
            addModeToUserDefaults(modeType)
        }
    }

    func removeModeFromUserDefaults(_ mode: LineModes?) {

        guard let lineMode = mode else { return }

        var lineModes = UserDefaults.standard.object(forKey: "lineModes") as? [String]
        guard let index = lineModes?.firstIndex(of: lineMode.rawValue) else { return }
        lineModes?.remove(at: index)
        UserDefaults.standard.set(lineModes, forKey: "lineModes")

        var lineOrder = UserDefaults.standard.object(forKey: "lineOrder") as? [String]
        guard let line = lineModeAsLine(lineMode), let orderIndex = lineOrder?.firstIndex(of: line.rawValue) else { return }
        lineOrder?.remove(at: orderIndex)
        UserDefaults.standard.set(lineOrder, forKey: "lineOrder")
    }

    func addModeToUserDefaults(_ mode: LineModes?) {

        guard let lineMode = mode else { return }
        var lineModes = UserDefaults.standard.object(forKey: "lineModes") as? [String]
        lineModes?.append(lineMode.rawValue)
        UserDefaults.standard.set(lineModes, forKey: "lineModes")

        var lineOrder = UserDefaults.standard.object(forKey: "lineOrder") as? [String]
        guard let line = lineModeAsLine(lineMode) else { return }
        lineOrder?.append(line.rawValue)
        UserDefaults.standard.set(lineOrder, forKey: "lineOrder")
    }

    func lineModeAsLine(_ mode: LineModes) -> TubeLines? {
        switch mode {
        case .dlr: return .dlr
        case .cableCar: return .emirates
        case .overground: return .overground
        case .tram: return .tram
        case .tflrail: return .tfl
        case .tube: return nil
        }
    }
}
