import UIKit

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var titleTextField: UITextField! {
        didSet {
            titleTextField.delegate = self
        }
    }
    @IBOutlet weak var descriptionTextField: UITextField! {
        didSet {
            descriptionTextField.delegate = self
        }
    }
    @IBOutlet weak var importancePickerView: UIPickerView!
    @IBOutlet weak var printAlet: UIButton!
    
    let userDefaults = UserDefaults.standard
    let pickerViewSelectList = ["낮음", "중간", "높음"]
    var selectedPicker: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        importancePickerView.delegate = self
        importancePickerView.dataSource = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func didTapXButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        let todoItem = TodoItem(title: titleTextField.text ?? "값이 없음",
                                description: descriptionTextField.text ?? "설명 값이 없음",
                                importance: "낮음")
        if titleTextField.text == "" {
            let alert = UIAlertController(title: "입력 오류", message: "해야할 일과 간단한 설명을 추가해주세요!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            todoItems.append(todoItem)
        }
        
        dismiss(animated: true, completion: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)

        do {
            let encoder = JSONEncoder()
            let encodedTodoItems = try encoder.encode(todoItems)
            userDefaults.setValue(encodedTodoItems, forKey: "todoItems")
        } catch {
            print("인코딩 에러 발상 저장 실패")
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewSelectList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPicker = pickerViewSelectList[row]
    }    
}
