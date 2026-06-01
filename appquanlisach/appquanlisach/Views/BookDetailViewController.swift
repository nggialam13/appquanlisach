import FirebaseFirestore
import UIKit

class BookDetailViewController: UIViewController {
    var selectedBook: Book?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBAction func backButtonTapped(_ sender: UIButton) {
        if navigationController != nil {
              navigationController?.popViewController(animated: true)
          } else {
              dismiss(animated: true)
          }
    }
    @IBAction func addFavoriteButtonTapped(_ sender: UIButton) {
        guard let book = selectedBook else { return }

           let db = Firestore.firestore()

           db.collection("favorites").addDocument(data: [

               "userId": "user1",
               "bookId": book.id

           ]) { error in

               if let error = error {

                   print(error.localizedDescription)

               } else {

                   let alert = UIAlertController(
                       title: "Thành công",
                       message: "Đã thêm vào yêu thích",
                       preferredStyle: .alert
                   )

                   alert.addAction(
                       UIAlertAction(
                           title: "OK",
                           style: .default
                       ) { _ in

                           self.tabBarController?.selectedIndex = 2
                       }
                   )

                   self.present(alert, animated: true)
               }
           }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if let book = selectedBook {

            titleLabel.text = book.title
            authorLabel.text = book.author
            descriptionLabel.text = book.description
            bookImageView.image = UIImage(named: book.imageUrl)
        }
        
    }
        
        
    
   
 
  
}
 
