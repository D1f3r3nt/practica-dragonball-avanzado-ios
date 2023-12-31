//
//  LoginViewController.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 10/10/23.
//

import UIKit

// MARK: - Delegate -
protocol LoginViewControllerProtocol {
    var viewState: ((LoginViewState) -> Void)? {get set}
    var heroesViewModel: HeroesViewControllerDelegate { get }
    
    func handleLoginPressed(email: String?, password: String?)
}

// MARK: - States -
enum LoginViewState {
    case loading(_ isLoading: Bool)
    case showErrorEmail(_ error: String?)
    case showErrorPassword(_ error: String?)
    case invalidLogin
    case navigateToNext
}

// MARK: - View -
class LoginViewController: UIViewController {

    // MARK: - Outlets -
    @IBOutlet weak var emailRequired: UILabel!
    @IBOutlet weak var wrongPassword: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var viewLoding: UIView!
    
    var viewModel: LoginViewControllerProtocol?
    
    // MARK: - Overrides -
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObservers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "LOGIN_TO_HOME",
              let heroesViewController = segue.destination as? HeroesViewController else {
            return
        }
        
        heroesViewController.viewModel = viewModel?.heroesViewModel
        
    }

    // MARK: - Actions -
    @IBAction func didTapLogin(_ sender: Any) {
        viewModel?.handleLoginPressed(
            email: emailField.text,
            password: passwordField.text
        )
    }
    
    // MARK: - Privates -
    private func initViews() {
        // Para escuchar sus eventos
        emailField.delegate = self
        emailField.tag = FieldType.email.rawValue
        passwordField.delegate = self
        passwordField.tag = FieldType.password.rawValue
        
        // Para reconocer gestos
        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        )
    }
    
    // Para recibir los estados de ViewModel
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        self?.viewLoding.isHidden = !isLoading
                    
                    case .showErrorEmail(let error):
                        self?.emailRequired.text = error
                        self?.emailRequired.isHidden = error == nil || error?.isEmpty == true
                        
                    case .showErrorPassword(let error):
                        self?.wrongPassword.text = error
                        self?.wrongPassword.isHidden = error == nil || error?.isEmpty == true
                    
                    case .invalidLogin:
                        self?.showInvalidLogin()
                        
                    case .navigateToNext:
                        self?.performSegue(withIdentifier: "LOGIN_TO_HOME", sender: nil)
                        
                }
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        // Si se muestra el teclado que se oculte
        view.endEditing(true)
    }
    
    private func showInvalidLogin() {
        let alert = UIAlertController(
            title: "Not authorized",
            message: "Your username or passowrd is not valid",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Got it!", style: .cancel))
        self.present(alert, animated: true)
    }
}

// MARK: - Extensions -
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch FieldType(rawValue: textField.tag) {
            case .email:
                emailRequired.isHidden = true
            case .password:
                wrongPassword.isHidden = true
            default: break
        }
    }
}

private enum FieldType: Int {
    case email = 0
    case password = 1
}
