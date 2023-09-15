//
//  Router.swift
//  CryptoViper
//
//  Created by Atil Samancioglu on 11.12.2021.
//

import Foundation
import UIKit

// Class
// We setup every component here to orchestrate and route the application

// router iletişimi sağlıyor

// buradan sonra scenedelegate a gidip bazı değişiklikler yapmak gerekiyor çünkü main yok

typealias EntryPoint = AnyView & UIViewController // typealias ile entrypoint gördüğün her yer AnyView & UIViewController bu demek diyoruz. diğer türlü "var entry: EntryPoint?" burada "var entry: AnyView? & UIViewController?" böyle yapmak optionallarda hata verdiriyor. optional yapmak gerek

protocol AnyRouter { // genelde AnyRouter yazılır. bu kadar bilindik şeyleri (router view vs) değişken adı olarak yazmak iyi olmayabilir yani karışabilir sistemde
    var entry : EntryPoint? {get}
    static func startExecution() -> AnyRouter // static demenin sebebi diğer sınıflardan da ulaşabilmek
}

class CryptoRouter : AnyRouter {
    var entry: EntryPoint?
    
    static func startExecution() -> AnyRouter {
        
        let router = CryptoRouter()
        
        var view : AnyView = CryptoViewController() // ögelerimizi eşitliyoruz
        var presenter : AnyPresenter = CryptoPresenter()
        var interactor : AnyInteractor = CryptoInteractor()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        interactor.presenter = presenter
        
        router.entry = view as? EntryPoint
        
        return router // CryptoRouter bi AnyRouter olduğu için CryptoRouter ı döndürebiliriz
        
    }
    
}
