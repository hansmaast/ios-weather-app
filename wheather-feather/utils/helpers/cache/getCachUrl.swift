//
//  getCachUrl.swift
//  wheather-feather
//
//  Created by Hans Maast on 05/11/2020.
//

import Foundation

func getCacheUrl() -> URL? {
    let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    return urls.first
}
