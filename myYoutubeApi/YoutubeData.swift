//
//  YoutubeData.swift
//  myYoutubeApi
//
//  Created by Hsuan on 2020/9/5.
//  Copyright © 2020 Hsuan. All rights reserved.
//

import Foundation
struct YoutubeData:Codable {
    var items:[Item]
}
struct Item:Codable{
       var snippet:Snippet
   }

   struct Snippet:Codable {
       var title:String
       var description:String
      var thumbnails:Thumbnails
   }

   struct Thumbnails:Codable {
       var medium:Medium
   }
   struct Medium:Codable {
       var url:URL
   }



