//
//  HistoryEditView.swift
//  BMITrackingApp-TanishkReddy
//
//  Created by Tanishk Sai Reddy Peruvala-301293616 on 2022-12-12.
//

import Foundation
import UIKit

class HistoryEditView: UIView {
    let nibName = "HistoryEditView"
    
    var action: ((_ weight: Double) -> Void)?
    
    @IBOutlet weak var weightTextField: UITextField!
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
    
        override func prepareForInterfaceBuilder() {
            super.prepareForInterfaceBuilder()
            commonInit()
        }
        
        func commonInit() {
            guard let view = loadViewFromNib() else { return }
            view.frame = self.bounds
            self.addSubview(view)
        }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
        
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: HistoryEditView.self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    @IBAction func saveOrUpdateClicked(_ sender: UIButton) {
        action?(Double(weightTextField.text ?? "0.0")!)
        self.removeFromSuperview()
    }
    
    @IBAction func closeClicked(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
}
