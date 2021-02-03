//
//  EngineSeriesViewController.swift
//  HondaHead
//
//  Created by Ryan Sady on 12/1/20.
//

import UIKit
import BouncyLayout
import GoogleMobileAds
import TBEmptyDataSet

class EngineSeriesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    var selectedEngineSeries: EngineSeries?
    var subseries = [EngineSubSeries]()
    var selectedEngines = [Engine]()
    private var premiumObserver: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        if let series = selectedEngineSeries {
            loadEngines(for: series)
        } else {
            let alertController = UIAlertController(title: "Yikes", message: "Looks like there was an error reading some data.  Try that again.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok!", style: .default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
                APIClient.reportNonfatal(error: APIErrors.noSelectedEngineSeries)
            }))
            present(alertController, animated: true, completion: nil)
        }
        setupObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            navigationController?.navigationBar.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        navigationController?.navigationBar.isHidden = false
    }


}

//MARK: - Helpers
extension EngineSeriesViewController {
    fileprivate func setupView() {
        collectionView.collectionViewLayout = BouncyLayout(style: .regular)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetDataSource = self
        
        if UserPrefsManager.shared.isPremiumMember {
            bannerView.isHidden = true
            collectionViewBottomConstraint.constant = 8
        } else {
            setupAdBanner(for: bannerView)
        }
    }
    
    fileprivate func loadEngines(for series: EngineSeries) {
        DataManager.shared.loadJson(from: DataClasses.engines) { (engines: [Engine]) in
            var tempSeries = [EngineSubSeries]()
            self.selectedEngines = engines.filter({ $0.series == series })
            let selectedSeries = String(series.rawValue.first ?? Character(""))
            self.navigationItem.title = "\(selectedSeries)-Series"
            
            for (index, engine) in self.selectedEngines.enumerated() {
                let engineCode = engine.code.prefix(3)
                let displacementStr = engineCode.suffix(2)
                var displacement = "\(displacementStr.first ?? Character("")).\(displacementStr.last ?? Character(""))"
                if displacement == "Z.C" {
                    displacement = "ZC"
                } else {
                    displacement = "\(displacement)L"
                }
                
                let subEngine = EngineSubSeries(image: UIImage(named: "\(selectedSeries.lowercased())-series"), series: engine.series.rawValue, title: "\(engineCode) Series Engines", subtitle: "(\(displacement))")
                tempSeries.append(subEngine)
                
                if index == (self.selectedEngines.count - 1) {
                    let engineSet = Set(tempSeries)
                    self.subseries = Array(engineSet).sorted(by: { $0.title < $1.title })
                    self.collectionView.reloadData()
                }
            }
            
        }
    }
    
    fileprivate func setupObserver() {
        premiumObserver = UserPrefsManager.shared.observe(\.isPremiumMember, options: [.new], changeHandler: { [weak self] (defaults, change) in
            guard let weakSelf = self , let isPremium = change.newValue else { return }
            if isPremium {
                weakSelf.bannerView.isHidden = true
                weakSelf.collectionViewBottomConstraint.constant = 8
            } else {
                weakSelf.bannerView.isHidden = false
                weakSelf.collectionViewBottomConstraint.constant = 82
            }
        })
    }
}

//MARK: - UICollectionViewDataSource
extension EngineSeriesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subseries.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.engineSubseries, for: indexPath) as? EngineSubseriesCollectionViewCell else { fatalError() }
        cell.subseries = subseries[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let enginesController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "engines") as? EnginesViewController else { return }
        enginesController.engines = self.selectedEngines
        enginesController.subseries = subseries[indexPath.item]
        navigationController?.pushViewController(enginesController, animated: true)
    }

}


//MARK: - UICollectionViewDelegateFlow
extension EngineSeriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width - 16, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

}

//MARK: - Empty Data Delegate
extension EngineSeriesViewController: TBEmptyDataSetDelegate, TBEmptyDataSetDataSource {
    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        NSAttributedString(string: "Well That's Embarassing")
    }
    
    func descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        NSAttributedString(string: "It looks like we haven't gotten to adding in any info for this engine series.  We're constantly working to keep the data up to date and complete so keep checking back for updates.")
    }
}
