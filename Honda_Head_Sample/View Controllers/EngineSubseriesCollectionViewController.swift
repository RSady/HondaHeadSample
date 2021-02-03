//
//  EngineSubseriesCollectionViewController.swift
//  HondaHead
//
//  Created by Ryan Sady on 11/30/20.
//

import UIKit
import BouncyLayout

class EngineSubseriesViewController: UICollectionViewController {

    var selectedEngineSeries: EngineSeries?
    var subseries = [EngineSubSeries]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        if let series = selectedEngineSeries {
            
            loadEngines(for: series)
        } else {
            let alertController = UIAlertController(title: "Yikes", message: "Looks like there was an error reading some data.  Try that again.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok!", style: .default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
                //TODO: Error reporting
            }))
            present(alertController, animated: true, completion: nil)
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            navigationController?.navigationBar.isHidden = true
        }
    }

    deinit {
        print("*** Engine Subseries deinit ***")
    }
    
    override func viewWillLayoutSubviews() {
        navigationController?.navigationBar.isHidden = false
    }
}

//MARK: - Helpers
extension EngineSubseriesViewController {
    fileprivate func setupView() {
        collectionView.collectionViewLayout = BouncyLayout(style: .regular)
    }
    
    fileprivate func loadEngines(for series: EngineSeries) {
        print("Selected Series: \(series)")
        DataManager.shared.loadJson(from: DataClasses.engines) { (engines: [Engine]) in
            var tempSeries = [EngineSubSeries]()
            let selectedEngines = engines.filter({ $0.series == series })
            let selectedSeries = String(series.rawValue.first ?? Character(""))
            self.navigationItem.title = "\(selectedSeries)-Series"
            for (index, engine) in selectedEngines.enumerated() {
                let engineCode = engine.code.prefix(3)
                let displacementStr = engineCode.suffix(2)
                let displacement = "\(displacementStr.first ?? Character("")).\(displacementStr.last ?? Character(""))"
                let seriesTitle = "\(engineCode) Series Engine (\(displacement)L)"
                let subEngine = EngineSubSeries(image: UIImage(named: "\(selectedSeries)-series"), series: engine.series.rawValue, title: seriesTitle)
                tempSeries.append(subEngine)
                
                if index == (engines.count - 1) {
                    let engineSet = Set(tempSeries)
                    self.subseries = Array(engineSet).sorted(by: { $0.title < $1.title })
                    self.collectionView.reloadData()
                    print(self.subseries)
                }
            }
        }
    }
}

//MARK: - UICollectionViewDataSource
extension EngineSubseriesViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subseries.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subseriesCell", for: indexPath) as? EngineSubseriesCollectionViewCell else { fatalError() }
        cell.subseries = subseries[indexPath.item]
        return cell
    }

}


//MARK: - UICollectionViewDelegateFlow
extension EngineSubseriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width - 16, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

}
