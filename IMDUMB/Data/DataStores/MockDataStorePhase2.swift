//
//  MockDataStorePhase2.swift
//  IMDUMB
//
//  Created on 4/02/26.
//  FASE 2: Datos enriquecidos con HTML y múltiples imágenes
//

import Foundation

extension MockDataStore {
    
    // MARK: - FASE 2: Películas con datos completos
    
    func getTrendingMoviesPhase2() -> [Movie] {
        return [
            Movie(
                id: 1,
                title: "The Shawshank Redemption",
                posterURL: "https://image.tmdb.org/t/p/w500/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg",
                overview: "<p><b>The Shawshank Redemption</b> es un drama carcelario de 1994.</p><p>Framed in the <i>1940s</i> for the double murder of his wife and her lover, upstanding banker <b>Andy Dufresne</b> begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden.</p><p>During his long stretch in prison, Dufresne comes to be admired by the other inmates for his <b>integrity</b> and <i>unquenchable sense of hope</i>.</p>",
                rating: 8.7,
                releaseDate: "1994-09-23",
                backdropURL: "https://image.tmdb.org/t/p/w780/kXfqcdQKsToO0OUXHcrrNCHDBzO.jpg",
                backdropURLs: [
                    "https://image.tmdb.org/t/p/w780/kXfqcdQKsToO0OUXHcrrNCHDBzO.jpg",
                    "https://image.tmdb.org/t/p/w500/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg",
                    "https://image.tmdb.org/t/p/w780/iNh3BivHyg5sQRPP1KOkzguEX0H.jpg"
                ],
                actors: [
                    Actor(id: 1, name: "Tim Robbins", profileURL: "https://image.tmdb.org/t/p/w185/hsCw1mDeM0MbPsYfRSNJgo0dJjR.jpg"),
                    Actor(id: 2, name: "Morgan Freeman", profileURL: "https://image.tmdb.org/t/p/w185/jPsLqiYGSofU4s6BjrxnefMfabb.jpg"),
                    Actor(id: 11, name: "Bob Gunton", profileURL: "https://image.tmdb.org/t/p/w185/4kfX3kDAbmWsglnT5CtWLz3AJyT.jpg"),
                    Actor(id: 12, name: "William Sadler", profileURL: "https://image.tmdb.org/t/p/w185/5SQT8ikwNyC0XmVIaXjWsSruKh.jpg"),
                    Actor(id: 13, name: "Clancy Brown", profileURL: "https://image.tmdb.org/t/p/w185/t8TJUGj4IKWYBhlF1f84GFTAFxx.jpg")
                ]
            ),
            Movie(
                id: 3,
                title: "The Dark Knight",
                posterURL: "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
                overview: "<p><b>The Dark Knight</b> es una película de superhéroes de 2008 dirigida por <i>Christopher Nolan</i>.</p><p>Batman raises the stakes in his war on crime with the help of <b>Lt. Jim Gordon</b> and District Attorney <b>Harvey Dent</b>.</p><p>With the help of allies Lt. Jim Gordon and DA Harvey Dent, Batman has been able to keep a tight lid on crime in Gotham City. But when a vile young criminal calling himself the <b>Joker</b> suddenly throws the town into chaos, the Caped Crusader begins to tread a fine line between <i>heroism and vigilantism</i>.</p>",
                rating: 9.0,
                releaseDate: "2008-07-18",
                backdropURL: "https://image.tmdb.org/t/p/w780/hkBaDkMWbLaf8B1lsWsKX7Ew3Xq.jpg",
                backdropURLs: [
                    "https://image.tmdb.org/t/p/w780/hkBaDkMWbLaf8B1lsWsKX7Ew3Xq.jpg",
                    "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
                    "https://image.tmdb.org/t/p/w780/nMKdUUepR0i5zn0y1T4CsSB5chy.jpg",
                    "https://image.tmdb.org/t/p/w780/8x7ej00PZXJ3dsOJeN4DhvaMFU9.jpg"
                ],
                actors: [
                    Actor(id: 5, name: "Christian Bale", profileURL: "https://image.tmdb.org/t/p/w185/vecCvAO94rB4xJBjNTxPZKFJl9Y.jpg"),
                    Actor(id: 6, name: "Heath Ledger", profileURL: "https://image.tmdb.org/t/p/w185/5Y9HnYYa9jF4NunY9lSgJGjSe8E.jpg"),
                    Actor(id: 14, name: "Aaron Eckhart", profileURL: "https://image.tmdb.org/t/p/w185/2BLBQwdMLHAOKQjCGMGt9uzF5T6.jpg"),
                    Actor(id: 15, name: "Michael Caine", profileURL: "https://image.tmdb.org/t/p/w185/bVZRMlpjTAO2pJK6v90buFgVbSW.jpg"),
                    Actor(id: 16, name: "Gary Oldman", profileURL: "https://image.tmdb.org/t/p/w185/2v9FVVBUrrkW2m3QOcYkuhq9A6o.jpg")
                ]
            )
        ]
    }
}
