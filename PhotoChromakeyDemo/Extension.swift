//
//  Extension.swift
//  GraphicDemo
//
//  Created by Fumitoshi Ogata on 2014/12/16.
//  Copyright (c) 2014年 Fumitoshi Ogata. All rights reserved.
//

import UIKit

extension UIColor {
    //RGBを取得
    func getRGB() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (red: (r * 255.0), green: (g * 255.0), blue: (b * 255.0), alpha: a)
    }
}

extension UIImage {
        
    func getFilteredImage(_color : UIColor) -> UIImage {
        var _rtnImage : UIImage!
        var _maskImage : UIImage!
        
        //二値化画像をmask画像に設定する
        _maskImage = self.getMaskImageFromTappedColor(_color)
        
        //base画像とmask画像を合成させて、base画像に出力する
        _rtnImage = self.getMaskedImage(_maskImage)
        
        return _rtnImage
    }
            
    //マスクされた画像を作成
    func getMaskedImage(maskImage:UIImage!) -> UIImage {        
        let maskImageReference:CoreImage.CGImage? = maskImage?.CGImage
        let mask = CGImageMaskCreate(CGImageGetWidth(maskImageReference),
            CGImageGetHeight(maskImageReference),
            CGImageGetBitsPerComponent(maskImageReference),
            CGImageGetBitsPerPixel(maskImageReference),
            CGImageGetBytesPerRow(maskImageReference),
            CGImageGetDataProvider(maskImageReference),nil,false)
        let maskedImageReference = CGImageCreateWithMask(self.CGImage, mask)
        let maskedImage = UIImage(CGImage: maskedImageReference)
        return maskedImage!
    }

    //入力した色と同じ色を白に塗りつぶす
    func getMaskImageFromTappedColor(_tColor:UIColor) -> UIImage? {
        var _image = self
        var _width = Int(_image.size.width)
        var _height = Int(_image.size.height)
        var _imageData = _image.imageData()
        var imageBytes : UnsafeMutablePointer<Byte>;
        let newByteLength = _width * _height * 4
        imageBytes = UnsafeMutablePointer<Byte>.alloc(newByteLength)
        var _cnt = 0;
        for x in 0..<_width {
            for y in 0..<_height {
                var point = (x, y)
                var color = UIImage.colorAtPoint(
                    point,
                    imageWidth: _width,
                    withData: _imageData
                )
                var i: Int = ((Int(_width) * Int(y)) + Int(x)) * 4
                if(color == _tColor){
                    imageBytes[i] = Byte(255) // red
                    imageBytes[i+1] = Byte(255); // green
                    imageBytes[i+2] = Byte(255); // blue
                    imageBytes[i+3] = Byte(255); // alpha
                }else{
                    //imageBytes[i]   = Byte(color.getRGB().red) // red
                    //imageBytes[i+1] = Byte(color.getRGB().green); // green
                    //imageBytes[i+2] = Byte(color.getRGB().blue); // blue
                    //imageBytes[i+3] = Byte(255); // alpha
                    imageBytes[i] = Byte(0) // red
                    imageBytes[i+1] = Byte(0); // green
                    imageBytes[i+2] = Byte(0); // blue
                    imageBytes[i+3] = Byte(255); // alpha
                }
            }
        } 
        var provider = CGDataProviderCreateWithData(nil,imageBytes, UInt(newByteLength), nil)
        var bitsPerComponent:UInt = 8
        var bitsPerPixel:UInt = bitsPerComponent * 4
        var bytesPerRow:UInt = UInt(4) * UInt(_width)
        var colorSpaceRef = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo = CGBitmapInfo.ByteOrderDefault
        var renderingIntent = kCGRenderingIntentDefault
        // make the cgimage
        var cgImage = CGImageCreate(UInt(_width), UInt(_height), bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, nil, false, renderingIntent)
        return UIImage(CGImage: cgImage)
    }
        
    //特定した場所のピクセル色を取得する
    class func colorAtPoint(point:(x:Int,y: Int),imageWidth: Int,withData data: UnsafePointer<UInt8>) -> UIColor {
        let offset = 4 * ((imageWidth * point.y) + point.x)
        var r = CGFloat(data[offset])
        var g = CGFloat(data[offset + 1])
        var b = CGFloat(data[offset + 2])
        //return (red: r, green: g, blue: b)
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    func imageData() -> UnsafePointer<UInt8> {
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        return CFDataGetBytePtr(pixelData)
    }    
    
    func getPixelColor(pos: CGPoint) -> UIColor {        
        var pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        var data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        var pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        var r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        var g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        var b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        var a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}