//
//  MapViewController.swift
//  codeACity2
//
//  Created by Isaac Douglas on 13/04/19.
//  Copyright © 2019 codeACity2. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backView: UIView!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var itemList: [ItemMap] = []
    var tap: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Mapa"
        let location3 = CLLocationCoordinate2D(latitude: -8.208965354386233, longitude: -35.51045682281256)
       
        let tres = ItemMap.init(name: "Municipios", location: location3, zoom: 8, kml: "Municipios_PE", predios: [])
        itemList = [santoAntonio(), recife(), tres]
        
        self.initLocation()
        self.initCamera()
        placesClient = GMSPlacesClient.shared()
        initCarousel()
    }
    
    func santoAntonio() -> ItemMap {
        let location1 = CLLocationCoordinate2D(latitude: -8.0660695, longitude: -34.879048)
        let endereco1 = "Av. Nossa Sra. do Carmo, 50 - Santo Antônio, Recife - PE, 50030-230"
        let predio1 = Predio.init(name: "Predio", location: location1, endereco: endereco1, image: UIImage(named: "predio1")!, info: "")
        
        let location2 = CLLocationCoordinate2D(latitude: -8.0623965, longitude: -34.8774828)
        let endereco2 = "R. do Imperador Pedro II, 221 - Santana"
        let predio2 = Predio.init(name: "Predio", location: location2, endereco: endereco2, image: UIImage(named: "predio2")!, info: "")
        
        let locationItem = CLLocationCoordinate2D(latitude: -8.063920263040421, longitude: -34.87925793975592)
        return ItemMap.init(name: "Santo Antônio", location: locationItem, zoom: 15, kml: "Santo_antonio", predios: [predio1, predio2])
    }
    
    func recife() -> ItemMap {
        let location1 = CLLocationCoordinate2D(latitude: -8.0553814, longitude: -34.8711631)
        let endereco1 = "R. Bernardo Viêira de Melo, 362-512 - Recife"
        let predio1 = Predio.init(name: "Predio", location: location1, endereco: endereco1, image: UIImage(named: "predio1")!, info: "")
        
        let location2 = CLLocationCoordinate2D(latitude: -8.0620127, longitude: -34.8733701)
        let endereco2 = "R. do Apolo, 59 - Recife Velho"
        let predio2 = Predio.init(name: "Predio", location: location2, endereco: endereco2, image: UIImage(named: "predio2")!, info: "")
        
        let locationItem = CLLocationCoordinate2D(latitude: -8.055445210456666, longitude: -34.87094409763813)
        return ItemMap.init(name: "Recife", location: locationItem, zoom: 14.5, kml: "Recife_antigo", predios: [predio1, predio2])
    }
    
    func initCamera() {
        // Camera e mapView
        guard let settings = Session.settings else { return }
        let latitude = Double(settings.initialLatitude)!
        let longitude = Double(settings.initialLongitude)!
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let camera = GMSCameraPosition.camera(withTarget: location, zoom: Float(settings.zoom))
        mapView.animate(to: camera)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        let bottomMapViewPadding = collectionView.frame.height
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: bottomMapViewPadding, right: 0)
    }
    
    func initLocation() {
        // Localizacao do usuario
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func getAdress(location: CLLocationCoordinate2D) {
        GMSGeocoder().reverseGeocodeCoordinate(location) { response, error in
            DispatchQueue.main.async {
                guard let address = response?.firstResult() else { return }
                print(address.thoroughfare ?? "SEM ENDERECO")
            }
        }
    }
    
    func kml(name: String) {
        let path = Bundle.main.path(forResource: name, ofType: "kml")
        let url = URL(fileURLWithPath: path!)
        let kmlParser = GMUKMLParser(url: url)
        kmlParser.parse()
        let renderer = GMUGeometryRenderer(map: mapView,
                                       geometries: kmlParser.placemarks,
                                       styles: kmlParser.styles)
        renderer.render()
    }
    
    internal func moveCamera(at location: CLLocationCoordinate2D, zoom: Float) {
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: zoom)
        mapView.animate(to: camera)
    }
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        moveCamera(at: coordinate, zoom: 17)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let marker = marker as? Marker {
            let view = DetailMapViewController()
            view.item = marker.item
            view.predio = marker.predio
            view.navigationItem.title = marker.predio?.name
            let nav = UINavigationController(rootViewController: view)
            present(nav, animated: true, completion: nil)
        }
        return true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
        print("Minha Localização")
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.first!
        self.currentLocation = location
        print("Location: \(location)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
