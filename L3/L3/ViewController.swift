//
//  ViewController.swift
//  L3
//
//  Created by Milton Leung on 2019-02-20.
//  Copyright © 2019 ms. All rights reserved.
//

import UIKit
import Mapbox

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let url = URL(string: "mapbox://styles/miltonleung/cjse5srx71w1w1fpjejnfabhd")
    let mapView = MGLMapView(frame: view.bounds, styleURL: url)
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    mapView.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
    view.addSubview(mapView)
  }

}

