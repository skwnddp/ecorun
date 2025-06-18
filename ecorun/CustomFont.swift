import UIKit
import ObjectiveC.runtime

extension UIFont {

    // 앱이 실행될 때 한 번만 스위즐링하도록 호출
    static func overrideDefaultFonts() {
        guard self == UIFont.self else { return }
        swizzle(originalSelector: #selector(systemFont(ofSize:)),
                swizzledSelector: #selector(mySystemFont(ofSize:)))
    }
    
    private static func swizzle(originalSelector: Selector, swizzledSelector: Selector) {
        guard
            let originalMethod = class_getClassMethod(self, originalSelector),
            let swizzledMethod = class_getClassMethod(self, swizzledSelector)
        else { return }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    // 오버라이드할 커스텀 폰트 이름
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "galmuri11Bold", size: size)!
    }
}
