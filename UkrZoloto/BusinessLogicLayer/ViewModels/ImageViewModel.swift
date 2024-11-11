//
//  ImageViewModel.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/12/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

enum ImageViewModel {
  case url(_ url: URL?, placeholder: UIImage?)
  case image(_ image: UIImage?)
}
