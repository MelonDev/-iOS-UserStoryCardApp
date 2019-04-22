

import UIKit
import FirebaseDatabase

class AddViewController: UIViewController {
    
    @IBAction func cancelAction(_ sender: Any) {

        self.dismissAction()
        
    }
    @IBAction func saveAction(_ sender: Any) {
        
        view.endEditing(true)
        
        if id == nil {
            
            let ref = Database.database().reference()
            let key = ref.childByAutoId().key!
            
            setToFirebase(key: key)

            
        } else {
            setToFirebase(key: id!)
        }
        
    }
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var asText: UITextField!
    @IBOutlet weak var wantText: UITextField!
    
    @IBOutlet weak var soText: UITextField!
    @IBOutlet weak var knowText: UITextField!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var loadingAlert :UIAlertController? = nil

    var data :Data? = nil

    
    
    var id :String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    func edit(data :Data) {
        self.data = data
        self.id = data.key
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if id != nil {
            nameText.text = self.data!.name
            asText.text = self.data!.who
            wantText.text = self.data!.What
            soText.text = self.data!.why
            knowText.text = self.data!.know
            
            segment.selectedSegmentIndex = convertToSegment(value: self.data!.size)!
            
        }
    }
    
    func setToFirebase(key :String) {
        let ref = Database.database().reference().child(key)
        
        let name = nameText.text
        let asA = asText.text
        let want = wantText.text
        let so = soText.text
        let know = knowText.text
        let se = convertFromSegment(value: "\(segment.selectedSegmentIndex)")
        if name != nil
            && asA != nil
            && want != nil
            && so != nil
            && know != nil
            && se != nil {
            if name!.count > 0
                && asA!.count > 0
                && want!.count > 0
                && so!.count > 0
                && know!.count > 0 {
                
                let slot :[String: Any] = ["name": name ?? "" ,"key" :key,"who" :asA ?? "","what" :want ?? "","why" :so ?? "","know" :know ?? "","size" :se ?? ""]
                
                showAlert(message: "Saving..")

                ref.setValue(slot, withCompletionBlock: {error,_ in
                    
                    //self.hideAlert()
                    if error == nil {
                        self.loadingAlert?.dismiss(animated: true, completion: {
                            self.showDialog(title: nil, message: "Saved", positiveString: "Close", completion: {
                                self.dismissAction()
                            })
                        })
                    }else {
                        self.loadingAlert?.dismiss(animated: true, completion: {
                            self.showDialog(title: nil, message: "Error", positiveString: "Close", completion: {})
                        })
                    }
                    
                })
                
            }else {
                self.showDialog(title: nil, message: "Field empty", positiveString: "Close", completion: {})
            }
        }else {
            self.showDialog(title: nil, message: "Field empty", positiveString: "Close", completion: {})
        }
        
    }
    
    func showAlert(message :String) {
        
        
        loadingAlert = UIAlertController(title: nil , message:message, preferredStyle: .alert)
        
        
        
        
        
        loadingAlert!.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10,y: 5,width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        loadingAlert!.view.addSubview(loadingIndicator)
        self.present(loadingAlert!, animated: true)
        
    }
    
    func hideAlert() {
        
        loadingAlert?.dismissAction()
        
    }
    
    
    func showDialog(title :String?,message :String?,positiveString :String ,completion :@escaping () -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionPositive = UIAlertAction(title: positiveString, style: .cancel, handler: { (action) -> Void in
            alert.dismissAction()
            completion()
        })
        
        alert.addAction(actionPositive)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDeleteDialog(title :String?,message :String?,positiveString :String ,negativeString :String,completion :@escaping () -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionPositive = UIAlertAction(title: positiveString, style: .destructive, handler: { (action) -> Void in
            alert.dismissAction()
            completion()
        })
        
        let actionNegative = UIAlertAction(title: negativeString, style: .cancel, handler: { (action) -> Void in
            alert.dismissAction()
        })
        
        alert.addAction(actionPositive)
        alert.addAction(actionNegative)

        self.present(alert, animated: true, completion: nil)
    }
    
    func convertFromSegment(value :String) -> String? {
        switch value {
        case "0":
            return "normal"
        case "1":
            return "medium"
        case "2":
            return "important"
        default:
            return nil
        }
    }
    
    func convertToSegment(value :String) -> Int? {
        switch value {
        case "normal":
            return 0
        case "medium":
            return 1
        case "important":
            return 2
        default:
            return nil
        }
    }
    
    
    
    func setInit(id :String) {
        nameText.text = ""
        asText.text = ""
        wantText.text = ""
        soText.text = ""
        knowText.text = ""
        segment.selectedSegmentIndex = 0
    }
    
    
    
    
}
