//
//  CountryView.swift
//  Atlys Demo
//
//  Created by technocracker on 06/10/24.
//

import UIKit

struct CountryViewModel {
    let imageName: String
    var uiImage: UIImage? { UIImage(named: self.imageName) }
}

final class CountryView: UIView {
    
    private let imageView = UIImageView()

    init(viewModel: CountryViewModel) {
        super.init(frame: .zero)
        setupImageView(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupImageView(viewModel: CountryViewModel) {
        imageView.image = viewModel.uiImage
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
