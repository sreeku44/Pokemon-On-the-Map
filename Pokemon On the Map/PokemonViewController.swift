//
//  PokemonViewController.swift
//  Pokemon On the Map
//
//  Created by Sreekala Santhakumari on 3/13/17.
//  Copyright © 2017 Klas. All rights reserved.
//

import UIKit
import MapKit

class PokemonViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    @IBOutlet var mapView: MKMapView!
    
    var pokemones = [Pokemon]()
    
    var locationManeger = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPokemon()
        
        self.locationManeger = CLLocationManager()
        self.locationManeger.delegate = self
        self.locationManeger.desiredAccuracy = kCLLocationAccuracyBest  // give the aacuracy
        self.locationManeger.distanceFilter = kCLDistanceFilterNone  // filter any distance constraints
        self.locationManeger.requestWhenInUseAuthorization() // asking permission to use the location
        self.mapView.showsUserLocation = true  // to show the location
        self.locationManeger.startUpdatingLocation()
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let pokemonAnnotation = annotation as! PokemonAnnotation
        
        let annotationView = MKAnnotationView(annotation: pokemonAnnotation, reuseIdentifier: "MyAnnotation")
        annotationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        annotationView.canShowCallout = true
        
        let pictureUrl = URL( string : pokemonAnnotation.pokemon.imageURL)
        
        DispatchQueue.global().async {
            
            let imageData = try! Data(contentsOf: pictureUrl!)
            let pokemonImage  = UIImage(data: imageData)
            
            DispatchQueue.main.async {
               
                let pokemonImageView = UIImageView(image: pokemonImage)
                pokemonImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                
                annotationView.addSubview(pokemonImageView)
            }

        }
        
        
        
        return annotationView

    }
    
    func showPokemon()  {
        
        let url = URL (string:  "https://still-wave-26435.herokuapp.com/pokemon/all")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            let pokemonDictionaries = try! JSONSerialization.jsonObject(with: data!, options:[]) as! [[String:Any]]
            
            for pokemondictionary in pokemonDictionaries {
                
                let name = pokemondictionary ["name"] as! String
                let imageURL = pokemondictionary ["imageURL"] as! String
                let latitude = pokemondictionary ["latitude"] as! Double
                let longitude = pokemondictionary ["longitude"] as! Double
                
                let pokemon = Pokemon (name : name, imageURL : imageURL, latitude : latitude, longitude : longitude)
                self.pokemones.append(pokemon)
                
                // create annotation
                
                let annotation = PokemonAnnotation()
                annotation.title = pokemon.name
                annotation.pokemon = pokemon
                
                annotation.coordinate = CLLocationCoordinate2D(latitude: pokemon.latitude, longitude: pokemon.longitude)
                
                
                self.mapView.addAnnotation(annotation)
                    
                
                
                
               
            }
            
                
            }.resume()
        
            }
    
    
    
    
}
