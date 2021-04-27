//
//  ZoomPinchMultiImageView.swift
//  TobinBrothers
//
//  Created by MAC26 on 13/09/17.
//  Copyright © 2017 MAC100. All rights reserved.
//

import UIKit


class ZoomPinchMultiImageView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    var arrCollectionData   : [String]!
    var arrCollectionImage  : [UIImage]!
    var currentImageIndex   = 0
    
    func loadViewFromNib() -> ZoomPinchMultiImageView {
        
        let bundle = Bundle.main
        let nib = UINib(nibName: "ZoomPinchMultiImageView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).last as! ZoomPinchMultiImageView
        
        UIView.animate(withDuration: 0.4, animations: {
            UIApplication.shared.isStatusBarHidden = true
        }, completion: nil)
        return view
    }
    
    func showInView(toView superView:UIView ,withArray array : Array<Any>, withCurrentIndex index : Int) {
        self.frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(self)

        setUpViewForData(arratData: array as! Array<String>)
        self.alpha = 0.0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .beginFromCurrentState] , animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func showInView(toView superView:UIView ,withImageArray array : Array<Any>, withCurrentIndex index : Int) {
        //        self.frame = superView.bounds
        //        superView.addSubview(self)
        self.frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(self)
        
        setUpViewForImageData(arrImageData: array as! Array<UIImage>)
        self.alpha = 0.0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .beginFromCurrentState] , animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func removeFromView()  {
        self.alpha = 1.0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn, .beginFromCurrentState] , animations: {
            self.alpha = 0
        }, completion: { (finished: Bool) -> Void in
            self.removeFromSuperview()
        })
        
    }
    
    func setUpViewForData(arratData : Array<String>) {
        collectionView.register(UINib(nibName: String(describing: SliderCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: SliderCollectionViewCell.self))
        arrCollectionData = arratData
        collectionView.reloadData()
        
        if arrCollectionData.count > 0 {
            self.perform(#selector(scrollCollectionView), with: nil, afterDelay: 0.01)
        }
    }
    
    func setUpViewForImageData(arrImageData : Array<UIImage>) {
        collectionView.register(UINib(nibName: String(describing: SliderCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: SliderCollectionViewCell.self))
        arrCollectionImage = arrImageData
        collectionView.reloadData()
        
        if arrCollectionImage.count > 0 {
            self.perform(#selector(scrollCollectionView), with: nil, afterDelay: 0.01)
        }
    }
    
    @objc func scrollCollectionView() {
        collectionView.scrollToItem(at: IndexPath(item: currentImageIndex, section: 0), at: .right  , animated: false)
    }
    // MARK: - CollectionView delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrCollectionData == nil {
            return arrCollectionImage.count
        }
        return arrCollectionData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell : SliderCollectionViewCell =  collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SliderCollectionViewCell.self), for: indexPath) as! SliderCollectionViewCell
        if arrCollectionData == nil {
            cell.setUpForImage(image: arrCollectionImage[indexPath.row])
        } else if URL(string:  arrCollectionData[indexPath.row]) != nil {
            cell.imageView?.backgroundColor = UIColor.green
            imageFromServerURL(urlString: arrCollectionData[indexPath.row], forCell: cell)
        } else {
            cell.imageView?.backgroundColor = UIColor.red
            cell.imageView?.image = Product_Placeholder
        }
        return cell
    }
    
    func imageFromServerURL(urlString: String, forCell cell: SliderCollectionViewCell) {
        let img = imageWithPixelSize(size: (cell.frame.size))
        cell.setUpForImage(image: img)
        cell.activity.startAnimating()
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                if let image = UIImage(data: data!){
                    cell.setUpForImage(image:image)
                } else {
                    cell.setUpForImage(image: #imageLiteral(resourceName: "placeholder"))
                }
                cell.activity.stopAnimating()
            })
            
        }).resume()
    }
    
    func imageWithPixelSize(size: CGSize, filledWithColor color: UIColor = UIColor.clear, opaque: Bool = false) -> UIImage {
        return imageWithSize(size: size, filledWithColor: color, scale: 1.0, opaque: opaque)
    }
    
    func imageWithSize(size: CGSize, filledWithColor color: UIColor = UIColor.clear, scale: CGFloat = 0.0, opaque: Bool = false) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        color.set()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    //MARK: - Actions
    @IBAction func btnCloseAction(button : UIButton){
        UIView.animate(withDuration: 0.1, animations: {
            UIApplication.shared.isStatusBarHidden = false
        }, completion: nil)
        removeFromView()
    }

}
