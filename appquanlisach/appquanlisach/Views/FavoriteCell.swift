
import UIKit

class FavoriteCell: UITableViewCell {


    @IBOutlet weak var bookImageView: UIImageView!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var heartButton: UIButton!
    
    var removeAction: (() -> Void)?
    @IBAction func heartButtonTapped(_ sender: UIButton) {
           removeAction?()
       }
}
