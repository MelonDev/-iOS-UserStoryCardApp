//
//  ViewController.swift
//  UserStory
//
//  Created by Android on 22/4/2562 BE.
//  Copyright © 2562 MelonDev. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        checkEmpty()
        return dataSlot.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCVC", for: indexPath) as! CollectionViewCell
        
        let heroId = "VIEW_\(indexPath.row)"
        
        cell.hero.isEnabled = true
        cell.viewContent.hero.id = heroId
        
        let slot = dataSlot[indexPath.row]
        
        cell.nameLabel.text = slot.name
        cell.asALabel.text = slot.who
        cell.iwantLabel.text = slot.What
        cell.soLabel.text = slot.why
        cell.iknowLabel.text = slot.know
        
        switch slot.size {
        case "normal":
            cell.sizeLabel.text = "N"
            break
        case "medium" :
            cell.sizeLabel.text = "M"
            break
        case "important" :
            cell.sizeLabel.text = "I"
            break
        default:
            cell.sizeLabel.text = "-"
            break
        }
        
        
        return cell
    }
    
    func checkEmpty() {
        if dataSlot.count == 0 {
            emptyLabel.isHidden = false
        }else {
            emptyLabel.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = AppConfig.init().requireViewController(storyboard: "Main", viewController: "ContentVC") as! DetailViewController
        
       
        //self.actionVC(this: self, viewController: vc)
        //self.actionNavVC(this: self, viewController: vc)
        
        //vc.isHeroEnabled = true
        
        let heroId = "VIEW_\(indexPath.row)"
        
        vc.setHero(id: heroId)
        vc.setDetailValue(data: dataSlot[indexPath.row])
        
        let aObjNavi = UINavigationController(rootViewController: vc)
        aObjNavi.modalPresentationStyle = UIModalPresentationStyle.formSheet
        aObjNavi.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        aObjNavi.navigationBar.isTranslucent = false
        
        self.present(aObjNavi,animated: true,completion: nil)
 
    }
 
    var dataSlot :[Data] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hero.isEnabled = true
        
        emptyLabel.isHidden = true
        checkEmpty()


        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView!.register(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CellCVC")
        
        setFlowLayout()
        
        
        
        let ref = Database.database().reference()
        ref.observe(.value, with: {(snapshot) in
            
            self.dataSlot.removeAll()
            
            if(snapshot.hasChildren()){
                
                for slot in snapshot.children {
                    let subSlot = slot as! DataSnapshot
                    
                    let value = subSlot.value as! [String: AnyObject]
                    
                    let d = Data.init(slot: value)
                    
                    self.dataSlot.append(d)
                }
                
                self.collectionView.reloadData()
                
            }else {
                self.collectionView.reloadData()
            }
            
        })

        
        
        
        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        setFlowLayout()
    }
    
    func setFlowLayout() {
        self.collectionView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        
        
        let layout = UICollectionViewFlowLayout()
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if UIDevice().isIpad() {
            
            if UIDevice().isLandscape(){
                let width = screenWidth / 3.4
                
                layout.itemSize = CGSize(width: width , height: 250)
            } else{
                let width = screenWidth / 2.24
                
                layout.itemSize = CGSize(width: width , height: 250)
            }
        }else {
            let width = collectionView!.bounds.width - 40
            
            layout.itemSize = CGSize(width: width , height: 250)
            
        }
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
        
        layout.invalidateLayout()
        collectionView!.collectionViewLayout = layout
        collectionView!.reloadData()
        
        
    }
    
    
}

