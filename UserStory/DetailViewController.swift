//
//  DetailViewController.swift
//  UserStory
//
//  Created by Android on 22/4/2562 BE.
//  Copyright © 2562 MelonDev. All rights reserved.
//

import UIKit
import Hero
import FirebaseDatabase

class DetailViewController: UIViewController {
    
    var loadingAlert :UIAlertController? = nil


    @IBAction func backAction(_ sender: Any) {
        self.dismissAction()
    }
    
    @IBOutlet weak var contentTextBg: UIView!
    @IBOutlet weak var subContentTextBg: UIView!
    
    @IBAction func removeAction(_ sender: Any) {
        showDeleteDialog(title: nil, message: "Delete \(data!.name)", positiveString: "Delete", negativeString: "Cancel", completion: {
            
            self.showAlert(message: "Deleting..")
            
            let ref = Database.database().reference().child(self.data!.key)
            ref.removeValue(completionBlock: {error,_ in
                
                if error == nil {
                    self.loadingAlert?.dismiss(animated: true, completion: {
                        self.showDialog(title: nil, message: "Deleted", positiveString: "Close", completion: {
                            self.dismissAction()
                        })
                    })
                }else {
                    self.loadingAlert?.dismiss(animated: true, completion: {
                        self.showDialog(title: nil, message: "Error", positiveString: "Close", completion: {})
                    })
                }
                
            })
        })
    }
    @IBAction func editAction(_ sender: Any) {
        
        let slot = data!
        
        //print("CLOSED")
        
        //self.dismissAction()
        
        let vc = AppConfig.init().requireViewController(storyboard: "Main", viewController: "AddVC") as! AddViewController
        
        let aObjNavi = UINavigationController(rootViewController: vc)
        aObjNavi.modalPresentationStyle = UIModalPresentationStyle.formSheet
        aObjNavi.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        aObjNavi.navigationBar.isTranslucent = false
        
        vc.edit(data: slot)
        
        
        self.present(aObjNavi,animated: true,completion: nil)
        
        /*
        self.dismiss(animated: true, completion: {
            
            
            print("CLOSED")
            
            let vc = AppConfig.init().requireViewController(storyboard: "Main", viewController: "AddVC") as! AddViewController
            
            //let aObjNavi = UINavigationController(rootViewController: vc)
            //aObjNavi.modalPresentationStyle = UIModalPresentationStyle.formSheet
            //aObjNavi.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            //aObjNavi.navigationBar.isTranslucent = false
            
            //vc.edit(data: slot)
            
            
            self.actionVC(this: self, viewController: vc)
            //self.present(aObjNavi,animated: true,completion: nil)
            
        })
        */
      
        
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var whoLabel: UILabel!
    @IBOutlet weak var whatLabel: UILabel!
    @IBOutlet weak var whyLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var knowLabel: UILabel!
    
    
    
    
    
    
    
    var data :Data? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = ""
        whoLabel.text = ""
        whatLabel.text = ""
        whyLabel.text = ""
        sizeLabel.text = ""
        knowLabel.text = ""

        contentTextBg.setStyleWithOutShadow(viewLayer: contentTextBg, cornerRadius: 10)
        subContentTextBg.setStyleWithOutShadow(viewLayer: contentTextBg, cornerRadius: 10)
    }
    
    func setDetailValue(data :Data) {
        self.data = data
        
        let ref = Database.database().reference()
        ref.observe(.value, with: {(snapshot) in
            
            if(snapshot.hasChildren()){
                
                for slot in snapshot.children {
                    
                    let subSlot = slot as! DataSnapshot
                    
                    if subSlot.key == data.key {
                        let value = subSlot.value as! [String: AnyObject]

                        let data = Data.init(slot: value)
                        
                        self.data = data
                        
                        self.nameLabel.text = data.name
                        self.whoLabel.text = data.who
                        self.whatLabel.text = data.What
                        self.whyLabel.text = data.why
                        switch data.size {
                        case "normal":
                            self.sizeLabel.text = "Normal"
                            break
                        case "medium" :
                            self.sizeLabel.text = "Medium"
                            break
                        case "important" :
                            self.sizeLabel.text = "Important"
                            break
                        default:
                            self.sizeLabel.text = "-"
                            break
                        }
                        self.knowLabel.text = data.know
                        

                    }
                    
                    
                }
                
                
            }
            
        })
        
        
    }
    
    func setHero(id :String){
        
        
        
        self.initVC()
        self.hero.isEnabled = true
        self.view.hero.id = id
        
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

}
