
enum WeatherError: Error {
    case fetch(msg: String, code: Int? = nil)
    case general(msg: String)
}
