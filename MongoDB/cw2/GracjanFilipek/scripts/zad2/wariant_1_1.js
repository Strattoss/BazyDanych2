use wariant_1_1

db.company.findOne()
db.company.drop()

db.company.insertMany([
	{
		_id: 301,
		contact: {
			phone: "+32 989 11 22 33",
			email: "business1@gel.fr"
		},
		name: "National Association of Francophone Lovers",
		full_address: "Mont-Mesly, 94000 Créteil, France",
		trips: [
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
				]
			}
		]
	},
	{
		_id: 302,
		contact: {
			phone: "+44 789 223 344",
			email: "info@adventureexplore.com"
		},
		name: "Adventure Explore",
		full_address: "15 Main Street, London, United Kingdom",
		trips: [
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
				]
			}
		]
	},
	{
		_id: 303,
		contact: {
			email: "info@luxuryretreats.com"
		},
		name: "Luxury Retreats",
		full_address: "123 Luxury Avenue, Beverly Hills, CA, USA",
		trips: []
	},
	{
		_id: 304,
		contact: {
			phone: "+49 123 45 67 89",
			email: "contact@travelwise.de"
		},
		name: "Travel Wise",
		full_address: "Berlin, Germany",
		trips: [
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
				]
			}
		]
	}
]);

// get trips organised by given company
db.company.aggregate([
    {
        $match: {
            _id: 304
        }
    },
    {
        $unwind: "$trips"
    },
    {
        $replaceRoot: {
            newRoot: "$trips"
        }
    }
])

// get all trips
db.company.aggregate([
    {
        $unwind: "$trips"
    },
    {
        $project: {
            trip: "$trips"
        }
    }
])

// get a trip by its id
db.company.aggregate([
    {
        $match: {
            "trips._id": 401
        }
    },
    {
        $unwind: "$trips"
    },
    {
        $replaceRoot: {
            newRoot: "$trips"
        }
    },
    {
        $match: {
            _id: 401
        }
    }
])