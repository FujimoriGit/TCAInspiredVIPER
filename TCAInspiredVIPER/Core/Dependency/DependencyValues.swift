//
//  DependencyValues.swift
//  TCAInspiredVIPER
//  
//  Created by Daiki Fujimori on 2025/06/15
//  

protocol DependencyKey {
    
    associatedtype Value: Sendable
    static var liveValue: Value { get }
}

struct DependencyValues: Sendable {
    
    @TaskLocal public static var current = Self()
    private var storage: [ObjectIdentifier: any Sendable] = [:]
    
    subscript<K>(key: K.Type) -> K.Value where K : DependencyKey {
        
        get {
            
            guard let base = storage[ObjectIdentifier(key)],
                  let dependency = base as? K.Value else {
                
                return key.liveValue
            }
            return dependency
        }
        set {
            
            storage[ObjectIdentifier(key)] = newValue
        }
    }
}

extension DependencyValues {
    
    static func withDependency<R>(_ setDependency: (inout DependencyValues) -> Void, operation: () -> R) -> R {
        
        var currentDependencyValue = DependencyValues.current
        setDependency(&currentDependencyValue)
        
        return DependencyValues.$current.withValue(currentDependencyValue) { operation() }
    }
}

@propertyWrapper
struct Dependency<Value> {
    
    let dependencyValue: DependencyValues
    private let keyPath: KeyPath<DependencyValues, Value> & Sendable

    init(_ keyPath: KeyPath<DependencyValues, Value> & Sendable) {
        
        dependencyValue = DependencyValues.current
        self.keyPath = keyPath
    }

    var wrappedValue: Value { dependencyValue[keyPath: self.keyPath] }
}
