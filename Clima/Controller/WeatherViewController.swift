
import UIKit
import CoreLocation;


extension WeatherViewController :  CLLocationManagerDelegate{
        
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("something has happened to the persmissions")
        if(manager.authorizationStatus == CLAuthorizationStatus.denied){
            print("tell the user to turn on their location on this device");
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("something has happened to the location updating..");
        if(!locations.isEmpty){
            if let currentLocation = locations.last {
                locationManager.stopUpdatingLocation();
                let lat = currentLocation.coordinate.latitude;
                let long = currentLocation.coordinate.longitude;
                weatherManager.getByLatLong(latLongString: "lat=\(lat)&lon=\(long)");
                print("found this lat=\(lat)&lon=\(long)");
            }
        }else{
            print("could not get any location");
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error);
    }
}

class WeatherViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet var searchFieldOutlet: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager();
    var locationManager = CLLocationManager();
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        locationManager.delegate = self;
        locationManager.requestWhenInUseAuthorization();
        locationManager.requestLocation();
        
        WeatherManager.delegate = self;
        searchFieldOutlet.delegate = self;
    }

    @IBAction func locationButtonPressed(_ sender: UIButton) {
       
        locationManager.requestLocation();
    }
    @IBAction func searchButtonPressed(_ sender: Any) {
        searchFieldOutlet.endEditing(true);
        getWeather();
    }
    
    func getWeather() -> Void {

        if(searchFieldOutlet.text != ""){
            weatherManager.getByCityName(cityName: searchFieldOutlet.text!);
        }
        
        searchFieldOutlet.text = "";
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getWeather();
        return true;
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            textField.placeholder = "Type something in here";
            return false;
        }else{
            return true;
        }
    }
    
}


extension WeatherViewController:  WeatherManagerDelegate {
    
    func testDelegates() {
        print("we'll never get to this point");
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherDTO) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = "\(String(format: "%.1f", weather.temp))C";
            self.conditionImageView.image = UIImage(systemName: weather.icon);
            self.cityLabel.text =  "\(weather.waetherName) in \(weather.name)";
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error);
    }
    
}
