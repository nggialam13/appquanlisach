
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AdminProfileViewController:
UIViewController,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    

    @IBOutlet weak var emailLabel: UILabel!

    @IBOutlet weak var avatarImageView: UIImageView!

    @IBAction func logoutTapped(_ sender: UIButton) {

        let alert = UIAlertController(
               title: "Đăng xuất",
               message: "Bạn có chắc chắn muốn đăng xuất không?",
               preferredStyle: .alert
           )

           alert.addAction(
               UIAlertAction(
                   title: "Không",
                   style: .cancel
               )
           )

           alert.addAction(
               UIAlertAction(
                   title: "Có",
                   style: .destructive
               ) { _ in

                   do {

                       try Auth.auth().signOut()

                       let vc = self.storyboard?
                           .instantiateViewController(
                               withIdentifier: "LoginViewController"
                           )

                       UIApplication.shared.connectedScenes
                           .compactMap { $0 as? UIWindowScene }
                           .first?.windows.first?.rootViewController = vc

                   } catch {

                       let errorAlert = UIAlertController(
                           title: "Lỗi",
                           message: error.localizedDescription,
                           preferredStyle: .alert
                       )

                       errorAlert.addAction(
                           UIAlertAction(
                               title: "OK",
                               style: .default
                           )
                       )

                       self.present(
                           errorAlert,
                           animated: true
                       )
                   }
               }
           )

           present(alert, animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        avatarImageView.layer.cornerRadius =
            avatarImageView.frame.width / 2
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAvatar()
        if let imageData =
            UserDefaults.standard.data(forKey: "adminAvatar") {

            avatarImageView.image = UIImage(data: imageData)
        }

        loadUserInfo()
        
        
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
                    forKey: "adminAvatar"
                )
            }
        }

        dismiss(animated: true)
    }
    
    
    
    
    
    
    @objc func selectImage() {

        let picker = UIImagePickerController()

        picker.delegate = self
        picker.sourceType = .photoLibrary

        present(picker, animated: true)
    }
  
    func uploadAvatar(_ image: UIImage) {

        guard let imageData =
                image.jpegData(compressionQuality: 0.7)
        else {
            return
        }

        guard let uid =
                Auth.auth().currentUser?.uid
        else {
            return
        }

        let storage = Storage.storage()

        let ref = storage.reference()
            .child("avatars/\(uid).jpg")

        ref.putData(imageData) { metadata, error in

            if let error = error {

                print(error.localizedDescription)

                return
            }

            ref.downloadURL { url, error in

                guard let imageUrl =
                        url?.absoluteString
                else {
                    return
                }

                Firestore.firestore()
                    .collection("users")
                    .document(uid)
                    .updateData([
                        "avatar": imageUrl
                    ])
            }
        }
    }
    func loadAvatar(urlString: String) {

        guard let url = URL(string: urlString)
        else {
            return
        }

        URLSession.shared.dataTask(
            with: url
        ) { data, response, error in

            guard let data = data else {
                return
            }

            DispatchQueue.main.async {

                self.avatarImageView.image =
                    UIImage(data: data)
            }

        }.resume()
    }
    func loadUserInfo() {

        if let email = Auth.auth().currentUser?.email {

            emailLabel.text = email
        }

        guard let uid =
                Auth.auth().currentUser?.uid
        else {
            return
        }

        Firestore.firestore()
            .collection("users")
            .document(uid)
            .getDocument { snapshot, error in

                guard let data = snapshot?.data()
                else {
                    return
                }

                if let avatarUrl =
                    data["avatar"] as? String {

                    self.loadAvatar(urlString: avatarUrl)
                }
            }
    }
    
}
