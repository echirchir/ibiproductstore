//
//  ViewController.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import UIKit
import LocalAuthentication
import Lottie

final class LoginViewController: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    @IBOutlet weak var biometricIcon: UIImageView!
    
    @IBOutlet weak var lottieAnimation: UIView!
    
    private let viewModel = LoginViewModel()
    private var lottieAnimationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        biometricIcon.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBiometricAuthentication))
        biometricIcon.addGestureRecognizer(tapGesture)
        
        loadLottieAnimation()
    }
    
    @objc func loadLottieAnimation() {
        lottieAnimationView = LottieAnimationView(name: "login_animation")
        lottieAnimationView?.frame = lottieAnimation.bounds
        lottieAnimationView?.contentMode = .scaleAspectFit
        lottieAnimationView?.loopMode = .loop
        lottieAnimationView?.play()

        lottieAnimation.addSubview(lottieAnimationView!)
    }
    
    @IBAction func onLoginAction(_ sender: Any) {
        if viewModel.validateCredentials(username: userNameField.text ?? "", password: userPasswordField.text ?? "") {
            onSuccessfulAuthentication()
        } else {
            showAlert(title: "Invalid Credentials", message: "Please enter the correct credentials to proceed!")
        }
    }
    
    @objc func onSuccessfulAuthentication() {
        UserDefaultsManager.shared.isUserLoggedIn = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
            navigateToNextScreen(from: self, destination: tabBarVC)
        }
    }
    
    @objc
    func handleBiometricAuthentication() {
        let context = LAContext()
        var error: NSError?
        
        // Check if biometric authentication is available for device
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to log in"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Authentication successful
                        self.onSuccessfulAuthentication()
                    } else {
                        // Authentication failed
                        self.showAlert(title: "Error", message: authenticationError?.localizedDescription ?? "Failed to authenticate")
                    }
                }
            }
        } else {
            // Biometrics not available
            showAlert(title: "Unavailable", message: "Biometric authentication is not available on this device.")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

