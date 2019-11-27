//
//  FirstViewController.swift
//  CustomTransitionDemo
//
//  Created by Tung on 12.10.19.
//  Copyright © 2019 Tung. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {



    @IBOutlet private var collectionView: UICollectionView!



    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.cellSpacing
        layout.minimumInteritemSpacing = Constants.cellSpacing

        collectionView.setCollectionViewLayout(layout, animated: false)
    }

    func presentSecondViewController(with data: CellData) {
        let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController

        secondViewController.modalPresentationStyle = .fullScreen
        secondViewController.data = data
        present(secondViewController, animated: true)
    }
}

extension FirstViewController {

    enum Constants {

        static let cellSpacing: CGFloat = 8
    }
}
