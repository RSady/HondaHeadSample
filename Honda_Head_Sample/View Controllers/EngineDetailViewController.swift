//
//  EngineDetailViewController.swift
//  HondaHead
//
//  Created by Ryan Sady on 12/1/20.
//

import UIKit
import GoogleMobileAds
import FirebaseCrashlytics

class EngineDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    private var premiumObserver: NSKeyValueObservation?
    var headerViewHeight: CGFloat = 150
    var engine: Engine?
    var engineImage: UIImage?
    let sectionTitles = ["Tech Info", "Notes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let engine = engine {
            setupView()
            populateData(from: engine)
        } else {
            let alertController = UIAlertController(title: "Yikes", message: "Looks like there was an error reading some data.  Try that again.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok!", style: .default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
                APIClient.reportNonfatal(error: APIErrors.noEngine)
            }))
            present(alertController, animated: true, completion: nil)
        }
        setupObserver()
    }
    
    override func viewWillLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
        tableView.reloadData()
    }

}

//MARK: - Helpers
extension EngineDetailViewController {
    fileprivate func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifiers.engineNotes)
        
        let headerView = StretchyTableHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: headerViewHeight))
        headerView.imageView.image = engineImage
        tableView.tableHeaderView = headerView
        
        if UserPrefsManager.shared.isPremiumMember {
            bannerView.isHidden = true
            tableViewBottomConstraint.constant = 8
        } else {
            setupAdBanner(for: bannerView)
        }
    }
    
    fileprivate func populateData(from engine: Engine) {
        navigationItem.title = engine.code
        self.engine?.infoList = engine.infoList.sorted(by: { $0.order > $1.order })
    }
    
    fileprivate func setupObserver() {
        premiumObserver = UserPrefsManager.shared.observe(\.isPremiumMember, options: [.new], changeHandler: { [weak self] (defaults, change) in
            guard let weakSelf = self, let isPremium = change.newValue else { return }
            if isPremium {
                weakSelf.bannerView.isHidden = true
                weakSelf.tableViewBottomConstraint.constant = 8
            } else {
                weakSelf.bannerView.isHidden = false
                weakSelf.tableViewBottomConstraint.constant = 82
            }
        })
    }
}

extension EngineDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // Subtract one for notes item which is in section 2
            return (engine?.infoList.count ?? 1) - 1
        } else if section == 1 {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.engineDetail, for: indexPath) as? EngineInfoTableViewCell else { fatalError() }
            cell.engineDetail = engine?.infoList[indexPath.row]
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.engineNotes, for: indexPath)
            cell.textLabel?.text = engine?.infoList.last?.value
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = .preferredFont(forTextStyle: .caption1)
            return cell
        } else {
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView = self.tableView.tableHeaderView as? StretchyTableHeaderView else { return }
        headerView.scrollViewDidScroll(scrollView: scrollView)
    }
}
