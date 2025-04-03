//
//  FilterProductsBottomSheet.swift
//  IBI Products Store
//
//  Created by Elisha Chirchir on 03/04/2025.
//

import UIKit

class FilterProductsBottomSheet: UIViewController {
    private var selectedFilter: ProductFilter
    private var completion: ((ProductFilter) -> Void)?
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sort By"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    init(selectedFilter: ProductFilter, completion: @escaping (ProductFilter) -> Void) {
        self.selectedFilter = selectedFilter
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGesture()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        
        stackView.addArrangedSubview(titleLabel)
        
        ProductFilter.allCases.forEach { filter in
            let button = createRadioButton(for: filter)
            stackView.addArrangedSubview(button)
        }
        
        contentView.addSubview(stackView)
        view.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
    private func createRadioButton(for filter: ProductFilter) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(filter.rawValue, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 36, bottom: 0, right: 0)
        button.tag = ProductFilter.allCases.firstIndex(of: filter) ?? 0
        
        let indicatorView = UIView()
        indicatorView.layer.borderWidth = 2
        indicatorView.layer.borderColor = UIColor.systemBlue.cgColor
        indicatorView.layer.cornerRadius = 10
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        let innerCircle = UIView()
        innerCircle.backgroundColor = .systemBlue
        innerCircle.layer.cornerRadius = 6
        innerCircle.isHidden = filter != selectedFilter
        innerCircle.translatesAutoresizingMaskIntoConstraints = false
        
        indicatorView.addSubview(innerCircle)
        button.addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            indicatorView.widthAnchor.constraint(equalToConstant: 20),
            indicatorView.heightAnchor.constraint(equalToConstant: 20),
            indicatorView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            
            innerCircle.widthAnchor.constraint(equalToConstant: 12),
            innerCircle.heightAnchor.constraint(equalToConstant: 12),
            innerCircle.centerXAnchor.constraint(equalTo: indicatorView.centerXAnchor),
            innerCircle.centerYAnchor.constraint(equalTo: indicatorView.centerYAnchor)
        ])
        
        button.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func radioButtonTapped(_ sender: UIButton) {
        guard let newFilter = ProductFilter.allCases[safe: sender.tag] else { return }
        selectedFilter = newFilter
        completion?(newFilter)
        dismiss(animated: true)
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc private func handleDismiss() {
        dismiss(animated: true)
    }
}

extension FilterProductsBottomSheet: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == view
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
