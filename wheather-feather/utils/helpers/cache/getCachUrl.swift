
import Foundation

func getCacheUrl() -> URL? {
    let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    return urls.first
}
