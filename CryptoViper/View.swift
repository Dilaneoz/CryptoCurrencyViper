//
//  View.swift
//  CryptoViper
//
//  Created by Atil Samancioglu on 11.12.2021.
//

import Foundation
import UIKit

// view görünümdür. kullanıcının gördüğü arayüz. viewcontroller bunun içinde olucak. view ve viewcontroller ayrı sınıflardan oluşup paslaşabilirler
// router bu yapının birbiri içinde gezinmesi için yapılan bir sınıf. bütün öğeleri barındırır ve onları koordine eder. sadece ordan oraya navige etmke anlamına gelmiyor. uygulama ilk açıldığında hangi view gözükeceğini ve uygulama ilk açıldığında nereye gideceğini burada söyleriz. entry point belirtilir
// presenter gösterici anlamına gelir ve interactorden aldığı verileri hem routerdan aldığı bilgiler/yönlendirmelerle görünüm tarafına iletme hem de bütün bu olayları koordine etme görevini üstlenir
// interactor business logic imiz, yapılacak işleri yapan sınıf. hem kullanıcıdan bi etkileşim var onu da handle edebildiğimiz hem de networking servisle ve coredatayla konuştuğumuz yer. yani mvvm deki viewmodel ın eşleniği diyebiliriz ama tam olarak değil. githubtan verileri buradan indiricez
// entity ise modelimiz yani structımız classımız artık neyse. içinde struct kullanırız. codable da yapılabilir decodable da. codable hem encodable hem decodable anlamına gelir. internetten çektiğimiz verileri işlerken decodable yapılır
// her oluşturduğumuz ögede kimin kimle konuşucağını bilmek iyidir. view, router ve interactor presenter la konuşur. entitynin presenterla konuşmasına gerek olmayabilir interactorle işini halledebilir
// burada protocol oriented bi şekilde ilerlemeye çalışıcaz. bu hem testler için avantaj hem bi fonksiyonu yazıp unutmadan bu protocolu uyguladığımız her yerde kullanmak zorunda kalıyoruz bu bi avantaj. kendi yapımızı daha organik bir şekilde doğru düzgün ayrıabilmemiz için bi avantaj
// viper kullanırken maini silmek sistemde bazı sıkıntılara yola açabiliyor. o yüzden infoplistten application session role den storyboard name i silmek gerekiyor. sonra proje ayarlarında general a gelip main interface ten main i silip enter a basmak yeterli

protocol AnyView {
    var presenter : AnyPresenter? {get set}
    
    func update(with cryptos: [Crypto]) // CryptoViewController içinde update edicez
    func update(with error: String)
}


class DetailViewController : UIViewController { // hoca bunu örnek olsun diye yapıyor. normalde her ekran ayrı ayrı modullerde yazılır ve her modülün ayrı bi viper ının olması gerekir ama küçük bi uygulama yapıyorsak burada da ekranı oluşturabiliriz
    
    var presenter: AnyPresenter?
    
    var currency : String = ""
    var price : String = ""
    
    private let currencyLabel : UILabel = {
       let label = UILabel()
        label.isHidden = true
        label.text = "Currency Label"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let priceLabel : UILabel = {
       let label = UILabel()
        label.isHidden = true
        label.text = "Price Label"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        view.addSubview(currencyLabel)
        view.addSubview(priceLabel)
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        currencyLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 - 25, width: 200, height: 50)
        priceLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 + 50, width: 200, height: 50)
        currencyLabel.text = currency
        priceLabel.text = price
        currencyLabel.isHidden = false
        priceLabel.isHidden = false
    }
    
    

}

class CryptoViewController : UIViewController, AnyView, UITableViewDelegate, UITableViewDataSource  {
    var presenter : AnyPresenter?
    
    var cryptos : [Crypto] = []
    
    private let tableView : UITableView = { // bunu "private let tableView = UITableView() olarak yazıp altına tableView. diyerek de ekleyebilirdik özellikleri ama böyle yapmak daha kolay
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell") // hangi celle çalışcağımızı ve adını söylüyoruz
        table.isHidden = true // veri indirildiğinde tableview ı gizli olmaktan çıkarıcaz
        return table
    }()
    
    private let messageLabel : UILabel = {
       let label = UILabel()
        label.isHidden = false // başta label gösterilcek yüklenme olursa label ı gizleyip tableview ı göstericez
        label.text = "Downloading ..."
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        view.addSubview(tableView) // oluşturduğumuz görünümleri bu şekilde ekliyoruz
        view.addSubview(messageLabel)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() { // burada boyutları veririz
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds // tableview ekran kadar olsun
        messageLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 - 25, width: 200, height: 50) // tam ortada
    }
    
    
    func update(with cryptos: [Crypto]){
        DispatchQueue.main.async {
            self.cryptos = cryptos
            self.messageLabel.isHidden = true
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
    }
    
    func update(with error: String) {
        DispatchQueue.main.async {
            self.cryptos = []
            self.tableView.isHidden = true
            self.messageLabel.text = error
            self.messageLabel.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration() // defaultContentConfiguration bu üst tarafta ve alt tarafta ne gösterilsin bizden bunu ister. üstte kriptonun adı altta değeri olucak
        content.text = cryptos[indexPath.row].currency
        content.secondaryText = cryptos[indexPath.row].price
        cell.contentConfiguration = content
        cell.backgroundColor = .yellow
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(cryptos[indexPath.row].currency)
        let nextViewController = DetailViewController()
        nextViewController.price = cryptos[indexPath.row].price
        nextViewController.currency = cryptos[indexPath.row].currency
        self.present(nextViewController, animated: true, completion: nil)
    }
    
}
