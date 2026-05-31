

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PassWordTextField: UITextField!
    
    @IBOutlet weak var RegisterButton: UIButton!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hi???")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {

          guard let email = EmailTextField.text,
                let password = PassWordTextField.text,
                !email.isEmpty,
                !password.isEmpty else {

              showAlert(title: "Lỗi", message: "Vui lòng nhập email và mật khẩu")
              return
          }

          Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in

              DispatchQueue.main.async {

                  if let error = error {
                      self?.showAlert(title: "Đăng nhập thất bại",
                                      message: error.localizedDescription)
                      return
                  }

                  self?.showAlert(title: "Thành công",
                                  message: "Đăng nhập thành công")

                  // Chuyển màn hình
                   self?.performSegue(withIdentifier: "BookListViewController", sender: nil)
              }
          }
      }

      private func showAlert(title: String, message: String) {

          let alert = UIAlertController(
              title: title,
              message: message,
              preferredStyle: .alert
          )

          alert.addAction(UIAlertAction(title: "OK", style: .default))

          present(alert, animated: true)
      }
  }

