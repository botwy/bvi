//
//  DetailsViewController.swift
//  bvi
//
//  Created by Елена Гончарова on 07.08.2023.
//

import UIKit

final class DetailsViewController: UIViewController {
    private let olympiad: Olympiad
    
    init(olympiad: Olympiad) {
        self.olympiad = olympiad
        super.init(nibName: nil, bundle: nil)
    }
    
    private lazy var container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)
        container.addSubview(marker)
        container.addSubview(stackView)
        return container
    }()
    
    private lazy var marker: UIView = {
        let wrapper = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 24))
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        let dot = UIView(frame: CGRect(x: 0, y: 6, width: 12, height: 12))
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.backgroundColor = olympiad.level.color
        dot.layer.cornerRadius = 6
        wrapper.addSubview(dot)
        return wrapper
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = olympiad.longName ?? olympiad.name
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 4
        olympiad.links?.forEach {
            let linkView = createLinkView(link: $0)
            stackView.addArrangedSubview(linkView)
        }
        stackView.addArrangedSubview(textView)
        return stackView
    }()
    
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.attributedText = olympiad.description
            .htmlAttributedString()
            .with(font: .systemFont(ofSize: 20))
        textView.textAlignment = .left
        return textView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        view.backgroundColor = .white
        view.addSubview(container)
        activateConstraints()
    }
    
    private func setUpNavigation() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func activateConstraints() {
        let constraints: [NSLayoutConstraint] = [
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor),
            marker.heightAnchor.constraint(equalToConstant: 24),
            marker.widthAnchor.constraint(equalToConstant: 12),
            marker.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            marker.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func createLinkView(link: Link) -> UITextView {
        let linkView = UITextView()
        linkView.translatesAutoresizingMaskIntoConstraints = false
        
        let title = link.title
        let mutableStr = NSMutableAttributedString(string: title)
        mutableStr.addAttribute(.link, value: link.urlStr, range: NSRange(location: 0, length: title.utf16.count))
       
        linkView.attributedText = mutableStr
        linkView.font = UIFont.systemFont(ofSize: 17)
        linkView.textAlignment = .left
        linkView.isEditable = false
        linkView.isScrollEnabled = false
        
        return linkView
    }
    
    @objc
    private func onLinkTap(sender: URLTapGestureRecognizer) {
        if let urlStr = sender.urlStr{
            openUrl(urlString: urlStr)
        }
    }
    
    
    private func openUrl(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
