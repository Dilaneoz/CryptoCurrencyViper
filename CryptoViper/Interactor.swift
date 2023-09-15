//
//  Interactor.swift
//  CryptoViper
//
//  Created by Atil Samancioglu on 11.12.2021.
//

import Foundation


// Class
// Protocol
// Talks To -> Presenter
// No completion handlers in interactor. It will inform the presenter once it happens.

// interactor un tek yaptığı verileri download etmek ve presenter a haber vermek
// uygulama açıldığı gibi indirmeye başlayacak
// networking service entityle konuştu, service aldı interactor içinde parse etti ve presenter a haber verdi. presenter da view a haber vericek

protocol AnyInteractor {
    
    var presenter : AnyPresenter? {get set}
    
    func downloadCrypto()
}

class CryptoInteractor : AnyInteractor {
    var presenter: AnyPresenter?
    
    func downloadCrypto() {
        
        guard let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/IA32-CryptoComposeData/main/cryptolist.json")
        else {
            return // bi sıkıntı olursa bişi yapma diyoruz istersek hata verebiliriz
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in // [weak self] bu zayıf referans anlamına gelir. uygulamada sayfa değiştiğinde garbage collector un işini yapmasına engel olabiliyo o yuzden hafızada kalabiliyo. [weak self] yazarsak bu tarz verilerde, bu verinin gitmesini ve tekrar karşımıza çıkmamasını sağlayabiliriz
            guard let data = data, error == nil else {
                self?.presenter?.interactorDidDownloadCrypto(result: .failure(NetworkError.networkFailed))
                return
            }
            
            do {
                let cryptos = try JSONDecoder().decode([Crypto].self,from: data)
                self?.presenter?.interactorDidDownloadCrypto(result: .success(cryptos)) // presenter a criptoları yolluyoruz
            } catch {
                self?.presenter?.interactorDidDownloadCrypto(result: .failure(NetworkError.parsingFailed)) // data indi ama decode edemedik büyük ihtimalle kodlar yanlış
            }
        }
        task.resume()
        
    }
    
    
}
