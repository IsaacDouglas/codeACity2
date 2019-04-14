//
//  DetailMapViewController.swift
//  codeACity2
//
//  Created by Isaac Douglas on 14/04/19.
//  Copyright © 2019 codeACity2. All rights reserved.
//

import UIKit

class DetailMapViewController: UIViewController {

    var item: ItemMap!
    var predio: Predio!
    @IBOutlet weak var lbFicha: UILabel!
    @IBOutlet weak var lbAtratividade: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var streetView: GMSPanoramaView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var infoSlider: UILabel!
    @IBOutlet weak var lbSlideValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        streetView.isHidden = true
        let back = UIBarButtonItem(title: "Voltar", style: .plain, target: self, action: #selector(self.backAction))
        self.navigationItem.leftBarButtonItem = back
        
        streetView.moveNearCoordinate(predio.location)
        lbFicha.text = predio.info
        lbName.text = predio.name
        imgImage.image = predio.image
        imgImage.clipsToBounds = true
        calcInvestimento()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let urlNew = getLink(location: predio.location, radius: 1000, type: .restaurant)
        URLSession.shared.get(urlNew, onErron: { error in
            print(error.localizedDescription)
        }, onSucess: { (nearby: GoogleNearby) in
            if nearby.status == "OK" {
                self.lbAtratividade.text = nearby.results.map({ $0.name }).joined(separator: "\n")
            }
        })
    }
    
    private func getLink(location: CLLocationCoordinate2D, radius: Int, type: PlaceType) -> String {
        let key = Session.settings!.apiGoogle
        return "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location.latitude),\(location.longitude)&radius=\(radius)&key=\(key)"
    }
    
    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func slide(_ sender: UISlider) {
        calcInvestimento()
    }
    
    func calcInvestimento() {
        lbSlideValue.text = "Retorno de \(Double(slider.value).formatter(qtd: 3))%"
        
        let i = Investimeto2.init(x: 84, y: 600, a: 31.25, p: 80/100, g: 40/100, h: Double(slider.value/100), T0: 4, T1: 2)
        
        let tempoMinimo = "Tempo minimo: \(i.tempoMin().formatter(qtd: 1)) meses"
        let tempoMedio = "Tempo médio: \(i.tempoMedio().formatter(qtd: 1)) meses"
        
        infoSlider.text = "\(tempoMinimo)\n\(tempoMedio)"
        lbFicha.text = """
        Tamanho dos apartamentos: \(i.x)m²
        Média de preço da requalificação: \(i.y.currencyFormatting())/m²
        Aluguel médio da região: \(i.a.currencyFormatting())/m²
        Investimento: \(i.investimento().currencyFormatting())
        """
    }
    
}
