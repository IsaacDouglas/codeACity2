//
//  Util.swift
//  codeACity2
//
//  Created by Isaac Douglas on 13/04/19.
//  Copyright © 2019 codeACity2. All rights reserved.
//

import Foundation

//Algoritmo para valor final do investimento/retorno
struct Investimento {
    var x: Double //x = '' "m^2 do imóvel" (dado fornecido pelo usuario Dono)
    var y: Double //y = '' "Média do preço do m^2 de requalificação"(dados estatisticos)
    var a: Double //a = '' "Aluguel médio da Região" (dados estatisticos)
    var p: Double //p = '' "porcentagem acordada para lucro mensal do investidor"
    var h: Double //h = '' "Porcentagem pressuposta para rendimento do investimento" (Dado fornecido pelo usuario Investidor)
    var T0: Double //T0 = '' "Tempo médio de imóvel desocupado da região (Dados estatisticos)"
    
    
    //Investimento
    
    //I =    x*y (inerente ao imóvel)
    func investimento() -> Double {
        return x*y
    }
    
    //Tempo_Min = (h*I)/(a*p)  "para aluguel sem interrupções de locatários"
    func tempoMinimo() -> Double {
        return (h*investimento())/(a*p)
    }
    
    //Tempo_Medio = (h*I)/(a*p) + T0  "para aluguel com interrupções de locatários"
    func tempoMedio() -> Double {
        return (h*investimento())/(a*p) + T0
    }
    
    
    //Lucro do dono do prédio no tempo de 'Sociedade'
    
    //L_Min = (1-h)*Tempo_Min
    func lucroMinimo() -> Double {
        return (1-h)*tempoMinimo()
    }
    
    //L_Medio = (1-h)*Tempo_Médio
    func lucroMedio() -> Double {
        return (1-h)*tempoMedio()
    }
}
