//
//  Bundle+Language.swift
//  Diary Coffee
//
//  Created by Öykü Hazer Ekinci on 21.01.2025.
//

import Foundation

private var bundleKey: UInt8 = 0

extension Bundle {

    static func setLanguage(_ languageCode: String) {
        
        
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") else {
          
            objc_setAssociatedObject(Bundle.main, &bundleKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return
        }
   
        guard let languageBundle = Bundle(path: path) else {
        
            objc_setAssociatedObject(Bundle.main, &bundleKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return
        }
        
        objc_setAssociatedObject(Bundle.main, &bundleKey, languageBundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

    }

   
    static let swizzleLocalization: Void = {
        
        let originalSelector = #selector(Bundle.localizedString(forKey:value:table:))
        let swizzledSelector = #selector(Bundle.swizzled_localizedString(forKey:value:table:))
        
        guard let originalMethod = class_getInstanceMethod(Bundle.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(Bundle.self, swizzledSelector) else {
            
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
       
    }()
    
    @objc private func swizzled_localizedString(forKey key: String, value: String?, table: String?) -> String {
        if let languageBundle = objc_getAssociatedObject(Bundle.main, &bundleKey) as? Bundle {
            return languageBundle.swizzled_localizedString(forKey: key, value: value, table: table)
        }
        return self.swizzled_localizedString(forKey: key, value: value, table: table)
    }
}
