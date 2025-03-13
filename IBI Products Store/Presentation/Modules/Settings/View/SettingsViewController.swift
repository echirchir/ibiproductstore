//
//  SettingsViewController.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var languageSegment: UISegmentedControl!
    @IBOutlet weak var appThemeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let selectedLanguage = UserDefaultsManager.shared.languageCode
        languageSegment.selectedSegmentIndex = (selectedLanguage == LanguageCode.english.rawValue) ? 0 : 1
        setAppTheme()
        
        updateUI()
        
        // Observe language change notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLanguageChange),
            name: Notification.Name("LanguageChanged"),
            object: nil
        )
    }
    
    @objc private func handleLanguageChange() {
        updateUI()
    }
    
    @IBAction func onLogoutUser(_ sender: Any) {
        logout(from: self)
    }
    
    @IBAction func onLanguageChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UserDefaultsManager.shared.languageCode = LanguageCode.english.rawValue
        } else {
            UserDefaultsManager.shared.languageCode = LanguageCode.hebrew.rawValue
        }
    }
    
    private func updateUI() {
        darkModeLabel.text = "dark_mode".localized
        languageLabel.text = "language".localized
        logoutButton.titleLabel?.text = "logout".localized
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
