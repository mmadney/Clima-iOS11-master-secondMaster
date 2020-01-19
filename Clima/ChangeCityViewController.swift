import UIKit

protocol changeCityDelegate {
    func userEnterCityName(city : String)
}


class ChangeCityViewController: UIViewController {
    
    var delegate : changeCityDelegate?
    @IBOutlet weak var changeCityTextField: UITextField!
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        let cityname = changeCityTextField.text!
        delegate?.userEnterCityName(city: cityname)
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
