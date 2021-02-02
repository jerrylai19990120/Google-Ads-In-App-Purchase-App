//
//  PurchaseManager.swift
//  Daily Dose
//
//  Created by Jerry Lai on 2021-02-01.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import Foundation
import StoreKit

typealias  CompletionHandler = (_ success: Bool) -> ()

class PurchaseManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let instance = PurchaseManager()
    
    let IAP_REMOVE_ADS = "com.remove.ads"
    
    var productRequest: SKProductsRequest!
    var products = [SKProduct]()
    
    var transactionComplete: CompletionHandler?
    
    func fetchProducts(){
        let productIds = NSSet(object: IAP_REMOVE_ADS) as! Set<String>
        productRequest = SKProductsRequest(productIdentifiers: productIds)
        productRequest.delegate = self
        productRequest.start()
    }
    
    func purchaseRemoveAds(completion: @escaping CompletionHandler){
        if SKPaymentQueue.canMakePayments() && products.count > 0 {
            transactionComplete = completion
            let removeAdsProduct = products[0]
            let payment = SKPayment(product: removeAdsProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            completion(false)
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        if response.products.count > 0 {
            products = response.products
        }
        
    }
    
    func restorePurchases(completion: @escaping CompletionHandler){
        if SKPaymentQueue.canMakePayments() {
            transactionComplete = completion
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            completion(false)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState{
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                if transaction.payment.productIdentifier == IAP_REMOVE_ADS {
                    UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
                    transactionComplete?(true)
                }
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionComplete?(false)
                break
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                if transaction.payment.productIdentifier == IAP_REMOVE_ADS {
                    UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
                }
                transactionComplete?(true)
            default:
                transactionComplete?(false)
                break
            }
        }
    }
    

    
    
}
