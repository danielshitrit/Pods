
import UIKit
import Firebase
import FirebaseFirestore

import FirebaseStorage

class AddGroceryViewController: UIViewController {
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    let db = Firestore.firestore()
    
    private var isBought = false
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if item != nil{
            self.nameTextField.text  = item?.itemName
            self.isBought = item?.isBought ?? false
            self.switchView.isOn = item?.isBought ?? true ? true : false
            
            if item?.imgUrl != ""{
                downloadImage()
            }
        }
    }
    
    func downloadImage() {
           // Create a reference to the image file in Firebase Storage
        let storageRef = Storage.storage().reference(forURL: item?.imgUrl ?? "")
           
           // Download the image data (2MB limit in this example)
           storageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
               if let error = error {
                   print("Error downloading image: \(error.localizedDescription)")
               } else if let data = data, let image = UIImage(data: data) {
                   self.imgView.image = image
               }
           }
       }
    
    @IBAction func switchAction(_ sender: Any) {
        isBought = switchView.isOn ? true : false
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        guard self.nameTextField.text != ""  else { return }
        self.isImage()
//        if item != nil{
//            let docRef = db.collection("groceryItems").document(item?.id ?? "")
//            
//            docRef.updateData([
//                "itemName": self.nameTextField.text ?? "",
//                "isBought": self.isBought,
//                "timestamp": Timestamp(date: Date())
//            ]) { err in
//                if let err = err {
//                    print("Error updating document: \(err)")
//                } else {
//                    self.navigationController?.popViewController(animated: true)
//                    print("Document successfully updated!")
//                }
//            }
//        }
//        else{
//            let usersRef = db.collection("groceryItems")
//            usersRef.addDocument(data: [
//                "itemName": nameTextField.text ?? "",
//                "isBought": isBought,
//                "timestamp": Timestamp(date: Date())
//            ]) { err in
//                if let err = err {
//                    print("Error adding document: \(err)")
//                } else {
//                    self.navigationController?.popViewController(animated: true)
//                    print("Document added successfully!")
//                }
//            }
//            
//        }
    }
    
    @IBAction func uploadPhoto(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        // Reference to Firebase Storage
        let storageRef = Storage.storage().reference()
        
        // Create a unique image path using UUID
        let imageRef = storageRef.child("groceryImages/\(UUID().uuidString).jpg")
        
        // Convert UIImage to JPEG data
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            // Upload the image data to Firebase Storage
            imageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                // Get the download URL of the uploaded image
                imageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        completion(nil)
                    } else {
                        // Return the image URL as a string
                        completion(url?.absoluteString)
                    }
                }
            }
        }
    }
    
    func isImage(){
        if self.imgView.image != nil{
            uploadImage(self.imgView.image ?? UIImage()) { imageUrl in
                guard let imageUrl = imageUrl else {
                    print("Failed to upload image.")
                    return
                }
                self.addItem(url: imageUrl)
            }
        }
        else{
            addItem(url: "")
            
        }
    }
    
    func addItem(url: String) {
        // Upload the image first
        
        
        // Prepare the data to be uploaded to Firestore
        
        let groceryItem: [String: Any] = [
            "itemName": self.nameTextField.text ?? "",
            "isBought": self.isBought,
            "imageUrl": url,
            "timestamp": Timestamp(date: Date())
        ]
        
        print(groceryItem)
        
        if self.item != nil{
            let docRef = self.db.collection("groceryItems").document(self.item?.id ?? "")
            docRef.updateData(groceryItem) { error in
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                } else {
                    self.navigationController?.popViewController(animated: true)
                    print("Document added successfully!")
                }
            }
        }
        else{
            self.db.collection("groceryItems").addDocument(data: groceryItem) { error in
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                } else {
                    self.navigationController?.popViewController(animated: true)
                    print("Document added successfully!")
                }
            }
        }
        
    }
}

extension AddGroceryViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.imgView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

