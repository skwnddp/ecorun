import UIKit
import ObjectiveC.runtime

extension UIFont {
    /// 앱 실행 시 한 번만 호출
    static func overrideDefaultFonts() {
        guard self == UIFont.self else { return }

        // 1) 일반 systemFont(ofSize:)
        swizzle(
          original: #selector(systemFont(ofSize:)),
          swizzled: #selector(mySystemFont(ofSize:))
        )

        // 2) systemFont(ofSize:weight:)
        if #available(iOS 8.2, *) {
            swizzle(
              original: #selector(systemFont(ofSize:weight:)),
              swizzled: #selector(mySystemFont(ofSize:weight:))
            )
        }

        // 3) boldSystemFont(ofSize:)
        swizzle(
          original: #selector(boldSystemFont(ofSize:)),
          swizzled: #selector(myBoldSystemFont(ofSize:))
        )

        // 4) italicSystemFont(ofSize:)
        swizzle(
          original: #selector(italicSystemFont(ofSize:)),
          swizzled: #selector(myItalicSystemFont(ofSize:))
        )

        // 5) preferredFont(forTextStyle:) – Storyboard, Dynamic Type 대응
        if #available(iOS 9.0, *) {
            swizzle(
              original: #selector(UIFont.preferredFont(forTextStyle:)),
              swizzled: #selector(myPreferredFont(forTextStyle:))
            )
        }
    }

    private static func swizzle(original: Selector, swizzled: Selector) {
        guard
          let originalMethod = class_getClassMethod(self, original),
          let swizzledMethod = class_getClassMethod(self, swizzled)
        else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    // MARK: – Swizzled implementations
    
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Galmuri11", size: size)!
    }

    @objc class func mySystemFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        // weight 무시하고 동일하게
        return UIFont(name: "Galmuri11", size: size)!
    }

    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Galmuri11", size: size)!
    }

    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Galmuri11", size: size)!
    }

    @objc class func myPreferredFont(forTextStyle style: UIFont.TextStyle) -> UIFont {
        // 이 호출은 swizzled 되어 원래 preferredFont가 실행됨
        let original = myPreferredFont(forTextStyle: style)
        return UIFont(name: "Galmuri11", size: original.pointSize)!
    }
}
