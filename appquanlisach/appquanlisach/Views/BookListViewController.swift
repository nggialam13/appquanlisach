//
//  BookListViewController.swift
//  appquanlisach
//
//  Created by linda on 30/5/26.
//

import UIKit

class BookListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   
    let books = [

        Book(
            title: "Lập trình iOS ",
            author: "Nguyễn Văn A",
            imageName: "book1"
        ),

        Book(
            title: "Clean Code",
            author: "Robert Martin",
            imageName: "book2"
        ),

        Book(
            title: "Flutter cơ bản",
            author: "Phạm Văn B",
            imageName: "book3"
        ),
        Book(
            title: "Flutter cơ bản",
            author: "Phạm Văn B",
            imageName: "book3"
        ),
        Book(
            title: "Flutter cơ bản",
            author: "Phạm Văn B",
            imageName: "book3"
        ),
        Book(
            title: "Flutter cơ bản",
            author: "Phạm Văn B",
            imageName: "book3"
        ),
        Book(
            title: "Flutter cơ bản",
            author: "Phạm Văn B",
            imageName: "book3"
        ),
        Book(
            title: "Flutter cơ bản",
            author: "Phạm Văn B",
            imageName: "book3"
        )

    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension BookListViewController:
UITableViewDelegate,
UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        books.count
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

        cell.bookImageView.image =
            UIImage(named: book.imageName)

        return cell
    }
}
