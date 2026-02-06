//
//  MockDataStore.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - MockDataStore
/// DataStore con datos hardcodeados para desarrollo y testing
/// SOLID: OCP - Implementa el protocol DataStore sin modificar el código existente
class MockDataStore: DataStore {
    
    // MARK: - Fetch Categories
    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        // Simular delay de red
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let categories = self.createMockCategories()
            completion(.success(categories))
        }
    }
    
    // MARK: - Fetch Movie Detail
    func fetchMovieDetail(id: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Buscar la película en todas las categorías
            let allMovies = self.createMockCategories().flatMap { $0.movies }
            if let movie = allMovies.first(where: { $0.id == id }) {
                completion(.success(movie))
            } else {
                let error = NSError(domain: "MockDataStore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Película no encontrada"])
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Fetch App Config
    func fetchAppConfig(completion: @escaping (Result<AppConfig, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let config = AppConfig(
                welcomeMessage: "Bienvenido a IMDUMB - Development",
                apiBaseURL: "http://localhost:3000",
                enableFeatureX: true
            )
            completion(.success(config))
        }
    }
    
    // MARK: - Private Helper Methods
    
    private func createMockCategories() -> [Category] {
        return [
            Category(id: 1, name: "En Tendencia", movies: getTrendingMovies()),
            Category(id: 2, name: "Acción", movies: getActionMovies()),
            Category(id: 3, name: "Comedia", movies: getComedyMovies()),
            Category(id: 4, name: "Drama", movies: getDramaMovies())
        ]
    }
    
    private func getTrendingMovies() -> [Movie] {
        return [
            Movie(
                id: 1,
                title: "The Shawshank Redemption",
                posterURL: "https://image.tmdb.org/t/p/w500/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg",
                overview: "Framed in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison.",
                rating: 8.7,
                releaseDate: "1994-09-23",
                backdropURL: "https://image.tmdb.org/t/p/w780/kXfqcdQKsToO0OUXHcrrNCHDBzO.jpg",
                actors: [
                    Actor(id: 1, name: "Tim Robbins", profileURL: "https://image.tmdb.org/t/p/w185/hsCw1mDeM0MbPsYfRSNJgo0dJjR.jpg"),
                    Actor(id: 2, name: "Morgan Freeman", profileURL: "https://image.tmdb.org/t/p/w185/jPsLqiYGSofU4s6BjrxnefMfabb.jpg")
                ]
            ),
            Movie(
                id: 2,
                title: "The Godfather",
                posterURL: "https://image.tmdb.org/t/p/w500/3bhkrj58Vtu7enYsRolD1fZdja1.jpg",
                overview: "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family.",
                rating: 8.7,
                releaseDate: "1972-03-14",
                backdropURL: "https://image.tmdb.org/t/p/w780/tmU7GeKVybMWFButWEGl2M4GeiP.jpg",
                actors: [
                    Actor(id: 3, name: "Marlon Brando", profileURL: "https://image.tmdb.org/t/p/w185/fuTEPMsBtV1zE98ujPONbKiYDc2.jpg"),
                    Actor(id: 4, name: "Al Pacino", profileURL: "https://image.tmdb.org/t/p/w185/2dGBb1fOcNdZjtQToVPFxXjm4ke.jpg")
                ]
            ),
            Movie(
                id: 3,
                title: "The Dark Knight",
                posterURL: "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
                overview: "Batman raises the stakes in his war on crime with the help of Lt. Jim Gordon and District Attorney Harvey Dent.",
                rating: 9.0,
                releaseDate: "2008-07-18",
                backdropURL: "https://image.tmdb.org/t/p/w780/hkBaDkMWbLaf8B1lsWsKX7Ew3Xq.jpg",
                actors: [
                    Actor(id: 5, name: "Christian Bale", profileURL: "https://image.tmdb.org/t/p/w185/vecCvAO94rB4xJBjNTxPZKFJl9Y.jpg"),
                    Actor(id: 6, name: "Heath Ledger", profileURL: "https://image.tmdb.org/t/p/w185/5Y9HnYYa9jF4NunY9lSgJGjSe8E.jpg")
                ]
            ),
            Movie(
                id: 4,
                title: "Pulp Fiction",
                posterURL: "https://image.tmdb.org/t/p/w500/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg",
                overview: "A burger-loving hit man, his philosophical partner, and a drug-addled gangster's moll.",
                rating: 8.9,
                releaseDate: "1994-09-10",
                backdropURL: "https://image.tmdb.org/t/p/w780/suaEOtk1N1sgg2MTM7oZd2cfVp3.jpg",
                actors: [
                    Actor(id: 7, name: "John Travolta", profileURL: "https://image.tmdb.org/t/p/w185/9GVufE87MMIrSn0CbJFLudkALdL.jpg"),
                    Actor(id: 8, name: "Samuel L. Jackson", profileURL: "https://image.tmdb.org/t/p/w185/AiAYAqwpM5xmiFrAIeQvUXDCVvo.jpg")
                ]
            ),
            Movie(
                id: 5,
                title: "Forrest Gump",
                posterURL: "https://image.tmdb.org/t/p/w500/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg",
                overview: "The presidencies of Kennedy and Johnson unfold through the perspective of an Alabama man.",
                rating: 8.8,
                releaseDate: "1994-07-06",
                backdropURL: "https://image.tmdb.org/t/p/w780/7c9UVPPiTPltouxRVY6N9uUaJsz.jpg",
                actors: [
                    Actor(id: 9, name: "Tom Hanks", profileURL: "https://image.tmdb.org/t/p/w185/eKF1sGJRrZJbfBG1KirPt1cfNd3.jpg"),
                    Actor(id: 10, name: "Robin Wright", profileURL: "https://image.tmdb.org/t/p/w185/4LMvPJY2u6EzjrMmvr0hU9y9OBK.jpg")
                ]
            )
        ]
    }
    
    private func getActionMovies() -> [Movie] {
        return [
            Movie(
                id: 11,
                title: "Mad Max: Fury Road",
                posterURL: "https://image.tmdb.org/t/p/w500/hA2ple9q4qnwxp3hKVNhroipsir.jpg",
                overview: "An apocalyptic story set in the furthest reaches of our planet.",
                rating: 8.1,
                releaseDate: "2015-05-15",
                actors: [
                    Actor(id: 11, name: "Tom Hardy"),
                    Actor(id: 12, name: "Charlize Theron")
                ]
            ),
            Movie(
                id: 12,
                title: "Die Hard",
                posterURL: "https://image.tmdb.org/t/p/w500/yFihWxQcmqcaBR31QM6Y8gT6aYV.jpg",
                overview: "An NYPD officer tries to save his wife and several others taken hostage.",
                rating: 8.2,
                releaseDate: "1988-07-15",
                actors: [
                    Actor(id: 13, name: "Bruce Willis"),
                    Actor(id: 14, name: "Alan Rickman")
                ]
            ),
            Movie(
                id: 13,
                title: "John Wick",
                posterURL: "https://image.tmdb.org/t/p/w500/fZPSd91yGE9fCcCe6OoQr6E3Bev.jpg",
                overview: "An ex-hit-man comes out of retirement to track down the gangsters.",
                rating: 7.4,
                releaseDate: "2014-10-24",
                actors: [
                    Actor(id: 15, name: "Keanu Reeves"),
                    Actor(id: 16, name: "Michael Nyqvist")
                ]
            ),
            Movie(
                id: 14,
                title: "The Matrix",
                posterURL: "https://image.tmdb.org/t/p/w500/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg",
                overview: "A computer hacker learns from mysterious rebels about the true nature of his reality.",
                rating: 8.7,
                releaseDate: "1999-03-31",
                actors: [
                    Actor(id: 15, name: "Keanu Reeves"),
                    Actor(id: 17, name: "Laurence Fishburne")
                ]
            ),
            Movie(
                id: 15,
                title: "Gladiator",
                posterURL: "https://image.tmdb.org/t/p/w500/ty8TGRuvJLPUmAR1H1nRIsgwvim.jpg",
                overview: "A former Roman General sets out to exact vengeance.",
                rating: 8.5,
                releaseDate: "2000-05-05",
                actors: [
                    Actor(id: 18, name: "Russell Crowe"),
                    Actor(id: 19, name: "Joaquin Phoenix")
                ]
            )
        ]
    }
    
    private func getComedyMovies() -> [Movie] {
        return [
            Movie(
                id: 21,
                title: "The Grand Budapest Hotel",
                posterURL: "https://image.tmdb.org/t/p/w500/eWdyYQreja6JGCzqHWXpWHDrrPo.jpg",
                overview: "The adventures of Gustave H, a legendary concierge.",
                rating: 8.1,
                releaseDate: "2014-03-07",
                actors: [
                    Actor(id: 20, name: "Ralph Fiennes"),
                    Actor(id: 21, name: "Tony Revolori")
                ]
            ),
            Movie(
                id: 22,
                title: "Superbad",
                posterURL: "https://image.tmdb.org/t/p/w500/ek8e8txUyUwd2BNqj6lFEerJfbq.jpg",
                overview: "Two co-dependent high school seniors are forced to deal with separation anxiety.",
                rating: 7.6,
                releaseDate: "2007-08-17",
                actors: [
                    Actor(id: 22, name: "Jonah Hill"),
                    Actor(id: 23, name: "Michael Cera")
                ]
            ),
            Movie(
                id: 23,
                title: "The Hangover",
                posterURL: "https://image.tmdb.org/t/p/w500/jbKP7JKmQ8e6FnAp6l8eStdgFkg.jpg",
                overview: "Three buddies wake up from a bachelor party in Las Vegas.",
                rating: 7.7,
                releaseDate: "2009-06-05",
                actors: [
                    Actor(id: 24, name: "Bradley Cooper"),
                    Actor(id: 25, name: "Zach Galifianakis")
                ]
            ),
            Movie(
                id: 24,
                title: "Groundhog Day",
                posterURL: "https://image.tmdb.org/t/p/w500/gCgt1WARPZaXnq523ySQEUKinCs.jpg",
                overview: "A weatherman finds himself living the same day over and over again.",
                rating: 8.0,
                releaseDate: "1993-02-12",
                actors: [
                    Actor(id: 26, name: "Bill Murray"),
                    Actor(id: 27, name: "Andie MacDowell")
                ]
            ),
            Movie(
                id: 25,
                title: "Back to the Future",
                posterURL: "https://image.tmdb.org/t/p/w500/7lyBcpYB0Qt8gYhXYaEZUNlNQAv.jpg",
                overview: "Marty McFly is accidentally sent 30 years into the past.",
                rating: 8.5,
                releaseDate: "1985-07-03",
                actors: [
                    Actor(id: 28, name: "Michael J. Fox"),
                    Actor(id: 29, name: "Christopher Lloyd")
                ]
            )
        ]
    }
    
    private func getDramaMovies() -> [Movie] {
        return [
            Movie(
                id: 31,
                title: "Schindler's List",
                posterURL: "https://image.tmdb.org/t/p/w500/sF1U4EUQS8YHUYjNl3pMGNIQyr0.jpg",
                overview: "In German-occupied Poland during World War II, industrialist Oskar Schindler.",
                rating: 8.9,
                releaseDate: "1993-12-15",
                actors: [
                    Actor(id: 30, name: "Liam Neeson"),
                    Actor(id: 31, name: "Ben Kingsley")
                ]
            ),
            Movie(
                id: 32,
                title: "The Green Mile",
                posterURL: "https://image.tmdb.org/t/p/w500/velWPhVMQeQKcxggNEU8YmIo52R.jpg",
                overview: "The lives of guards on Death Row are affected by one of their charges.",
                rating: 8.6,
                releaseDate: "1999-12-10",
                actors: [
                    Actor(id: 9, name: "Tom Hanks"),
                    Actor(id: 32, name: "Michael Clarke Duncan")
                ]
            ),
            Movie(
                id: 33,
                title: "A Beautiful Mind",
                posterURL: "https://image.tmdb.org/t/p/w500/zwzWCmH72OSC9NA0ipoqw5Zjya8.jpg",
                overview: "After John Nash suffers a nervous breakdown, he begins seeing things.",
                rating: 8.2,
                releaseDate: "2001-12-21",
                actors: [
                    Actor(id: 18, name: "Russell Crowe"),
                    Actor(id: 33, name: "Jennifer Connelly")
                ]
            ),
            Movie(
                id: 34,
                title: "Good Will Hunting",
                posterURL: "https://image.tmdb.org/t/p/w500/bABCBKYBK7A5G1x0FzoeoNfuj2.jpg",
                overview: "Will Hunting is a troubled genius who needs help from a psychologist.",
                rating: 8.3,
                releaseDate: "1997-12-05",
                actors: [
                    Actor(id: 34, name: "Matt Damon"),
                    Actor(id: 35, name: "Robin Williams")
                ]
            ),
            Movie(
                id: 35,
                title: "The Pianist",
                posterURL: "https://image.tmdb.org/t/p/w500/2hFvxCCWrTmCYwfy7yum0GKRi3Y.jpg",
                overview: "A Polish Jewish musician struggles to survive the destruction of the Warsaw ghetto.",
                rating: 8.5,
                releaseDate: "2002-09-25",
                actors: [
                    Actor(id: 36, name: "Adrien Brody"),
                    Actor(id: 37, name: "Thomas Kretschmann")
                ]
            )
        ]
    }
    
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
