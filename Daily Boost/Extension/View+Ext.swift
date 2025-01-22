//
//  View+Ext.swift
//  Daily Boost
//
//  Created by Long Nguyen on 11/7/24.
//

import SwiftUI

//This extension is for converting Image to UIImage
//all code below is from StackOverflow

extension View {
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        controller.view.backgroundColor = .clear
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        windowScene?.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
    
    //convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

//How to use
/*
 Case 1:
let image: Image = Image("MyImageName") // Create an Image
let uiImage: UIImage = image.asUIImage()
 
 
 Case 2:
 var myView: some View {
    Text("Hello")
 }
 let uiImage = myView.asUIImage() // Works Perfectly
 
 
*/
