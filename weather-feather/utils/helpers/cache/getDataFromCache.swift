
import Foundation

func getDataFromCache(fileName: WeatherDataFileName) throws -> MetApiResponse? {
    
    let url = getCacheUrl()!.appendingPathComponent(fileName.rawValue)
    
    if  FileManager.default.fileExists(atPath: url.path),
        let data = FileManager.default.contents(atPath: url.path) {
        
        do {
            print("Getting data from cache....")
            let weatherData = try decodeJSON(to: MetApiResponse.self, from: data)
            return weatherData
        } catch {
            throw(error)
        }
        
    }
    else {
        print(WeatherError.general(msg: "No data at location: \(url.path)"))
        return nil
    }
}
