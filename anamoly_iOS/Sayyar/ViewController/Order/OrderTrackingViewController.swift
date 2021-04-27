//
//  OrderTrackingViewController.swift
//  Sayyar
//
//  Created by Atri Patel on 23/04/20.
//  Copyright © 2020 Atri Patel. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase

class OrderTrackingViewController: BaseViewController, GMSMapViewDelegate {
    
    @IBOutlet private weak var orderTrackingNavigationTitleLabel    : UILabel!
    @IBOutlet private weak var mapView                              : GMSMapView!
    @IBOutlet private weak var willBeThereInLabel                   : UILabel!
    
    var myOrderDetail           : MyOrderDetail?
    private var isPathDrawn     : Bool = false
    private var driverMarker    = GMSMarker()
    private var oldLocation     : CLLocationCoordinate2D?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
    }
    
    //MARK: - Prepare View -
    private func prepareView() {
        if appLanguage == .Dutch {
//            prepareDutchLanguage()
        }
        
        self.prepareGoogleView()
    }
    
    //MARK: - Action Methods -
    @IBAction private func didTapOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//MARK: - Helper Methods -
extension OrderTrackingViewController {
    
    private func prepareDutchLanguage() {
        orderTrackingNavigationTitleLabel.text  = "Spåra din beställning"
        willBeThereInLabel.text                 = "Strax hos dig"
    }
    
    private func setDriverTime(duration : String) {
        guard let myOrderDetail = myOrderDetail else {return}
        DispatchQueue.main.async {
            self.willBeThereInLabel.attributedText = SUtill.getNSAttributedString(fontModel: [
                FontModel.init(font: UIFont.Tejawal.Regular(18),
                               color: .red,
                               text: myOrderDetail.boy_name),
                FontModel.init(font: UIFont.Tejawal.Regular(18),
                               color: .darkGray,
                               text: appLanguage == .Dutch ? " Strax hos dig " : " will be there in "),
                FontModel.init(font: UIFont.Tejawal.Regular(18),
                               color: .red,
                               text: duration)
            ])
        }
    }
    
}

//MARK: - Google Map -
extension OrderTrackingViewController {
    
    private func prepareGoogleView() {
        if let myOrderDetail = myOrderDetail {
            willBeThereInLabel.attributedText = SUtill.getNSAttributedString(fontModel: [
                FontModel.init(font: UIFont.Tejawal.Regular(18),
                               color: .darkGray,
                               text: appLanguage == .Dutch ? " Strax hos dig " : " will be there in ")
            ])
            
            mapView.delegate = self
            mapView.settings.allowScrollGesturesDuringRotateOrZoom = true
            let marker = GMSMarker()
            let fromLocation = CLLocationCoordinate2D(latitude: Double(myOrderDetail.latitude) ?? 0, longitude: Double(myOrderDetail.longitude) ?? 0)
            marker.position = fromLocation
            marker.map = mapView
            marker.title = appLanguage == .Dutch ? "Leverans position" : "Delivery Location"
            marker.icon = UIImage(named: "mapPin")
            mapView.selectedMarker = marker
            mapView.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 21)
            
            mapView.isMyLocationEnabled = true
            
            prepareRoute(myOrderDetail: myOrderDetail, fromLocation: fromLocation)
        }
    }
    
    private func prepareRoute(myOrderDetail : MyOrderDetail, fromLocation : CLLocationCoordinate2D) {
        var ref : DatabaseReference!
        ref = Database.database().reference()
        let _ = ref.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            if let locations = postDict["locations"] {
                if let orderDetail = locations["\(myOrderDetail.order_id ?? 0)"] {
                    if let orderDetail = orderDetail as? NSDictionary {
                        if let lattitude = orderDetail["latitude"] as? Double, let longitude = orderDetail["longitude"] as? Double {
                            let toLocation = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
                            if self.isPathDrawn == false {
                                self.setDeliveryMarker(location: toLocation, myOrderDetail: myOrderDetail)
                                self.pathDraw(fromLocation: fromLocation, toLocation: toLocation)
                            } else {
                                self.updateLocationoordinates(coordinates: toLocation)
                            }
                        }
                    }
                }
            }
        })
    }
    
    private func setDeliveryMarker(location : CLLocationCoordinate2D, myOrderDetail : MyOrderDetail) {
        driverMarker.position = location
        driverMarker.title = myOrderDetail.boy_name
        driverMarker.icon = UIImage(named: "deliveryTruck")
        driverMarker.tracksViewChanges = true
        mapView.selectedMarker = driverMarker
        driverMarker.map = mapView
        mapView.animate(toLocation: location)
    }
    
    private func pathDraw(fromLocation : CLLocationCoordinate2D, toLocation : CLLocationCoordinate2D) {
        let session = URLSession.shared
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(fromLocation.latitude),\(fromLocation.longitude)&destination=\(toLocation.latitude),\(toLocation.longitude)&sensor=false&mode=driving&key=AIzaSyDvAZgScAT5GqJ0AJ1nXU91hSdrH7LyV7A")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
                print("error in JSONSerialization")
                return
            }
            guard let routes = jsonResult["routes"] as? [Any] else {return}
            if (routes.count == 0)  {return}
            guard let route = routes[0] as? [String: Any] else  {return}
            guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {return}
            guard let polyLineString = overview_polyline["points"] as? String else {
                return
            }
            DispatchQueue.main.async {
                self.drawPath(polyString: polyLineString, destinationLocation: toLocation)
            }
            guard let legsArray = route["legs"] as? NSArray, legsArray.count > 0 else {return}
            guard let legsdictionary = legsArray[0] as? NSDictionary else {return}
            guard let duration = legsdictionary["duration"] else {return}
            guard let durationDictionary = duration as? NSDictionary else {return}
            guard let time = durationDictionary["text"] as? String else {return}
            self.setDriverTime(duration: time)
        })
        task.resume()
    }
    
    private func drawPath(polyString: String, destinationLocation : CLLocationCoordinate2D) {
        let path = GMSPath.init(fromEncodedPath: polyString)
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = ColorApp.ColorRGB(189,136,49,1)
        polyline.strokeWidth = 6
        polyline.map = mapView
        
        let camera = GMSCameraPosition.camera(withLatitude: destinationLocation.latitude, longitude: destinationLocation.longitude, zoom: mapView.camera.zoom)
        mapView.camera = camera
        mapView.animate(to: camera)
        isPathDrawn = true
    }
    
    private func updateLocationoordinates(coordinates:CLLocationCoordinate2D) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        driverMarker.position = coordinates
        driverMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        driverMarker.tracksViewChanges = true
        if (oldLocation != nil) {
            driverMarker.rotation = CLLocationDegrees(getHeadingForDirection(fromCoordinate: oldLocation!, toCoordinate: coordinates))
        } else {
            driverMarker.rotation = CLLocationDegrees(getHeadingForDirection(fromCoordinate: coordinates, toCoordinate: coordinates))
        }
        CATransaction.commit()
        mapView.animate(toLocation: coordinates)
        oldLocation = coordinates
    }
    
    private func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Float {
        
        let fLat: Float = Float((fromLoc.latitude).degreesToRadians)
        let fLng: Float = Float((fromLoc.longitude).degreesToRadians)
        let tLat: Float = Float((toLoc.latitude).degreesToRadians)
        let tLng: Float = Float((toLoc.longitude).degreesToRadians)
        let degree: Float = (atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))).radiansToDegrees
        if degree >= 0 {
            return degree
        } else {
            return 360 + degree
        }
    }
    
}
