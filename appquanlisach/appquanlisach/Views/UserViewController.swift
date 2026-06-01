
import UIKit
import FirebaseAuth

class UserViewController: UIViewController,
                          UIImagePickerControllerDelegate,
                          UINavigationControllerDelegate {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserInfo()
        print(Auth.auth().currentUser?.email)

        setupAvatar()
        if let imageData =
            UserDefaults.standard.data(forKey: "userAvatar") {

            avatarImageView.image = UIImage(data: imageData)
        }
    }

    func loadUserInfo() {

        if let user = Auth.auth().currentUser {

            emailLabel.text = user.email
        } else {

            emailLabel.text = "Chưa đăng nhập"
        }
    }

    func setupAvatar() {

        avatarImageView.layer.cornerRadius =
            avatarImageView.frame.width / 2

        avatarImageView.clipsToBounds = true

        avatarImageView.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(changeAvatar)
        )

        avatarImageView.addGestureRecognizer(tap)
    }

    @objc func changeAvatar() {

        let picker = UIImagePickerController()

        picker.delegate = self
        picker.sourceType = .photoLibrary

        present(picker, animated: true)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [
            UIImagePickerController.InfoKey : Any
        ]
    ) {

        if let image =
            info[.originalImage] as? UIImage {

            avatarImageView.image = image

            if let imageData =
                image.jpegData(compressionQuality: 0.8) {

                UserDefaults.standard.set(
                    imageData,
                    forKey: "userAvatar"
                )
            }
        }

        dismiss(animated: true)
    }

    @IBAction func logoutButtonTapped(_ sender: UIButton) {

        let alert = UIAlertController(
            title: "Đăng xuất",
            message: "Bạn có chắc muốn đăng xuất không?",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "Huỷ",
                style: .cancel
            )
        )

        alert.addAction(
            UIAlertAction(
                title: "Đăng xuất",
                style: .destructive
            ) { _ in

                do {

                    try Auth.auth().signOut()

                    let successAlert =
                    UIAlertController(
                        title: "Thành công",
                        message: "Đã đăng xuất",
                        preferredStyle: .alert
                    )

                    successAlert.addAction(
                        UIAlertAction(
                            title: "OK",
                            style: .default
                        ) { _ in

                            let storyboard =
                            UIStoryboard(
                                name: "Main",
                                bundle: nil
                            )

                            let loginVC =
                            storyboard.instantiateViewController(
                                withIdentifier:
                                "LoginViewController"
                            )

                            self.view.window?.rootViewController =
                            loginVC

                            self.view.window?.makeKeyAndVisible()
                        }
                    )

                    self.present(
                        successAlert,
                        animated: true
                    )

                } catch {

                    print(error.localizedDescription)
                }
            }
        )

        present(alert, animated: true)
    }
}
