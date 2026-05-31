//
//  BookDetail.swift
//  appquanlisach
//
//  Created by linda on 30/5/26.
//

import UIKit

class BookDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
   
 
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        let favoriteBook = UserDefaults.standard.string(forKey: "favoriteBook")

           print(favoriteBook ?? "Không có dữ liệu")
        tabBarController?.selectedIndex = 1
    }
}
 
