use wariant_2_2

db.customer.find()
db.trip.find()

db.customer.drop()
db.trip.drop()

db.customer.insertMany([
    {
        _id: 101,
        nickname: "Arturo32",
        personalData: {
            firstName: "Arthur",
            lastName: "de Montagne",
            dateOfBirth: ISODate("1995-05-06"),
            primaryEmail: "kingarthur@yahoo.com",
            otherEmails: []
        }
    },
    {
        _id: 102,
        nickname: "MAD_alena",
        personalData: {
            firstName: "Magdalena",
            lastName: "Novaya",
            dateOfBirth: ISODate("1987-02-20"),
            primaryEmail: "crazy_bicorn@gmail.com",
            otherEmails: ["crazier_bicorn@gmail.com", "anotherOne@hotmail.com"]
        }
    },
    {
        _id: 103,
        nickname: "Traveler23",
        personalData: {
            firstName: "Emily",
            lastName: "Johnson",
            dateOfBirth: ISODate("1990-09-15"),
            primaryEmail: "emily.johnson@example.com",
            otherEmails: []
        }
    },
    {
        _id: 104,
        nickname: "Adventurer22",
        personalData: {
            firstName: "John",
            lastName: "Smith",
            dateOfBirth: ISODate("1985-07-10"),
            primaryEmail: "johnsmith@example.com",
            otherEmails: []
        }
    }
])

db.trip.insertMany([
    {
        _id: 401,
        availableSeats: 5,
        title: "City of Love",
        destinations: [
            {
                country: "France",
                cities: ["Paris", "Auvergne", "Bordeaux"]
            }
        ],
        description: "Come to one of the most popular tourist destinations in the world! Taste exquisite French wine and lose yourself in an endless maze of charming Parisian streets",
        startDate: ISODate("2023-09-04T18:30"),
        endDate: ISODate("2023-09-06T20:00"),
        price: {
            value: 609.99,
            currency: "EUR"
        },
        categories: [
            "Couple",
            "Food",
            "Architecture",
            "Romantic",
            "Urban"
        ],
        reservations: [
            {
                _id: 201,
                date: ISODate("2022-01-14T18:03:12"),
                purchasedSeats: 2,
                review: {
                    stars: 4,
                    comment: "Quite a nice trip, I must admit"
                },
                customer_id: 101
            },
            {
                _id: 205,
                date: ISODate("2022-05-10T11:20:00"),
                purchasedSeats: 4,
                review: {
                    stars: 3,
                    comment: "The trip was okay, but could be better."
                },
                customer_id: 105
            }
        ]
    },
    {
        _id: 402,
        availableSeats: 8,
        title: "Exotic Culinary Adventure",
        destinations: [
            {
                country: "Thailand",
                cities: ["Bangkok", "Chiang Mai", "Phuket"]
            },
            {
                country: "Laos",
                cities: ["Sam Neua"]
            }
        ],
        description: "Embark on a culinary journey through the vibrant streets of Thailand. Indulge in delicious Thai cuisine, experience local flavors, and learn the secrets of authentic Thai cooking.",
        startDate: ISODate("2023-03-10T10:00"),
        endDate: ISODate("2023-03-16T18:00"),
        price: {
            value: 899.99,
            currency: "USD"
        },
        categories: [
            "Food",
            "CulturalExploration",
            "Adventure"
        ],
        reservations: [
            {
                _id: 202,
                date: ISODate("2022-02-01T12:35:45"),
                purchasedSeats: 1,
                customer_id: 103
            },
            {
                _id: 204,
                date: ISODate("2022-04-05T15:45:30"),
                purchasedSeats: 2,
                customer_id: 104
            }
        ]
    },
    {
        _id: 403,
        availableSeats: 12,
        title: "Mountain Retreat",
        destinations: [
            {
                country: "Switzerland",
                cities: ["Zermatt", "Interlaken"]
            },
            {
                country: "Italy",
                cities: ["Aosta"]
            }
        ],
        description: "Escape to the serene beauty of the Swiss Alps. Enjoy breathtaking mountain views, indulge in winter sports, and rejuvenate in luxurious alpine resorts.",
        startDate: ISODate("2023-06-20T09:00"),
        endDate: ISODate("2023-06-26T17:00"),
        price: {
            value: 1499.99,
            currency: "EUR"
        },
        categories: [
            "Mountains",
            "Outdoor",
            "Adventure"
        ],
        reservations: [
            {
                _id: 203,
                date: ISODate("2022-03-18T09:24:56"),
                purchasedSeats: 3,
                review: {
                    stars: 5,
                    comment: "Absolutely loved the trip!"
                },
                customer_id: 102
            }
        ]
    }
])

/*
Trip categories:
Adventure, Ancient, Architecture, Art&Culture, Beach,
Couples, CulturalExploration, Eco, Family, Food,
HiddenGem, Historical, Island, Luxurious, Mountains,
NatureWonders, Outdoor, Romantic, Safari,
SpiritualJourney, Urban, Wildlife
*/

// get all reservations for a trip
db.trip.aggregate([
    {
        $match: {
            _id: 401
        }
    },
    {
        $unwind: "$reservations"
    },
    {
        $replaceRoot: {
            newRoot: "$reservations"
        }
    }
])

// get all reservations made by a customer
db.trip.aggregate([
    {
        $match: {
            "reservations.customer_id": 103
        }
    },
    {
        $unwind: "$reservations"
    },
    {
        $replaceRoot: {
            newRoot: "$reservations"
        }
    },
    {
        $match: {
            customer_id: 103
        }
    }
])

// client's reservations which haven't been reviewed yet
db.trip.aggregate([
    {
        $unwind: "$reservations"
    },
    {
        $replaceRoot: {
            newRoot: "$reservations"
        }
    },
    {
        $match: {
            review: {
                $exists: false
            },
            date: {
                $lt: ISODate()
            }
        }
    },
    {
        $match: {
            customer_id: 103
        }
    }
])
