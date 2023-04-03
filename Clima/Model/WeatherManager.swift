
import Foundation;
import UIKit;

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherDTO);
    func testDelegates();
    func didFailWithError(_ error: Error);
}

struct WeatherManager{
    
   static var  delegate : WeatherManagerDelegate?;
    
    var weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=d700c58f0c92f64539d816ed175a4d64&units=metric"
    
    func getByCityName(cityName: String){
        performUrl("\(weatherUrl)&q=\(cityName)");
    }
    
    func getByLatLong(latLongString: String){
        performUrl("\(weatherUrl)&\(latLongString)");
    }
    
    func performUrl(_ urlString: String) {
        WeatherManager.delegate?.testDelegates();
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    
                    WeatherManager.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.decodeData(data: safeData) {
                        
                        WeatherManager.delegate?.didUpdateWeather(self, weather: weather);
                        print(String(data: safeData, encoding: String.Encoding.utf8)!);
                    }
                }
            }
            task.resume()
        }
    }
    
    //    func performUrl(_ urlString: String) {
    //        print("perform url --> \(urlString)")
    //        let  url = URL(string: urlString);
    //        if url != nil {
    //            let urlSession = URLSession(configuration: .default);
    //            let urlSessionTask = urlSession.dataTask(with: url!, completionHandler: {( data, response, error) in
    //
    //                if let error {
    //                    print(error);
    //                    return;
    //                }
    //
    //                if data != nil {
    //                    let safeData = data!;
    //                    print("got some data ..\(String(describing: safeData.toString()))");
    //                    let weathedDto =  self.decodeData(data: safeData);
    //
    //                    if weathedDto != nil  {
    //                        print("going to pass it to the next screen");
    //                       self.delegate?.didUpdateWeather(self, weather: weathedDto!);
    //
    //                    }
    //
    //                }
    //
    //            });
    //            urlSessionTask.resume();
    //        }
    //    }
    //
    func  decodeData(data: Data) -> WeatherDTO? {
        
        let jsonDecoder = JSONDecoder();
        
        do{
            let decodedData = try jsonDecoder.decode(WeatherDeta.self, from: data);
            
            return WeatherDTO(id: decodedData.weather[0].id,
                              name: decodedData.name,
                              temp: decodedData.main.temp,
                              waetherName: decodedData.weather[0].main,
                              weatherDescription: decodedData.weather[0].description);
            
            
            
        }catch{
            WeatherManager.delegate?.didFailWithError(error);
            print(error);
        }
        
        return nil;
    }
    
    
}

extension Data
{
    func toString() -> String?
    {
        return String(data: self, encoding: .utf8)
    }
}
