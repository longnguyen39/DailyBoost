//
//  Notes.swift
//  Daily Boost
//
//  Created by Long Nguyen on 8/4/24.
//

/*
 
 
 -Current highest count: CateAdjustScreen_28
 -When upload Theme Img, be slow and careful
 
 //-------------------------------------------------

 -When add new cate (ie: ):
    1. add the new cate to an enum in the "categories" folder
    2. add new icon for Assets (icon8, 90x90)
    3. add new "if case" to ExtractTitleAndCate in Extension
    4. check purpose array (Onboarding) if desired
    5. update comment, simplenote, gg docs
 
 -When add new title (ie: ):
    1.
    2.
    3.
    4.
    5.
 
 -When add new theme:
    1. Add new images in Assets, naming "theme1" to "theme10"
    2. Pick an option for themeTitleGlobal in screen 21
    3. Run app with screen 16, check the theme in PreviewThemeScreen
    4. Upload them, wait for the cell to turn green
 
 //-------------------------------------------------
 
 
 
 //-------------------------------------------------

 
 -Some code (critical) are only available in iOS 17+
 -All icons for category is found in website icon8
 -Using EnvironmentObject to transit the Onboarding process to the Home screen, below is the site of environmentObject:
 https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-environmentobject-to-share-data-between-views
 
 -We have some extension on Array to remove dup, and on UIScreen dim to dictate the dim of screen
 -We add some Helpers func (freely access from anywhere)
 
 -If we see func with "async throws", we can make it "async" by include 'do catch' inside the func with some 'try await' phrase. Otherwise, we can still make them "async throws" and no need to include 'do catch' block.
 
 -For scrolling the HScrollV, gotta add tapGesture to make it interactive scrollable (on screen 17, onTapGesture)
 
 -For SwiftUI, we can convert UIImage to image. If we reverse, gotta make it from View to UIImage (adding some View extension), this technique is in screen 21
 
 -For file,
    struct: use 'static func', no need instance 'shared'
    class: use 'static let shared', then func
 
 -For uploading theme images, we have to convert a view (in this case, the image) to uiImage (view 21). This is called rendered image. If we just simply convert an Image to uiImage, the uiImage upload is weird and not look like what we see on screen b4 uploading
 -When uploading theme img, gotta make it jpeg cuz we gonna compress it. Swift has jpeg built-in func to compress
 
 -For Quote orderNo, we separate by letting the non-fiction quotes regular Int order, while the fiction quotes is plus  1,000,000 with the hope that not any cate would exceed 1 mil. We do this to fetch only either Fiction/nonF quote
 
 -We wont let user de-select all cate. There must always be 1 cate to show the quotes.
 
 -We use Local notifications to send users quotes. Here is the link to learn more in the future: https://www.youtube.com/watch?v=6Y9KDTjmpLA
 
 -
 
 */

/*
 
 BUGS: (works fine on simulator but suck in real device)
 
 -Cell Appear func: 
 
 
 
 //-------------------------------------------------
 
 Scenario set noti:
 
 1. user login / sign up, screenAppear called
 2. user refresh app with sign in, screenAppear called
 3. user tap noti to open app, screenAppear called
 4. user open pending app, no func called
 5. user tap noti to open app, no func called
 6. user update cateArr
 
 Where to set setNoti func:
 
 1. screenAppear
 2. screenAppear from noti
 3. scene active (with !userID.isEmpty)
 4. user update cateArr (update standbyQ)
 
 
 */
