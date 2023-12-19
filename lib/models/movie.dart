class Movie {
  final String title;
  final String overview;
  final String poster_path;
  final String backdrop_path;
  final String vote_average;
  final int id;

  Movie(
      {required this.title,
        required this.id,
        required this.overview,
        required this.poster_path,
        required this.backdrop_path,
        required this.vote_average});

  factory Movie.formJson(Map<String, dynamic> json) {
    return Movie(
        title: json['title'] ?? '',
        id: json['id'] ??'',
        overview: json['overview'] ?? '',
        backdrop_path: 'https://image.tmdb.org/t/p/w500${json['backdrop_path']}',
        poster_path: 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
        vote_average: json['vote_average'].toString());
  }

  @override
  String toString() {
    return 'Movie('
        "title: ${this.title} "
        "id: ${this.id} "
        "overview: ${this.overview} "
        "poster_path: ${this.poster_path} "
        "vote_average: ${this.vote_average} "
        ')';
  }
}









final data = {
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz",
  "address": {
    "street": "Kulas Light",
    "suite": "Apt. 556",
    "city": "Gwenborough",
    "zipcode": "92998-3874",
    "geo": {"lat": "-37.3159", "lng": "81.1496"}
  },
  "phone": "1-770-736-8031 x56442",
  "website": "hildegard.org",
  "company": {
    "name": "Romaguera-Crona",
    "catchPhrase": "Multi-layered client-server neural-net",
    "bs": "harness real-time e-markets"
  }
};


class MainData{
  final int id;
  final Address address;

  MainData({
    required this.address,
    required this.id
  });

}

class Address{
  final String street;
  final Geo geo;
  Address({
    required this.geo,
    required this.street
  });

}

class Geo{
  final String lat;
  final String lng;
  Geo({
    required this.lat,
    required this.lng
  });

}