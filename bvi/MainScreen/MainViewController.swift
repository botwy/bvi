//
//  ViewController.swift
//  bvi
//
//  Created by Елена Гончарова on 05.08.2023.
//

import UIKit

final class MainViewController: UIViewController {
    private let olympiadDataSource = OlympiadDataSource()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.frame = view.frame
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpNavigation()
        view.addSubview(tableView)
        view.addSubview(indicator)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        updateLayout(with: self.view.frame.size)
        
        indicator.startAnimating()
        olympiadDataSource.fetchData { [weak self] in
            self?.tableView.reloadData()
            self?.indicator.stopAnimating()
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (contex) in
            self.updateLayout(with: size)
        }, completion: nil)
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Олимпиады"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func updateLayout(with size: CGSize) {
        tableView.frame = CGRect(origin: .zero, size: size)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return olympiadDataSource.groupsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return olympiadDataSource.getItemsCount(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let olympiad = olympiadDataSource.getItem(for: indexPath)
        cell.setData(olympiad: olympiad)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let group = olympiadDataSource.getGroup(section: section)
        let label = UILabel()
        label.text = group.title
        label.backgroundColor = UIColor(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 0.95)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let olympiad = olympiadDataSource.getItem(for: indexPath)
        let destination = DetailsViewController(olympiad: olympiad)
        navigationController?.pushViewController(destination, animated: true)
    }
    
}
