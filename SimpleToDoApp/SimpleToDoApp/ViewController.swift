import UIKit

var todoItems: [TodoItem] = []

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let userDefaults = UserDefaults.standard
    var selectedItem: TodoItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadTableView),
                                               name: NSNotification.Name(rawValue: "reloadTableView"),
                                               object: nil)
        
        if let items = userDefaults.object(forKey: "todoItems") as? Data {
            loadData(items: items)
        }
    }
    
    func loadData(items: Data) {
        do {
            let decoder = JSONDecoder()
            let decodedItems = try decoder.decode([TodoItem].self, from: items)
            todoItems = decodedItems
        } catch {
            print("디코딩 실패 데이터 불러오기 실패")
        }
    }
    
    func saveData() {
        do {
            let encoder = JSONEncoder()
            let encodedTodoItems = try encoder.encode(todoItems)
            self.userDefaults.setValue(encodedTodoItems, forKey: "todoItems")
            self.userDefaults.synchronize()
        } catch {
            print("인코딩 에러 발상 저장 실패")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? DetailViewController {
            nextViewController.todoItem = selectedItem
        }
    }
    
    @objc func reloadTableView() {
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        
        if todoItems[indexPath.row].isCompleted {
            cell.textLabel?.attributedText = todoItems[indexPath.row].title.strikeThrough()
        } else {
            cell.textLabel?.attributedText = todoItems[indexPath.row].title.removeStrikeThrough()
        }
        return cell

    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedItem = TodoItem(title: todoItems[indexPath.row].title,
                                description: todoItems[indexPath.row].description, importance: todoItems[indexPath.row].importance)
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            todoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let myAction = UIContextualAction(style: .normal,
                                          title: "Complete") { action, view, completionHandler in
            todoItems[indexPath.row].isCompleted.toggle()
            self.tableView.reloadData()
            self.saveData()
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [myAction])
    }
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    func removeStrikeThrough() -> NSAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        return attributeString
    }
}

