//
//  ImageViewModel.swift
//  NYTPImageCache
//
//  Created by Besta, Balaji (623-Extern) on 08/01/21.
//

import Foundation
struct ImageRowViewModel {
    let filename: String?
    let id: Int?
    let author: String?
    init(_ imageviewrowmodel : ImageModelElement) {
        filename = imageviewrowmodel.filename
        id = imageviewrowmodel.id
        author = imageviewrowmodel.author
    }
}
