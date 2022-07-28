import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var importanceLabel: UILabel!
    
    var todoItem: TodoItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = todoItem?.title
        descriptionLabel.text = todoItem?.description
        importanceLabel.text = todoItem?.importance
    }
}
