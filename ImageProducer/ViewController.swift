//
//  ViewController.swift
//  ImageProducer
//
//  Created by Acer on 2/25/15.
//  Copyright (c) 2015 Acer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var from: UITextField!
    @IBOutlet weak var to: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickCreateButton(sender: AnyObject) {
        println("click create button");
        let fromNumber = from.text.toInt();
        let endNunber = to.text.toInt();
        
        for var index = fromNumber; index <= endNunber; ++index {
            let image = drawCustomImage(String(index))
            imageView.image = image;
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
    }

    func drawCustomImage(number: String) -> UIImage {
        // Setup our context
        let size = CGSize(width: 100.0, height: 100.0)
        let bounds = CGRect(origin: CGPoint.zeroPoint, size:size)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor);
        
        // Setup complete, do drawing here
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetLineWidth(context, 2.0)
        
//        CGContextStrokeRect(context, bounds)
//        
//        CGContextBeginPath(context)
//        CGContextMoveToPoint(context, CGRectGetMinX(bounds), CGRectGetMinY(bounds))
//        CGContextAddLineToPoint(context, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))
//        CGContextMoveToPoint(context, CGRectGetMaxX(bounds), CGRectGetMinY(bounds))
//        CGContextAddLineToPoint(context, CGRectGetMinX(bounds), CGRectGetMaxY(bounds))
//        CGContextStrokePath(context)
        
        var textAttributes: [String: AnyObject] = [
            NSForegroundColorAttributeName : UIColor(white: 0.0, alpha: 1.0).CGColor,
            NSFontAttributeName : UIFont.systemFontOfSize(32)
        ]
        
        drawText(context, text: number, attributes: textAttributes, x: 20, y: 20)
        
        // Drawing complete, retrieve the finished image and cleanup
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func drawText(context: CGContextRef, text: NSString, attributes: [String: AnyObject], x: CGFloat, y: CGFloat) -> CGSize {
        let font = attributes[NSFontAttributeName] as UIFont
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        
        let textSize = text.sizeWithAttributes(attributes)
        
        // y: Add font.descender (its a negative value) to align the text at the baseline
        let textPath    = CGPathCreateWithRect(CGRect(x: x, y: y + font.descender, width: ceil(textSize.width), height: ceil(textSize.height)), nil)
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)
        let frame       = CTFramesetterCreateFrame(frameSetter, CFRange(location: 0, length: attributedString.length), textPath, nil)
        
        CTFrameDraw(frame, context)
        
        return textSize
    }
}

