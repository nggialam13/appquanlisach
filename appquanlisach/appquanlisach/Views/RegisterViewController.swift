import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!

    @IBOutlet weak var PasswordTextField: UITextField!

    @IBOutlet weak var ConfirmPasswordTextField: UITextField!

    @IBOutlet weak var RegisterButton: UIButton!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    let registerController = RegisterController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func RegisterButton(_ sender: UIButton) {

        guard let email = EmailTextField.text,
              let password = PasswordTextField.text,
              let confirmPassword = ConfirmPasswordTextField.text
        else {
            return
        }

        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {

            showAlert(
                title: "Lỗi",
                message: "Vui lòng nhập đầy đủ thông tin"
            )
            return
        }

        if password != confirmPassword {

            showAlert(
                title: "Lỗi",
                message: "Mật khẩu xác nhận không khớp"
            )
            return
        }

        registerController.register(
            email: email,
            password: password
        ) { [weak self] result in

            DispatchQueue.main.async {

                switch result {

                case .success(let user):

                    self?.showAlert(
                        title: "Thành công",
                        message: "Đăng ký thành công\n\(user.email)"
                    )

                case .failure(let error):

                    self?.showAlert(
                        title: "Lỗi",
                        message: error.localizedDescription
                    )
                }
            }
        }
    }

    private func showAlert(
        title: String,
        message: String
    ) {

        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )

        present(alert, animated: true)
    }
}
