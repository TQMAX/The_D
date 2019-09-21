//
//  File.swift
//  The D
//
//  Created by FangRongJie on 2018/8/7.
//  Copyright © 2018年 TQMAX-Lemon. All rights reserved.
//

import HandyJSON

//漫画
struct BasicTypes: HandyJSON {
    var Return: ReturnModel?//漫画
    var data:NovelData?//小说
    var Message: String?
}

struct ReturnModel: HandyJSON {
    var List: [listModel]?
    var PageSize: Int = 0
    var ParentItem: parentModel?
}

struct listModel: HandyJSON {
    var Id: Int = 0
    var ChapterNo: Int = 0
    var Sort: Int = 0
    var Explain: String?
    var FrontCover: String?
    var RefreshTimeStr: String?
    var Title: String?
    var RefreshTime: String?
    var Author: String?
    var LastChapter: chapterModel?
}

struct chapterModel: HandyJSON {
    var Id: Int = 0
    var Explain: String?
    var FrontCover: String?
    var RefreshTimeStr: String?
    var Title: String?
    var RefreshTime: String?
    var Sort: String?
}

struct parentModel: HandyJSON {
    var Id: Int = 0
    var Explain: String?
    var FrontCover: String?
    var Author: String?
    var RefreshTimeStr: String?
    var Title: String?
    var RefreshTime: String?
    var Sort: String?
}

struct ImageModel: HandyJSON {
    var location: String?
    var image_id: Int = 0
    var width: Int = 0
    var height: Int = 0
    var total_tucao: Int = 0
    var webp: Int = 0
    var type: Int = 0
    var img05: String?
    var img50: String?
}

//小说
struct NovelData: HandyJSON {
    var Id: Int = 0
    var Name: String?
    var CId: Int = 0
    var Desc: String?
    var Img: String?
    var LastTime: String?
    var FirstChapterId: Int = 0
    var RefreshTime: String?
    var Author: String?
    var LastChapter: String?
    var BookStatus: String?
    var CName: String?
    var LastChapterId: Int = 0
    //章节json
    var content: String?
    var cname: String?
    var pid: NSNumber?
    var nid: NSNumber?
    var cid: NSNumber?
    var id:  String?
    var name: String?
    
    var BookVote : bookVoteModel?
}

struct bookVoteModel: HandyJSON {
    var BookId: Int = 0
    var TotalScore: Int = 0
    var VoterCount: Int = 0
    var Score: Int = 0
}
