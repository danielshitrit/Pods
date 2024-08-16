
import UIKit
import Firebase
import FirebaseFirestore

class SettingsViewController: UIViewController {
    @IBOutlet weak var switchView: UISwitch!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "yes"){
            switchView.isOn = true
        }
        else{
            switchView.isOn = false
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clear(_ sender: Any) {
        deleteAllGroceryItems { error in
            if let error = error {
                print("Error deleting grocery items: \(error)")
            } else {
                self.navigationController?.popViewController(animated: true)
                print("All grocery items successfully deleted!")
            }
        }
    }
    
    @IBAction func switchAction(_ sender: Any) {
        UserDefaults.standard.set(switchView.isOn, forKey: "yes")
    }
    
    func deleteAllGroceryItems(completion: @escaping (Error?) -> Void) {
        let groceryItemsRef = Firestore.firestore().collection("groceryItems")
        
        groceryItemsRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                completion(nil)
                return
            }
            
            let batch = Firestore.firestore().batch()
            
            for document in documents {
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { err in
                if let err = err {
                    completion(err)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
