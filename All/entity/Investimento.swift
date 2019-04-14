//
//  Util.swift
//  codeACity2
//
//  Created by Isaac Douglas on 13/04/19.
//  Copyright © 2019 codeACity2. All rights reserved.
//

//x = '' "m^2 do imóvel" (dado fornecido pelo usuario Dono)
//y = '' "Média do preço do m^2 de requalificação"(dados gerados por nós através da visita técnica)
//a = '' "Aluguel médio da Região" (dados estatisticos)
//p = '' "porcentagem acordada entre a gente e o dono do prédio para ser destinado no aluguel para o investidor" (Dado fornecido pelo nosso APP)
//g = '' "porcentagem acordada entre a gente e o dono do prédio para ser destinado para o investidor através da venda do imóvel" (Dado fornecido pelo nosso APP) Restrições g<100, g=%
//h = '' "Porcentagem pressuposta para rendimento do investimento" (Dado fornecido pelo nosso APP como um intervalo Ex: hmin = 4,2%, hmax = 7,9% ) restriçoes h<100%, h=%
//T0 = '' "Tempo médio de imóvel desocupado da região (Dados estatisticos)"
//z = '' "Valor médio do m^2 após revitalização" (Dados estatisticos)
//
//
//Investimento
//I =    x*y (Dado Fornecido pelo nosso APP)
//
//Tempo para retorno financeiro para invetidor modo de ROI por aluguel
//Tempo_Min = ( (1+h) *I)/(a*p) (Dado Fornecido pelo nosso APP) "para aluguel sem interrupções de locatários"
//Tempo_Medio = ( (1+h) *I)/(a*p) + T0 (Dado Fornecido pelo nosso APP) "para aluguel com interrupções de locatários"
//-
//Lucro do dono do prédio no tempo de 'Sociedade' modo de investimento de aluguel
//
//L_Min = a*(1-p)*Tempo_Min (Dado Fornecido pelo nosso APP)
//L_Medio = a*(1-p)*Tempo_Médio (Dado Fornecido pelo nosso APP)
//
//
//Lucro para investidor modo ROI por venda
//Lucro_inv = g*a*x (Dado Fornecido pelo nosso APP)
//
//Tempo para retorno financeiro para invetidor modo de ROI por venda
//
//Tempo_Medio = T1 (Dado estatistico Fornecido pelo nosso APP) " T1 = Tempo médio de imóveis vendidos na região"
//-
//Lucro do dono do prédio no tempo de 'Sociedade' modo de ROI de venda
//
//L_Medio =  (1-g)*a*x (Dado Fornecido pelo nosso APP)

import Foundation

struct Investimento {
    var x: Double
    var y: Double
    var a: Double
    var p: Double
    var g: Double
    var h: Double
    var T0: Double
    var T1: Double = 2
    
    func investimento() -> Double {
        return x*y
    }
    
    func tempoMin() -> Double {
        return ((1+h) * investimento())/(a*x*p)
    }
    
    func tempoMedio() -> Double {
        return ((1+h) * investimento())/(a*x*p) + T0
    }
    
    func lucroMin() -> Double {
        return a*x*(1-p)*tempoMin()
    }
    
    func lucroMedio() -> Double {
        return a*x*(1-p)*tempoMedio()
    }
    
    func lucroInvestidor() -> Double {
        return g*a*x
    }
    
    func lucroMedioDono() -> Double {
        return (1-g)*a*x
    }
}
