
import UIKit

class AdminBookCell: UITableViewCell {

    @IBOutlet weak var bookImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var authorLabel: UILabel!

    @IBOutlet weak var favoriteLabel: UILabel!

    @IBOutlet weak var editButton: UIButton!

    @IBOutlet weak var deleteButton: UIButton!
    
    var editAction: (() -> Void)?
      var deleteAction: (() -> Void)?

      @IBAction func editTapped(_ sender: UIButton) {
          editAction?()
      }

      @IBAction func deleteTapped(_ sender: UIButton) {
          deleteAction?()
      }

}
