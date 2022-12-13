//
//  HistoryTableViewCell.swift
//  BMITrackingApp-TanishkReddy
//
//  Created by Tanishk Sai Reddy Peruvala-301293616 on 2022-12-12.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    
    var history: History? {
        didSet {
            setupView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        self.bmiLabel.text = String(format: "%.2f", self.history!.bmi)
        self.dateLabel.text = self.history!.date?.formatted(.dateTime)
        self.weightLabel.text = String(format: "%.2f", self.history!.weight)
    }
    
}
