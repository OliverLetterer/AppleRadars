import UIKit

class ViewController: UIViewController {
    let label: UILabel = UILabel(frame: .zero)
    let textLayer: CATextLayer = CATextLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.numberOfLines = 0
        label.textAlignment = .left
        label.backgroundColor = .orange
        label.lineBreakMode = .byWordWrapping
        textLayer.isWrapped = true
        textLayer.alignmentMode = .right
        textLayer.backgroundColor = UIColor.orange.cgColor
        textLayer.truncationMode = .end
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.font = UIFont.preferredFont(forTextStyle: .body) as CTFont
        textLayer.fontSize = UIFont.preferredFont(forTextStyle: .body).pointSize
        
        let string = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam"
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineSpacing = 0.0
        paragraphStyle.paragraphSpacing = 0.0
        paragraphStyle.paragraphSpacingBefore = 0.0
        
        label.attributedText = NSAttributedString(string: string, attributes: [
            .font: UIFont.preferredFont(forTextStyle: .body),
            .foregroundColor: UIColor.black,
            .backgroundColor: UIColor.clear,
            .paragraphStyle: paragraphStyle,
        ])
        
        var zeroSpacing: CGFloat = 0.0
        var textAlignment: CTTextAlignment = .right
        
        var settings: [CTParagraphStyleSetting] = withUnsafeMutableBytes(of: &zeroSpacing) { zeroSpacing in
            return withUnsafeMutableBytes(of: &textAlignment) { textAlignment in
                return [
                    CTParagraphStyleSetting(spec: .paragraphSpacing, valueSize: MemoryLayout<CGFloat>.size, value: zeroSpacing.baseAddress!),
                    CTParagraphStyleSetting(spec: .minimumLineSpacing, valueSize: MemoryLayout<CGFloat>.size, value: zeroSpacing.baseAddress!),
                    CTParagraphStyleSetting(spec: .maximumLineSpacing, valueSize: MemoryLayout<CGFloat>.size, value: zeroSpacing.baseAddress!),
                    CTParagraphStyleSetting(spec: .lineSpacingAdjustment, valueSize: MemoryLayout<CGFloat>.size, value: zeroSpacing.baseAddress!),
                    CTParagraphStyleSetting(spec: .paragraphSpacingBefore, valueSize: MemoryLayout<CGFloat>.size, value: zeroSpacing.baseAddress!),
                    CTParagraphStyleSetting(spec: .alignment, valueSize: MemoryLayout<CTTextAlignment>.size, value: textAlignment.baseAddress!),
                ]
            }
        }
        
        let attributes: [CFString: Any] = [
            kCTFontAttributeName: UIFont.preferredFont(forTextStyle: .body) as CTFont,
            kCTForegroundColorAttributeName: UIColor.black.cgColor,
            kCTBackgroundColorAttributeName: UIColor.clear.cgColor,
            kCTParagraphStyleAttributeName: CTParagraphStyleCreate(&settings, settings.count),
        ]
        
        textLayer.string = CFAttributedStringCreate(nil, string as CFString, attributes as CFDictionary)
        
        view.addSubview(label)
        view.layer.addSublayer(textLayer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textLayer.frame = CGRect(x: view.bounds.midX - 4.0 - view.bounds.width * 3.0 / 8.0, y: view.bounds.midY - 50.0, width: view.bounds.width * 3.0 / 8.0, height: 100.0)
        
        let labelSize = label.sizeThatFits(CGSize(width: view.bounds.width * 3.0 / 8.0, height: .infinity))
        label.frame = CGRect(x: view.bounds.midX + 4.0, y: textLayer.frame.minY, width: labelSize.width, height: labelSize.height)
    }
}
