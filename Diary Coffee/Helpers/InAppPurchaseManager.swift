//
//  InAppPurchaseManager.swift
//  DailyCoffee
//
//  Created by Öykü Hazer Ekinci on 11.12.2024.
//

import StoreKit

class StoreManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = StoreManager()
    private var productsRequest: SKProductsRequest?
    private var availableProducts: [SKProduct] = []
    private var completion: ((Bool, Error?) -> Void)?
    
   
    func fetchProducts(productIDs: [String], completion: @escaping ([SKProduct]) -> Void) {
        productsRequest?.cancel()
        productsRequest = SKProductsRequest(productIdentifiers: Set(productIDs))
        productsRequest?.delegate = self
        productsRequest?.start()
        
        self.completion = { [weak self] success, error in
            if success {
                completion(self?.availableProducts ?? [])
            } else {
                completion([])
            }
        }
    }
    
   
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        availableProducts = response.products
        
      
        for product in response.products {
           
        }
        
        if response.invalidProductIdentifiers.count > 0 {
            
        }
        
        
        completion?(true, nil)
    }
    
   
    func purchase(product: SKProduct, completion: @escaping (Bool, Error?) -> Void) {
        guard SKPaymentQueue.canMakePayments() else {
            completion(false, NSError(domain: "StoreKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Purchases are disabled on this device."]))
            return
        }
        
        self.completion = completion
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
   
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                completion?(true, nil)
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                completion?(false, transaction.error)
            default:
                break
            }
        }
    }
    
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("Restore completed transactions finished.")
    }
}
extension SKProduct {
    var priceString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price) ?? "\(self.price)"
    }
}
