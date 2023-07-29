//
//  CollisionHash
//  
//  All rights reserved Sebastian Ritter
//

import Foundation
import KnightLife

/// CollisionHash ermöglicht die Nutzung beliebiger Hashfunktionen, wenn der Hash aus zwei Byte ein Byte erzeugt (und es maximal 256 Kollisionen gibt, aber sonst wäre es eine schlechte Hashfunktion)
public protocol CollisionHashable {
    /// Erzeugt aus den beiden Bytes ein Hash mit der Länge 1 Byte
    func hash (input : (UInt8, UInt8)) -> UInt8;
}

/// Der CollisionHash ist eine Hashfunktion, welche auf dem Konzept der Hashkollsionen beruht. Optimale Hashfunktionen erzeugen für einen Input der die selbe Länge wie der sich ergebene Hash hat genau einen gültigen Hash. Wenn der Hash ein Byte kürzer ist, werden bei optimalen Hashfunktionen genau 256 Kollisionen auftreten. Diese Kollisionen können in eine Reihenfolge gebracht werden, indem die Eingabebytes aufsteigen bewertet werden - x00 ist also kleiner als xFF. Statt das Byte zu speichern kann damit auch die Position gespeichert werden, welche die Hashkollision auslöst. Da dies genau 256 bei der hiesigen Implementation ist, wird dies also auch in genau einem Byte gespeichert werden.
public struct CollisionHash {
    
    /// Die Hashfunktion die intern verwendet wird, um den Hash zu ermitteln
    private let hasher : CollisionHashable;
    
    /// Erzeugt eine neue Instanz mit der übergebenen Implementation einer Hashfunktion als Parameter zur weiteren Verwendung.
    public init (newHasher : CollisionHashable) {
        self.hasher = newHasher
    }
 
    /// Die Hashfunktion erzeugt aus dem beiden übergebenen Bytes zunächst den Hash und sichert diesen im neuen ersten Byte und prüft anschließend die Position der Hashkollision, die im zweiten Byte gespeichert wird.
    public func hash (input : (first : UInt8, second : UInt8)) -> (hash : UInt8, hashOffset : UInt8) {
        var result : (hash : UInt8, hashOffset : UInt8) = (self.hasher.hash(input: input),0)
        
        var collisionOffset = -1
        // FIXME: other optimize implementation on other project existing without function exit in method
        for first in 0 ... 255 as ClosedRange<UInt8> {
            for second in 0 ... 255 as ClosedRange<UInt8> {
                let actuallyHash = hasher.hash(input: (first,second))
                if result.hash == actuallyHash {
                    collisionOffset += 1
                    if (input.first == first && input.second == second) {
                        result.hashOffset = UInt8(collisionOffset)
                        return result
                    }
                }
            }
        }
        
        return result
    }
}


// der vorhandene PearsonHash wird kompatibel zum Protokoll
extension PearsonHash : CollisionHashable {
    public func hash(input: (UInt8, UInt8)) -> UInt8 {
        PearsonHash.hash(input: [input.0,input.1])
    }
    
    
}
