//
//  Notification.swift
//  Ello
//
//  Created by Colin Gray on 2/17/2015.
//  Copyright (c) 2015 Ello. All rights reserved.
//

import UIKit


enum NotificationFilterType: String {
    case All = "NotificationFilterTypeAll"
    case Misc = "NotificationFilterTypeMisc"
    case Mention = "NotificationFilterTypeMention"
    case Heart = "NotificationFilterTypeHeart"
    case Repost = "NotificationFilterTypeRepost"
    case Relationship = "NotificationFilterTypeRelationship"
}


class Notification : JSONAble, Authorable {
    typealias Kind = Activity.Kind
    typealias SubjectType = Activity.SubjectType

    let author: User?
    var createdAt: NSDate
    var groupId:String { return notificationId }
    let notificationId: String
    let kind: Kind
    let subjectType: SubjectType
    var subject: AnyObject? { willSet { attributedTitleStore = nil } }

    var textRegion: TextRegion?
    var imageRegion: ImageRegion?

    private var attributedTitleStore: NSAttributedString?
    var attributedTitle: NSAttributedString {
        if let attributedTitle = attributedTitleStore {
            return attributedTitle
        }

        attributedTitleStore = NotificationAttributedTitle.attributedTitle(kind, author: author, subject: subject)
        return attributedTitleStore!
    }

    convenience init(activity: Activity) {
        var author : User? = nil
        if let post = activity.subject as? Post {
            author = post.author
        }
        else if let comment = activity.subject as? Comment {
            author = comment.author
        }
        else if let user = activity.subject as? User {
            author = user
        }

        self.init(author: author, createdAt: activity.createdAt, kind: activity.kind, notificationId: activity.activityId, subjectType: activity.subjectType)
        if let post = activity.subject as? Post {
            self.assignRegionsFromContent(post.summary!)
        }
        else if let comment = activity.subject as? Comment {
            self.assignRegionsFromContent(comment.summary!)
        }
        self.subject = activity.subject
    }

    required init(author: User?, createdAt: NSDate, kind: Kind, notificationId: String, subjectType: SubjectType) {
        self.author = author
        self.attributedTitleStore = nil
        self.createdAt = createdAt
        self.kind = kind
        self.notificationId = notificationId
        self.subjectType = subjectType
        super.init()
    }

    func hasImage() -> Bool {
        return self.imageRegion != nil
    }

    private func assignRegionsFromContent(content : [Regionable]) {
        // assign textRegion and imageRegion from the post content - finds
        // the first of both kinds of regions
        for region in content {
            if self.textRegion != nil && self.imageRegion != nil {
                break
            }
            else if let textRegion = region as? TextRegion {
                if self.textRegion == nil {
                    self.textRegion = textRegion
                }
            }
            else if let imageRegion = region as? ImageRegion {
                if self.imageRegion == nil {
                    self.imageRegion = imageRegion
                }
            }
        }
    }

}