//
//  EnginesViewController.swift
//  HondaHead
//
//  Created by Ryan Sady on 12/1/20.
//

import UIKit
import BouncyLayout
import TBEmptyDataSet
import GoogleMobileAds

class EnginesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var engines = [Engine]()
    var subseries: EngineSubSeries?
    var adCount: Int = 0
    private var premiumObserver: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        if let series = subseries {
            loadEngines(for: series)
        } else {
            let alertController = UIAlertController(title: "Yikes", message: "Looks like there was an error reading some data.  Try that again.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok!", style: .default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
                APIClient.reportNonfatal(error: APIErrors.noSelectedEngineSubseries)
            }))
            present(alertController, animated: true, completion: nil)
        }
    }


}

extension EnginesViewController {
    fileprivate func setupView() {
        collectionView.collectionViewLayout = BouncyLayout(style: .regular)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetDataSource = self
        collectionView.register(UINib(nibName: "BannerAdCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CellIdentifiers.bannerAd)
    }
    
    fileprivate func loadEngines(for series: EngineSubSeries) {
        var engineClass = String(series.title.prefix(3))
        if engineClass.contains("ZC") {
            engineClass = "ZC"
        }
        adCount = 0
        self.navigationItem.title = "\(engineClass) Engines"
        self.engines = engines.filter({ $0.code.prefix(3).elementsEqual(engineClass) })
        if !UserPrefsManager.shared.isPremiumMember {
            self.adCount = self.engines.count / 7
        }
        collectionView.reloadData()
    }
    
    fileprivate func setupObserver() {
        premiumObserver = UserPrefsManager.shared.observe(\.isPremiumMember, options: [.new], changeHandler: { [weak self] (defaults, change) in
            guard let weakSelf = self , let _ = change.newValue else { return }
            if let series = weakSelf.subseries {
                weakSelf.loadEngines(for: series)
            }
        })
    }
    
}

//MARK: - UICollectionViewDataSource
extension EnginesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return engines.count + adCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var item = indexPath.item
        if !UserPrefsManager.shared.isPremiumMember && indexPath.item.isMultiple(of: 7) && indexPath.item != 0 {
            guard let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.bannerAd, for: indexPath) as? BannerAdCollectionViewCell else { fatalError() }
            bannerCell.bannerView.rootViewController = self
            bannerCell.bannerView.adUnitID = AdMob_Client.adIdentifier
            bannerCell.bannerView.load(GADRequest())
            return bannerCell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.engine, for: indexPath) as? EngineCollectionViewCell else { fatalError() }
            if !UserPrefsManager.shared.isPremiumMember {
                item = item - (item / 7)
            }
            cell.subseries = subseries
            cell.engine = engines[item]
            return cell
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = collectionView.cellForItem(at: indexPath) as? BannerAdCollectionViewCell { return }
        guard let engineDetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "engineDetail") as? EngineDetailViewController else { return }
        var item = indexPath.item
        if !UserPrefsManager.shared.isPremiumMember {
            item = item - (item / 7)
        }
        engineDetailController.engine = engines[item]
        engineDetailController.engineImage = subseries?.image
        navigationController?.pushViewController(engineDetailController, animated: true)
    }

}


//MARK: - UICollectionViewDelegateFlow
extension EnginesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if !UserPrefsManager.shared.isPremiumMember && indexPath.item.isMultiple(of: 7) && indexPath.item != 0 { //Ad Banner
            return CGSize(width: collectionView.bounds.width, height: 82)
        } else {
            return CGSize(width: view.bounds.width - 16, height: 85)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16.0, left: 8.0, bottom: 16.0, right: 8.0)
    }
}

extension EnginesViewController: TBEmptyDataSetDelegate, TBEmptyDataSetDataSource {
    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        NSAttributedString(string: "Well That's Embarassing")
    }
    
    func descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        NSAttributedString(string: "It looks like we haven't gotten to adding in any info for this engine series.  We're constantly working to keep the data up to date and complete so keep checking back for updates.")
    }
}
