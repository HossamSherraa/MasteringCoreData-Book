//
//  Quakes.swift
//  MasteringCoreData-Book
//
//  Created by Hossam on 22/02/2021.
//

//

import Foundation
import Combine
import CoreData

/*
 1- load all data from server
 2- save all data to coredata
 3- create request controller to present the saved data
 */

struct EarthQyake: Codable  {
    let dmin : Double?
    let place : String?
}
class EarthQuakesManager {
    
    
    var passthroughSubject = PassthroughSubject<Void, Never>()
    lazy var container  : NSPersistentContainer = {
        let container = NSPersistentContainer.init(name: "EarthQuakes")
        container.loadPersistentStores { (desc, error) in
//            try! container.persistentStoreCoordinator.destroyPersistentStore(at: desc.url!, ofType: NSSQLiteStoreType, options: [:])
            if let error = error {
                fatalError()
            }
        }
    
        return container
        
    }()
    
    let earthquakesFeed = URL(string:"https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson")!
   
   
    
    func loadAllDataFromServer()->AnyPublisher<[EarthQyake], Error>{
        
       return URLSession.DataTaskPublisher.init(request: URLRequest.init(url: earthquakesFeed), session: .shared)
            .map(\.data)
            .tryCompactMap({ data -> [[String:Any]]? in
                
               let data =  try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                let features = data?["features"] as? [[String:Any]]
                return features
            })

        .flatMap({ value  in
            value.publisher
        })
    
        .tryCompactMap({ values in
            let values = values["properties"] as Any
            let data = try JSONSerialization.data(withJSONObject: values , options: [])
            return data
        })
        .decode(type: EarthQyake.self, decoder: JSONDecoder.init())
        .collect()
        .eraseToAnyPublisher()
        
        
      
        
            
        
        
    
            
    
        
    }
    
    
    func storeAllDataToCoreData()->AnyCancellable{
        loadAllDataFromServer()
            .flatMap(\.publisher)
            .map(\.dmin, \.place)
            .compactMap({ (dmin , place)->[String:Any]? in
                if let dmin = dmin , let place = place {
                    return ["dmin" : dmin ,
                            "place": place]
                }
                return nil
            })
            .collect()
            .compactMap({ values  -> NSBatchInsertRequest? in
                let batchInsert = NSBatchInsertRequest.init(entityName: "EarthQuake", objects: values)
                return batchInsert
            })
            .compactMap({ [weak self] request in
                let backgroundContext = self?.container.newBackgroundContext()
                backgroundContext?.performAndWait {
                    try! backgroundContext?.execute(request)
                }
                return nil
            })
            .sink { completion in
                self.passthroughSubject.send()
            } receiveValue: { earthQuakes in
                print(earthQuakes)
            }

        
        
            
    }
}
