import UIKit
import FirebaseFirestore
import FirebaseStorage

class AddBookViewController:
UIViewController,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    func showAlert(message: String) {

        let alert = UIAlertController(
            title: "Thông báo",
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
    var selectedImage: UIImage?
    var selectedBook: Book?
    
    
    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var authorTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
   
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text,
                 !title.isEmpty else {

               showAlert(message: "Vui lòng nhập tên sách")
               return
           }

           guard let author = authorTextField.text,
                 !author.isEmpty else {

               showAlert(message: "Vui lòng nhập tác giả")
               return
           }

        let db = Firestore.firestore()

        let data: [String: Any] = [
            "title": title,
            "author": author,
            "description": descriptionTextView.text ?? "",
            "imageUrl": "book1",
            "favoriteCount": 0
        ]

        if let book = selectedBook {

            db.collection("books")
                .document(book.id)
                .updateData(data) { error in

                    if error == nil {

                        self.navigationController?
                            .popViewController(animated: true)
                    }
                }

        } else {

            db.collection("books")
                .addDocument(data: data) { error in

                    if error == nil {

                        self.navigationController?
                            .popViewController(animated: true)
                    }
                }
        }
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let book = selectedBook {

              titleTextField.text = book.title
              authorTextField.text = book.author
              descriptionTextView.text = book.description
          }

          bookImageView.isUserInteractionEnabled = true

          let tap = UITapGestureRecognizer(
              target: self,
              action: #selector(chooseImage)
          )

          bookImageView.addGestureRecognizer(tap)
      
    }
  

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {

        if let image = info[.originalImage] as? UIImage {

            selectedImage = image

            bookImageView.image = image

            print("Đã đổi ảnh")
        }

        dismiss(animated: true)
    }
    @objc func chooseImage() {

        let picker = UIImagePickerController()

        picker.delegate = self
        picker.sourceType = .photoLibrary

        present(picker, animated: true)
    }
    @objc func selectImage() {

        print("Đã bấm ảnh")

        let picker = UIImagePickerController()

        picker.delegate = self
        picker.sourceType = .photoLibrary

        present(picker, animated: true)
    }
    func uploadImage(completion: @escaping (String?) -> Void) {

        guard let image = selectedImage,
              let imageData = image.jpegData(compressionQuality: 0.7) else {

            completion(nil)
            return
        }

        let fileName = UUID().uuidString + ".jpg"

        let storageRef = Storage.storage()
            .reference()
            .child("books/\(fileName)")

        storageRef.putData(imageData, metadata: nil) { metadata, error in

            if let error = error {

                print(error.localizedDescription)
                completion(nil)
                return
            }

            storageRef.downloadURL { url, error in

                guard let url = url else {

                    completion(nil)
                    return
                }

                completion(url.absoluteString)
            }
        }
    }

}

