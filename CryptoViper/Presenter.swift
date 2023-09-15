//
//  Presenter.swift
//  CryptoViper
//
//  Created by Atil Samancioglu on 11.12.2021.
//

import Foundation

// Class
// Protocol
// Talks To -> Interactor, Router, View
// Interactor needs to tell what kind of interaction happened so presenter needs to update the view

// presenter interactor den aldığı verileri view a aktarıcak

enum NetworkError : Error { // hata mesajlarını enum haline getiriyoruz. bunu yapmak şart değil ama şirketler yapabiliyor. farklı case ler oluşturursak debug etmemiz daha kolay olur ve aynı zamanda belki kullanıcıya da bi şey göstermek isteriz
    case networkFailed // data hiç inmedi
    case parsingFailed // data indi ama yanlış parse ediyorum yani entity yanlış olabilir vs
}

protocol AnyPresenter {
    var router : AnyRouter? { get set } // sadece okunacaksa {get} yazarız, değeri de değiştirilecekse {get set} yazarız
    var interactor : AnyInteractor? {get set}
    var view : AnyView? {get set}
    
    func interactorDidDownloadCrypto(result: Result<[Crypto], Error>) // interactor da bi şeyi download ettiğimizde, presenter a, git view a söyle kendini güncellesin çünkü yeni veri geldi demeliyiz. bu fonksiyonun içinde bize result verilecek içinde success ve error olan

}

class CryptoPresenter : AnyPresenter {
    
    var router: AnyRouter?
    
    var interactor: AnyInteractor? {
        didSet { // didSet buradaki değer atanınca yapılacak işlemler
            interactor?.downloadCrypto() // didSet olduğunda interactor?.downloadCrypto() diyebiliriz. atama işlemi yapıldığında interactor ve presenter birbirine bağlandığında otomatik olarak bu atanacaktır
        }
    }
    
    var view: AnyView?
    
    /*
    init(){
        interactor?.downloadCrypto()
    }
     */
    
    func interactorDidDownloadCrypto(result: Result<[Crypto], Error>) {
        switch result { // result değişkenini switch ediyoruz
            case .success(let cryptos): // durum başarılıysa cripto verilecek
                view?.update(with: cryptos) // view a kendini güncelle diyoruz
            case .failure(_):
                view?.update(with: "Try again later")
        }
    }
    
}
