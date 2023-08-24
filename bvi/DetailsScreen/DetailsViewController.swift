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
        container.addSubview(titleView)
        container.addSubview(stackView)
        return container
    }()
    
    private lazy var titleView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.addArrangedSubview(marker)
        stackView.addArrangedSubview(titleLabel)
        return stackView
    }()
    
    private lazy var marker: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = olympiad.level.color
        view.layer.cornerRadius = 6
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = olympiad.name
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
        view.backgroundColor = .white
        view.addSubview(container)
        activateConstraints()
    }
    
    private func activateConstraints() {
        let constraints: [NSLayoutConstraint] = [
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            titleView.topAnchor.constraint(equalTo: container.topAnchor),
            titleView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            marker.heightAnchor.constraint(equalToConstant: 12),
            marker.widthAnchor.constraint(equalToConstant: 12),
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
