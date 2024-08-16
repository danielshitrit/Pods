
import UIKit
import Firebase
import FirebaseFirestore
class ListViewController: UIViewController {
    var items: [Item] = []

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
        }
    }
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func share(_ sender: Any) {
        var shareArray = [String]()
        items.forEach { item in
            shareArray.append(item.itemName)
        }
        let text = shareArray.joined(separator: ", ")
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchItem()
    }


    func fetchItem() {
        let usersRef = db.collection("groceryItems")
        
        usersRef.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.items = querySnapshot?.documents.compactMap { Item(document: $0) } ?? []
                if UserDefaults.standard.bool(forKey: "yes"){
                    self.items = self.items.sorted { $0.itemName < $1.itemName }
                }
                self.tableView.reloadData()
            }
        }
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        cell.label.text = items[indexPath.row].itemName
        cell.imgView.image = UIImage(named: items[indexPath.row].isBought ? "tick" : "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: AddGroceryViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddGroceryViewController") as! AddGroceryViewController
        vc.item = items[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let docRef = db.collection("groceryItems").document(items[indexPath.row].id)

            docRef.delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    self.items.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
            }
        }
    }
}


struct Item {
    let id: String
    let itemName: String
    let isBought: Bool
    let timestamp: Date
    let imgUrl: String
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let itemName = data["itemName"] as? String,
              let isBought = data["isBought"] as? Bool,
              let timestamp = data["timestamp"] as? Timestamp,
              let imageUrl = data["imageUrl"] as? String
                
        else {
            return nil
        }
        
        self.id = document.documentID
        self.itemName = itemName
        self.isBought = isBought
        self.timestamp = timestamp.dateValue()
        self.imgUrl = imageUrl
    }
}

