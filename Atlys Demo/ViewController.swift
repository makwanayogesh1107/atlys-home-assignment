//
//  ViewController.swift
//  Atlys Demo
//
//  Created by technocracker on 06/10/24.
//

import UIKit

final class ViewController: UIViewController {
    
    private var carouselView: CarouselView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let carouselViewModel = CarouselViewModel(countries: [CountryViewModel(imageName: "image1"),
                                                              CountryViewModel(imageName: "image2"),
                                                              CountryViewModel(imageName: "image3")])
        self.carouselView = CarouselView(viewModel: carouselViewModel)
        
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(carouselView)
        
        // Set CarouselView constraints
        NSLayoutConstraint.activate([
            carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselView.heightAnchor.constraint(equalTo: carouselView.widthAnchor, multiplier: 1.0),
            carouselView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.carouselView.scrollTo(page: 1)
    }
}
