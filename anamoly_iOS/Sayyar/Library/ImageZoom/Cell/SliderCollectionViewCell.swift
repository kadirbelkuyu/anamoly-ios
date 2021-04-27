//
//  SliderCollectionViewCell.swift
//  TobinBrothers
//
//  Created by MAC26 on 12/09/17.
//  Copyright © 2017 MAC100. All rights reserved.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell,UIScrollViewDelegate {

    @IBOutlet var imgStatic: UIImageView!
    @IBOutlet var activity: UIActivityIndicatorView!
    @IBOutlet var containerScrollView: UIScrollView!
    var imageView: UIImageView?
//    var activity : UIActivityIndicatorView = UIActivityIndicatorView()
    
    var minScale : CGFloat = 1
    var maxScale : CGFloat = 5
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpForImage(image : UIImage){
        
        if containerScrollView.subviews.count != 0 {
            imageView?.removeFromSuperview()
            imageView = nil
        }
        containerScrollView.minimumZoomScale = minScale
        containerScrollView.maximumZoomScale = maxScale
        containerScrollView.delegate
            = self
        containerScrollView.showsHorizontalScrollIndicator = false
        containerScrollView.showsVerticalScrollIndicator = false
        
        containerScrollView.contentInset = UIEdgeInsets.zero
        containerScrollView.scrollIndicatorInsets = UIEdgeInsets.zero;
        containerScrollView.contentOffset = CGPoint(x: 0, y: 0)
        containerScrollView.contentSize = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        
        imageView = UIImageView()
        let size = CGSizeAspectFit(aspectRatio: image.size, boundingSize: self.frame.size)
        imageView?.frame =  CGRect(x: 0, y: 0, width: size.width, height: size.height)
        imageView?.backgroundColor = UIColor.clear
        imageView?.contentMode = .scaleAspectFit
        setUpGesture(imageView: imageView!)
        imageView?.image = image
        imageView?.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        imageView?.isUserInteractionEnabled = true
        containerScrollView.addSubview(imageView!)
        //self.activity.center = self.center
//        if isDeviceIpad {
//            self.activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
//            self.activity.color = UIColor.gray
//        } else {
        self.activity.style = .gray
//        }
        //containerScrollView.addSubview(activity)
    }
    
    func setUpGesture(imageView : UIImageView) {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTap)
    }
    
    //MARK :- zoom and pinch
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if containerScrollView.zoomScale == 1 {
            containerScrollView.zoom(to: zoomRectForScale( withGestureView: recognizer.view as! UIImageView, scale:containerScrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            containerScrollView.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(withGestureView imgView : UIImageView, scale: CGFloat, center: CGPoint) -> CGRect {
        let scrollContainer = imgView.superview as! UIScrollView
        var zoomRect = CGRect.zero
        zoomRect.size.height = imgView.frame.size.height / scale
        zoomRect.size.width  = imgView.frame.size.width  / scale
        let newCenter = imgView.convert(center, from: scrollContainer)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }

    
    //MARK:- UIScrollviewDelegate Method
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    
    func CGSizeAspectFit(aspectRatio : CGSize, boundingSize : CGSize) -> CGSize {
        var boundingSizeModified = boundingSize
        let mW = boundingSizeModified.width / aspectRatio.width
        let mH = boundingSizeModified.height / aspectRatio.height
        if( mH < mW ){
            boundingSizeModified.width = boundingSize.height / aspectRatio.height * aspectRatio.width
        }else if( mW < mH ){
            boundingSizeModified.height = boundingSize.width / aspectRatio.width * aspectRatio.height
        }
        return boundingSizeModified
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView?.frame

        if ((contentsFrame?.size.width)! < boundsSize.width) {
            contentsFrame!.origin.x = (boundsSize.width - (contentsFrame?.size.width)!) / 2.0
        } else {
            contentsFrame?.origin.x = 0.0
        }

        if ((contentsFrame?.size.height)! < boundsSize.height) {
            contentsFrame!.origin.y = (boundsSize.height - (contentsFrame?.size.height)!) / 2.0

        } else {
            contentsFrame?.origin.y = 0.0
        }
        
        imageView?.frame = contentsFrame!;
    }

   
}
