import UIKit
import FirebaseFirestore

class AdminBookListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var books: [Book] = []
    var selectedBook: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("ViewDidLoad")

        tableView.delegate = self
        tableView.dataSource = self

        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(
            withIdentifier: "AddBookViewController"
        ) as! AddBookViewController
        
        navigationController?.pushViewController(
            vc,
            animated: true
        )
    }
    @IBAction func editButtonTapped(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(
            withIdentifier: "AddBookViewController"
        ) as! AddBookViewController
        
        navigationController?.pushViewController(
            vc,
            animated: true
        )
    }
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(
            withIdentifier: "AddBookViewController"
        ) as! AddBookViewController
        
        navigationController?.pushViewController(
            vc,
            animated: true
        )
    }
    
    
    
    func loadData() {
        
        Firestore.firestore()
            .collection("books")
            .getDocuments { snapshot, error in
                
                if let error = error {
                    print("Firestore Error: \(error)")
                    return
                }
                
                self.books.removeAll()
                
                guard let documents = snapshot?.documents else {
                    return
                }
                
                for document in documents {
                    
                    let data = document.data()
                    
                    let book = Book(
                        id: document.documentID,
                        title: data["title"] as? String ?? "",
                        author: data["author"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        imageUrl: data["imageUrl"] as? String ?? "",
                        favoriteCount: data["favoriteCount"] as? Int ?? 0
                    )
                    
                    self.books.append(book)
                }
                
                print("Books loaded: \(self.books.count)")
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }
    func editBook(_ book: Book) {
        
        let vc = storyboard?.instantiateViewController(
            withIdentifier: "AddBookViewController"
        ) as! AddBookViewController
        
        vc.selectedBook = book
        
        navigationController?.pushViewController(
            vc,
            animated: true
        )
    }
    func deleteBook(_ book: Book) {
        
        let alert = UIAlertController(
            title: "Xóa sách",
            message: "Bạn có chắc muốn xóa sách này?",
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
                
                Firestore.firestore()
                    .collection("books")
                    .document(book.id)
                    .delete { error in
                        
                        if error == nil {
                            
                            self.loadData()
                        }
                    }
            }
        )
        
        present(alert, animated: true)
    }
}

extension AdminBookListViewController: UITableViewDelegate, UITableViewDataSource {

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
            withIdentifier: "AdminBookCell",
            for: indexPath
        ) as! AdminBookCell

        let book = books[indexPath.row]

        cell.titleLabel.text = book.title
        cell.authorLabel.text = book.author
        cell.favoriteLabel.text = "❤️ \(book.favoriteCount)"

        cell.bookImageView.image =
            UIImage(named: book.imageUrl)

        cell.editAction = { [weak self] in

            self?.editBook(book)
        }

        cell.deleteAction = { [weak self] in

            self?.deleteBook(book)
        }

        return cell
    }
}
