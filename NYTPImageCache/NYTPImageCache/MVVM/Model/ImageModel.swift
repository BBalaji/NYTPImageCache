//
//  ImageModel.swift
//  NYTPImageCache
//
//  Created by Besta, Balaji (623-Extern) on 08/01/21.
//
import Foundation

// MARK: - InfoModelElement
public struct ImageModelElement: Codable {
    let format: Format
    let width, height: Int
    let filename: String
    let id: Int
    let author: String
    let authorURL, postURL: String

    enum CodingKeys: String, CodingKey {
        case format, width, height, filename, id, author
        case authorURL = "author_url"
        case postURL = "post_url"
    }
}

enum Format: String, Codable {
    case jpeg = "jpeg"
}

typealias InfoModel = [ImageModelElement]

