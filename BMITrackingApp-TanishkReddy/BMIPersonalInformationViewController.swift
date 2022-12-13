//
//  BMIPersonalInformationViewController.swift
//  BMITrackingApp-TanishkReddy
//
//  Created by Tanishk Sai Reddy Peruvala-301293616 on 2022-12-12.
//

import UIKit

class BMIPersonalInformationViewController: UIViewController {

    
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var weightUnitSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var heightUnitSegmentedControl: UISegmentedControl!
    
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightTextField.delegate = self
        weightTextField.delegate = self
        genderTextField.delegate = self
        ageTextField.delegate = self
        nameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFromDB()
        
    }
    
    // get  personal information from database
    func fetchFromDB() {
        Task.init {
            self.person = try? await PersonRespository.shared.getPerson()
            self.setUpView()
        }
    }
    
    private func setUpView() {
        if let person = self.person {
            heightTextField.text = String(person.height)
            weightTextField.text = String(person.weight)
            genderTextField.text = person.gender
            ageTextField.text = String(person.age)
            nameTextField.text = person.name
            
            weightUnitSegmentedControl.selectedSegmentIndex = 0
            heightUnitSegmentedControl.selectedSegmentIndex = 0
        }
    }

    @IBAction func doneButtonClicked(_ sender: Any) {
        let name = self.nameTextField.text ?? ""
        let age = Int(self.ageTextField.text ?? "0")!
        let gender = self.genderTextField.text ?? ""
        var weight = 0.0
        if weightUnitSegmentedControl.selectedSegmentIndex == 0 {
            weight = Double(self.weightTextField.text ?? "0.0")!
        } else {
            weight = lbTokg(lb: Double(self.weightTextField.text ?? "0.0")!)
        }
        var height = 0.0
        if heightUnitSegmentedControl.selectedSegmentIndex == 0 {
            height = Double(self.heightTextField.text ?? "0.0")!
        } else {
            height = inToM(inches: Double(self.heightTextField.text ?? "0.0")!)
        }
        
        
        
        
        Task.init {
            let bmi = getBMI(weight: weight, height: height)
            let category = getBMIMessage(bmi: bmi)
            _ = await PersonRespository.shared.addPerson(name: name, age: age, gender: gender, weight: weight, height: height)
            _ = await HistoryRepository.shared.addBMI(bmi: bmi, height: height, weight: weight, date: Date())
            tabBarController?.selectedIndex = 1
            showAlert(message: String(format: "BMI: %.2f \n Category: %@", bmi, category))
            fetchFromDB()
        }
        
        
    }
    
    // lb to kg conversion
    func lbTokg(lb: Double) -> Double {
        return lb/2.205
    }
    
    // inches to meter conversion
    func inToM(inches: Double) -> Double {
        return inches/39.37
    }
    
    // claculate BMI
    func getBMI(weight: Double, height: Double) -> Double {
        return (weight/(height*height))
    }
    
    //get BMI caretegoty
    func getBMIMessage(bmi: Double) -> String {
        if bmi < 16 {
            return "Severe Thinness"
        } else if bmi >= 16 && bmi < 17 {
            return "Moderate Thinness"
        } else if bmi >= 17 && bmi < 18.5 {
            return "Mild Thinness"
        } else if bmi >= 18.5 && bmi < 25 {
            return "Normal"
        } else if bmi >= 25 && bmi < 30 {
            return "Overweight"
        } else if bmi >= 30 && bmi < 35 {
            return "Obese Class I"
        } else if bmi >= 35 && bmi < 40 {
            return "Obese Class II"
        } else if bmi >= 40 {
            return "Obese Class III"
        } else {
            return "Not found"
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            print("Done")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension BMIPersonalInformationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}


