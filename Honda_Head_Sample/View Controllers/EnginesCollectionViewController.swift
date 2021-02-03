//
//  EnginesCollectionViewController.swift
//  HondaHead
//
//  Created by Ryan Sady on 11/12/20.
//

import UIKit
import WhatsNewKit

class EnginesCollectionViewController: UICollectionViewController {
    
    let engineTypes = [EngineType(series: .ASeries, displayName: "A-Series", desc: "1.6-2.0L Inline 4", image: UIImage(named: "a-series")),
                       EngineType(series: .BSeries, displayName: "B-Series", desc: "1.6-2.1L Inline 4", image: UIImage(named: "b-series")),
                       EngineType(series: .CSeries, displayName: "C-Series", desc: "2.0-3.5L V6",       image: UIImage(named: "c-series")),
                       EngineType(series: .DSeries, displayName: "D-Series", desc: "1.3-1.7L Inline 4", image: UIImage(named: "d-series")),
                       EngineType(series: .FSeries, displayName: "F-Series", desc: "2.0-2.3L Inline 4", image: UIImage(named: "f-series")),
                       EngineType(series: .GSeries, displayName: "G-Series", desc: "2.0-2.5L Inline 4", image: UIImage(named: "g-series")),
                       EngineType(series: .HSeries, displayName: "H-Series", desc: "2.0-2.3L Inline 4", image: UIImage(named: "h-series")),
                       EngineType(series: .JSeries, displayName: "J-Series", desc: "2.5-3.7L V6", image: UIImage(named: "j-series")),
                       EngineType(series: .KSeries, displayName: "K-Series", desc: "2.0-2.4L Inline 4", image: UIImage(named: "k-series")),
                       EngineType(series: .LSeries, displayName: "L-Series", desc: "1.2-1.5L Inline 4", image: UIImage(named: "l-series")),
                       EngineType(series: .NSeries, displayName: "N-Series", desc: "2.2L Inline 4 Diesel",     image: UIImage(named: "n-series")),
                       EngineType(series: .RSeries, displayName: "R-Series", desc: "1.6-2.0L Inline 4", image: UIImage(named: "r-series"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    override func viewDidLayoutSubviews() {
        navigationController?.navigationBar.isHidden = true
    }
    
    

}

//MARK: - Helpers
extension EnginesCollectionViewController {
    fileprivate func setupView() {
        navigationController?.navigationBar.isHidden = true
        collectionView.collectionViewLayout = HeaderCollectionViewFlowLayout()
        EnginesCollectionViewController.versionStore = KeyValueWhatsNewVersionStore(keyValueable: UserDefaults.standard, prefixIdentifier: "hondahead")
        
        presentWhatsNewViewController()
    }
}

//MARK: - UICollectionViewDataSource
extension EnginesCollectionViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return engineTypes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.engineType, for: indexPath) as? EngineTypeCollectionViewCell else { fatalError() }
        cell.engineType = engineTypes[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let subseriesController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "engineSubseries") as? EngineSeriesViewController else { return }
        subseriesController.selectedEngineSeries = engineTypes[indexPath.item].series
        navigationController?.pushViewController(subseriesController, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "engineHeader", for: indexPath) as? ReuseableHeaderView else {
                fatalError("Invalid view type")
            }
            
            headerView.imageView.image = UIImage(named: "engine_header")
            return headerView
        default:
            assert(false, "Invalid element type")
            return UICollectionReusableView()
        }
    }


}

// MARK: UICollectionViewDelegateFlow
extension EnginesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.bounds.width / 2.3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
    }
}
