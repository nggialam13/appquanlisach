import UIKit
import FirebaseFirestore

class favBookViewController:
UIViewController,
UITableViewDelegate,
UITableViewDataSource {

 
    var favoriteBooks: [Book] = []
    
    func loadFavorites() {

        let db = Firestore.firestore()

        db.collection("favorites")
            .whereField("userId", isEqualTo: "user1")
            .getDocuments { snapshot, error in

                if let error = error {
                    print("Lỗi favorites:", error.localizedDescription)
                    return
                }

                guard let docs = snapshot?.documents else {
                    print("Không có dữ liệu favorites")
                    return
                }

                print("Số favorite:", docs.count)

                self.favoriteBooks.removeAll()

                for doc in docs {

                    let bookId = doc["bookId"] as? String ?? ""

                    print("Book ID:", bookId)

                    db.collection("books")
                        .document("book\(bookId)")
                        .getDocument { bookDoc, error in
                            
                            guard let data = bookDoc?.data() else {
                                print("Không tìm thấy book:", bookId)
                                return
                            }
                            print(data)

                            let book = Book(
                                id: data["id"] as? String ?? "",
                                title: data["title"] as? String ?? "",
                                author: data["author"] as? String ?? "",
                                description: data["description"] as? String ?? "",
                                imageUrl: data["imageUrl"] as? String ?? "",
                                favoriteCount: data["favoriteCount"] as? Int ?? 0
                            )

                            self.favoriteBooks.append(book)

                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                }
            }
    }
    @IBOutlet weak var tableView: UITableView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        print(tableView as Any)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        loadFavorites()
    }
}
extension favBookViewController {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {

        return favoriteBooks.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
                   -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "FavoriteCell",
            for: indexPath) as! FavoriteCell

                       let book = favoriteBooks[indexPath.row]

        cell.titleLabel.text = book.title
        cell.authorLabel.text = book.author

        cell.bookImageView.image =
        UIImage(named: book.imageUrl)
                       cell.removeAction = {

                           let alert = UIAlertController(
                               title: "Xóa yêu thích",
                               message: "Bạn có chắc muốn xóa sách này khỏi danh sách yêu thích?",
                               preferredStyle: .alert
                           )

                           alert.addAction(
                               UIAlertAction(
                                   title: "Hủy",
                                   style: .cancel
                               )
                           )

                           alert.addAction(
                               UIAlertAction(
                                   title: "Xóa",
                                   style: .destructive
                               ) { _ in

                                   let book = self.favoriteBooks[indexPath.row]

                                   let db = Firestore.firestore()

                                   db.collection("favorites")
                                       .whereField("userId", isEqualTo: "user1")
                                       .whereField("bookId", isEqualTo: book.id)
                                       .getDocuments { snapshot, error in

                                           guard let docs = snapshot?.documents else {
                                               return
                                           }

                                           for doc in docs {

                                               doc.reference.delete()
                                           }

                                           self.favoriteBooks.remove(at: indexPath.row)

                                           DispatchQueue.main.async {

                                               tableView.reloadData()

                                               let successAlert = UIAlertController(
                                                   title: "Thành công",
                                                   message: "Đã xóa khỏi yêu thích",
                                                   preferredStyle: .alert
                                               )

                                               successAlert.addAction(
                                                   UIAlertAction(
                                                       title: "OK",
                                                       style: .default
                                                   )
                                               )

                                               self.present(
                                                   successAlert,
                                                   animated: true
                                               )
                                           }
                                       }
                               }
                           )

                           self.present(alert, animated: true)
                       }
        return cell
    }
}
