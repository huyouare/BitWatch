//
//  InterfaceController.swift
//  BitWatch WatchKit Extension
//
//  Created by Jesse Hu on 4/25/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import WatchKit
import Foundation
import BitWatchKit

class InterfaceController: WKInterfaceController {
  
  @IBOutlet var priceLabel: WKInterfaceLabel!
  @IBOutlet var image: WKInterfaceImage!
  @IBOutlet var lastUpdatedLabel: WKInterfaceLabel!
  
  let tracker = Tracker()
  var updating = false
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    // Configure interface objects here.
    image.setHidden(true)
    updatePrice(tracker.cachedPrice())
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
    update()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  private func updatePrice(price: NSNumber) {
    priceLabel.setText(Tracker.priceFormatter.stringFromNumber(price))
  }
  
  private func updateDate(date: NSDate) {
    self.lastUpdatedLabel.setText("Last updated \(Tracker.dateFormatter.stringFromDate(date))")
  }
  
  private func updateImage(originalPrice: NSNumber, newPrice: NSNumber) {
    if originalPrice.isEqualToNumber(newPrice) {
      image.setHidden(true)
    } else {
      if newPrice.doubleValue > originalPrice.doubleValue {
        image.setImageNamed("Up")
      } else {
        image.setImageNamed("Down")
      }
      image.setHidden(false)
    }
  }
  
  private func update() {
    if !updating {
      updating = true
      let originalPrice = tracker.cachedPrice()
      tracker.requestPrice { (price, error) -> () in
        if error == nil {
          self.updatePrice(price!)
          self.updateDate(NSDate())
          self.updateImage(originalPrice, newPrice: price!)
        }
        self.updating = false
      }
    }
  }
  
  @IBAction func refreshTapped() {
    update()
  }
  
}
