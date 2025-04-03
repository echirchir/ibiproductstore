//
//  SettingsViewController.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import UIKit


enum AppLanguage: String, CaseIterable {
    case english = "en"
    case hebrew = "he"
    static let hebrewAlternateCode = "iw"
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .hebrew: return "Hebrew"
        }
    }
    
    init?(languageCode: String) {
        switch languageCode {
        case "en": self = .english
        case "he", "iw": self = .hebrew
        default: return nil
        }
    }
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var appThemeSwitch: UISwitch!
    @IBOutlet weak var selectedLanguageLabel: UILabel!
    @IBOutlet weak var changeLanguageButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppTheme()
        
        updateLanguageLabel()
        darkModeLabel.text = "dark_mode".localized
        languageLabel.text = "language".localized
        logoutButton.titleLabel?.text = "logout".localized
        
        changeLanguageButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeLanguageTapped))
            changeLanguageButton.addGestureRecognizer(tapGesture)
        
    }
    
    @IBAction func onLogoutUser(_ sender: Any) {
        logout(from: self)
    }
    
    @objc func changeLanguageTapped(_ sender: UISegmentedControl) {
        guard URL(string: UIApplication.openSettingsURLString) != nil else { return }
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    @IBAction func onToggleDarkMode(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaultsManager.shared.appTheme = AppTheme.dark.rawValue
        } else {
            UserDefaultsManager.shared.appTheme = AppTheme.light.rawValue
        }
        setAppTheme()
    }
    
    private func setAppTheme() {
        let theme = UserDefaultsManager.shared.appTheme
        appThemeSwitch.isOn = (theme == AppTheme.dark.rawValue)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.overrideUserInterfaceStyle = (theme == AppTheme.light.rawValue) ? .light : .dark
        }
    }
}

extension SettingsViewController {
    private func getDeviceLocale() -> AppLanguage {
        guard let deviceLanguageCode = Locale.preferredLanguages.first?.components(separatedBy: "-").first else {
            return .english
        }
        debugPrint("The device language code is: \(deviceLanguageCode)")
        return AppLanguage(rawValue: deviceLanguageCode) ?? .english
    }
    
    private func updateLanguageLabel() {
        let currentLanguage = getDeviceLocale()
        selectedLanguageLabel.text = currentLanguage.displayName.uppercased()
    }
}
