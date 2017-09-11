//
//  QuotesViewController.swift
//  Timer
//
//  Created by Bernhard Waidacher on 09.09.17.
//  Copyright © 2017 Bernhard Waidacher. All rights reserved.
//

import Cocoa

class TimerViewController: NSViewController {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var headLine: NSTextField!
    @IBOutlet weak var toWork: NSTextField!
    @IBOutlet weak var worked: NSTextField!
    @IBOutlet weak var difference: NSTextField!
    
    
    let helper:TimerHelper = TimerHelper.sharedInstance
    
    var monthView:MonthView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        headLine.stringValue = ""
        toWork.stringValue = ""
        worked.stringValue = ""
        difference.stringValue = ""
        
        refresh(self)

        collectionView.dataSource = self
        //collectionView.setItemsInRow(items: 8)
    }
    
    @IBAction func refresh(_ sender: Any) {
        let current = Date()
        
        collectionView.removeSubviews()
        
        helper.monthView(for: current.month, year: current.year, completion: {monthView in
            self.monthView = monthView
            self.collectionView.reloadData()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            self.headLine.stringValue = formatter.string(from: current)
            self.toWork.stringValue = "Soll: \(monthView.timeToWork.hourString) Stunden, \(monthView.timeToWork.float / 60 / 60 / 6 ) Tage (6h pro Tag)"
            self.worked.stringValue = "Ist: \(monthView.timeWorked.hourString) Stunden"
            self.difference.stringValue = "Differenz: \((monthView.timeWorked - monthView.timeToWork).abs.hourString) Stunden, \((monthView.timeWorked - monthView.timeToWork).abs.float / 60 / 60 / 6 ) Tage (6h pro Tag)"
        })
    }
    

}


extension TimerViewController:NSCollectionViewDataSource{
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthView?.days ?? 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView .makeItem(withIdentifier: "CalendarViewItem", for: indexPath) as! CalendarViewItem
        item.reset()
        guard  let dayView = monthView?.dayViews[indexPath.item - (monthView?.gapStart ?? 0) + 1] else{return item}
        item.dayView = dayView
        return item
    }
    
    fileprivate func configureCollectionView() {
        // 1
        let flowLayout = NSCollectionViewFlowLayout()
        let size = collectionView.bounds.size.width / 7
        flowLayout.itemSize = NSSize(width: size, height: size)
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.sectionInset = EdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = flowLayout
        
        view.wantsLayer = true
        
    }
}

extension NSCollectionView {
    func setItemsInRow(items: Int) {
        if let layout = self.collectionViewLayout as? NSCollectionViewFlowLayout {

            let itemsInRow: CGFloat = CGFloat(items);
            let innerSpace = layout.minimumInteritemSpacing * (itemsInRow - 1.0)
            let insetSpace:CGFloat = 0
            let width = (frame.width - insetSpace - innerSpace) / itemsInRow
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.itemSize = NSSize(width: width, height: width)
        }
    }
}
