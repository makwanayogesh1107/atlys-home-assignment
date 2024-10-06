//
//  CarouselView.swift
//  Atlys Demo
//
//  Created by technocracker on 06/10/24.
//

import UIKit

struct CarouselViewModel {
    let countries: [CountryViewModel]
}

final class CarouselView: UIView, UIScrollViewDelegate {
    
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private var countryViews = [CountryView]()
    
    private let viewModel: CarouselViewModel
    private let imageWidthPercentage: CGFloat = 2.0 / 3.0
    private let imageSpacing: CGFloat = UIScreen.main.bounds.width * (1/6)

    init(viewModel: CarouselViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupScrollView()
        setupPageControl()
        setupCountryViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupScrollView() {
        scrollView.isPagingEnabled = false  // Disable paging
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        // Set scroll view constraints
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0), // Square aspect ratio for the scroll view
            scrollView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setupPageControl() {
        pageControl.numberOfPages = self.viewModel.countries.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.tintColor = .gray
        pageControl.backgroundStyle = .prominent
        addSubview(pageControl)
        
        // Set page control constraints
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    private func setupCountryViews() {
        var previousCountryView: CountryView?

        for country in self.viewModel.countries {
            let countryView = CountryView(viewModel: country)
            countryView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(countryView)
            countryViews.append(countryView)
            
            // Set country view constraints (1:1 aspect ratio, square)
            NSLayoutConstraint.activate([
                countryView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: imageWidthPercentage),
                countryView.heightAnchor.constraint(equalTo: countryView.widthAnchor), // Make it square
                countryView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
            ])
            
            if let previous = previousCountryView {
                countryView.leadingAnchor.constraint(equalTo: previous.trailingAnchor, 
                                                     constant: -imageSpacing).isActive = true
            } else {
                countryView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                     constant: (UIScreen.main.bounds.width * (1 - imageWidthPercentage)) / 2).isActive = true
            }

            previousCountryView = countryView
        }

        if let lastCountryView = previousCountryView {
            lastCountryView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                      constant: -(UIScreen.main.bounds.width * (1 - imageWidthPercentage)) / 2).isActive = true
        }
    }
    
    func centerHorizontally() {
        let xContentOffset = (scrollView.contentSize.width / 2) - (scrollView.bounds.size.width / 2)
        scrollView.contentOffset = CGPoint(x: xContentOffset, y: scrollView.contentOffset.y)
        zoomInCenterImage()
    }

    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        zoomInCenterImage()
    }
    
    private func zoomInCenterImage() {
        let pageWidth = scrollView.frame.width * imageWidthPercentage
        let centerOffset = scrollView.contentOffset.x + (scrollView.frame.width / 2)
        
        for countryView in countryViews {
            let countryCenterX = countryView.center.x
            let distance = abs(centerOffset - countryCenterX)
            let scale = max(imageWidthPercentage, 1 - (distance / pageWidth) * imageWidthPercentage)
            countryView.transform = CGAffineTransform(scaleX: scale, y: scale)
            countryView.layer.zPosition = scale > self.imageWidthPercentage ? 1 : 0 // Center image on top
        }
        
        // Update page control
        let currentPage = Int((scrollView.contentOffset.x + (pageWidth / 2)) / pageWidth)
        pageControl.currentPage = currentPage
    }
}
