import UIKit
import FirebaseFirestore

class BookListViewController: UIViewController {
    var selectedBook: Book?
    @IBOutlet weak var tableView: UITableView!

    var books: [Book] = []

    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        loadBooks()
    }
    

    func loadBooks() {

        db.collection("books").getDocuments { [weak self] snapshot, error in

            if let error = error {
                print("Lỗi lấy sách:", error.localizedDescription)
                return
            }

          
            guard let documents = snapshot?.documents else {
                       return
                   }

                   print("Số sách:", documents.count)

            self?.books.removeAll()

            for document in documents {

                let data = document.data()

                print("DATA:", data)

                let book = Book(
                    id: data["id"] as? String ?? "",
                    title: data["title"] as? String ?? "",
                    author: data["author"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    imageUrl: data["imageUrl"] as? String ?? "",
                    favoriteCount: data["favoriteCount"] as? Int ?? 0
                )

                print(book.title)
                print(book.author)

                self?.books.append(book)
            }

            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension BookListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        return books.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "BookCell",
            for: indexPath
        ) as! BookCell

        let book = books[indexPath.row]

        cell.titleLabel.text = book.title
        cell.authorLabel.text = book.author

        // Tạm thời dùng ảnh local
        cell.bookImageView.image = UIImage(named: "book1")

        return cell
        
        
    }
  
      func tableView(_ tableView: UITableView,
                     didSelectRowAt indexPath: IndexPath) {

          selectedBook = books[indexPath.row]

          performSegue(withIdentifier: "showBookDetail",
                       sender: self)
      }
    override func prepare(for segue: UIStoryboardSegue,
                             sender: Any?) {

           if segue.identifier == "showBookDetail" {

               let detailVC =
               segue.destination as! BookDetailViewController

               detailVC.selectedBook = selectedBook
           }
       }
}

