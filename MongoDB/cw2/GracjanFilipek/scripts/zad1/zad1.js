use yelp;
/*a)    Zwróć́ dane wszystkich restauracji (kolekcja businesss, pole categories musi zawierać wartość Restaurants),
które są otwarte w poniedziałki (pole hours) i mają ocenę co najmniej 4 gwiazdki (pole stars).
Zapytanie powinno zwracać: nazwę firmy, adres, kategorię, godziny otwarcia i gwiazdki. Posortuj wynik wg nazwy firmy.*/
db.business.aggregate(
	[
		{
			$match: {
				categories: { $in: ["Restaurants"] },
				"hours.Monday": { $exists: true },
				stars: { $gte: 4 }
			}
		},
		{
			$project: {
				_id: 0,
				name: 1,
				full_address: 1,
				categories: 1,
				hours: 1,
				stars: 1
			}
		},
		{
			$sort: {
				name: 1
			}
		}
	]
);

/*b)	Ile hoteli znajduje się w każdym mieście. (pole categories musi zawierać wartość Hotels & Travel lub Hotels).
Wynik powinien zawierać nazwę miasta, oraz liczbę hoteli. Posortuj wynik malejąco wg liczby hoteli.*/
db.business.aggregate([
	{
		$match: {
			categories: { $in: ["Hotels & Travel", "Hotels"] }
		}
	},
	{
		$group: {
			_id: "$city",
			totalHotels: {
				$count: {}
			}
		}
	},
	{
		$sort: {
			totalHotels: -1
		}
	}
]);

/*c)	Ile każda firma otrzymała ocen/wskazówek (kolekcja tip ) w 2012. Wynik powinien zawierać nazwę firmy oraz
liczbę ocen/wskazówek Wynik posortuj według liczby wskazówek (tip).*/
db.tip.aggregate([
	{
		$match: {
			$expr: {
				$eq: [{ $year: { $toDate: "$date" } }, 2012]
			}
		}
	},
	{
		$group: {
			_id: "$business_id",
			totalTips: { $count: {} }
		}
	},
	{
		$sort: {
			totalTips: -1
		}
	}
]);


/*d)	Recenzje mogą być oceniane przez innych użytkowników jako cool, funny lub useful
(kolekcja review, pole votes, jedna recenzja może mieć kilka głosów w każdej kategorii).
Napisz zapytanie, które zwraca dla każdej z tych kategorii, ile sumarycznie recenzji zostało oznaczonych przez te kategorie
(np. recenzja ma kategorię funny jeśli co najmniej jedna osoba zagłosowała w ten sposób na daną recenzję)*/
db.review.aggregate([
	{
		$group: {
			_id: null,
			totalFunny: {
				$sum: {
					$cond: [{ $gt: ["$votes.funny", 0] }, 1, 0]
				}
			},
			totalUseful: {
				$sum: {
					$cond: [{ $gt: ["$votes.useful", 0] }, 1, 0]
				}
			},
			totalCool: {
				$sum: {
					$cond: [{ $gt: ["$votes.cool", 0] }, 1, 0]
				}
			}
		}
	}
]);

/*e)	Zwróć́ dane wszystkich użytkowników (kolekcja user), którzy nie mają ani jednego pozytywnego głosu (pole votes)
z kategorii (funny lub useful), wynik posortuj alfabetycznie według nazwy użytkownika. */

db.user.aggregate([
	{
		$match: {
			$and: [
				{
					$expr: { $eq: ["$votes.funny", 0] }
				},
				{
					$expr: { $eq: ["$votes.useful", 0] }
				}
			]
		}
	},
	{
		$sort: {
			name: 1
		}
	}
]);

/*f)	Wyznacz, jaką średnia ocenę uzyskała każda firma na podstawie wszystkich recenzji (kolekcja review, pole stars).
Ogranicz do firm, które uzyskały średnią powyżej 3 gwiazdek.
przypadek 1: Wynik powinien zawierać id firmy oraz średnią ocenę. Posortuj wynik wg id firmy.
przypadek 2: Wynik powinien zawierać nazwę firmy oraz średnią ocenę. Posortuj wynik wg nazwy firmy.*/

// Przypadek 1
db.review.aggregate([
	{
		$group: {
			_id: "$business_id",
			averageStars: {
				$avg: "$stars"
			}
		}
	},
	{
		$match: {
			averageStars: { $gt: 3 }
		}
	},
	{
		$sort: {
			_id: 1
		}
	}
]);

// Przypadek 2
// ten wariant trwa boleśnie wręcz długo, chociaż wydaje się, że nie powinien
// dodać tak znaczącego narzutu w porównaniu z poprzednim przypadkiem
db.review.aggregate([
	{
		$group: {
			_id: "$business_id",
			averageStars: {
				$avg: "$stars"
			}
		}
	},
	{
		$match: {
			averageStars: { $gt: 3 }
		}
	},
	{
		$lookup: {
			from: "business",
			localField: "_id",
			foreignField: "business_id",
			as: "businessInfo"
		}
	},
	{
		$unwind: "$businessInfo"
	},
	{
		$project: {
			_id: 0,
			name: "$businessInfo.name",
			averageStars: 1
		}
	},
	{
		$sort: {
			name: 1
		}
	}
]);
