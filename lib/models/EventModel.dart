

class EventModel {
  String eventId;
  String hostId;
  String hostName;
  DateTime startTime;
  DateTime endTime;
  String eventName;
  List<String> genres;
  String mainGenre;
  List<String> usersAttending;
  String lat;
  String long;
  String locationName;
  String fullAddress;
  String desc;
  double price;
  String listenUrl;
  String imageUrl;
  String hostLogoUrl;


  EventModel({
    this.eventId,
    this.hostId,
    this.hostName,
    this.startTime,
    this.endTime,
    this.eventName,
    this.genres,
    this.mainGenre,
    this.usersAttending,
    this.lat,
    this.long,
    this.desc,
    this.price,
    this.locationName,
    this.fullAddress,
    this.listenUrl,
    this.imageUrl,
    this.hostLogoUrl,
  });


  factory EventModel.dummy() {
    return EventModel(
        eventId: '',
      endTime: DateTime.now(),
      startTime: DateTime.now(),
      locationName: "The White House",
      fullAddress: "69 DeezNuts Ave",
      genres: ['DnB', 'Bit of Kanye', 'House'],
      mainGenre: 'Dnb',
      usersAttending: [],
      lat: '0',
      long: '0',
      desc: 'An event where your dreams come true \n \n you finally find the woman/man of your dreams, you go home finally happy.'
          'You go out for breakfast the next day, the order is taking too long but your hangover doesnt get to you as you are lost in each others eyes talking about how much fun this gig was'
          'Things escalate, and 10 years later you have your first child'
          'You name him Raver because it\'s a sick name and fuck you Dad'
          'You watch him grow, and when he becomes the ripe age of 3, you begin teaching him the decks'
          'Skillex doesn\'nt know what\' hit him. Raver Storms the charts like no ones every seen.'
          ' 10 years later your partner has been diagnosed with terminal cancer. '
          'As you hold thier hand and raver plays Wisconsin afterglow (Lofi remix feat. North West). They stare up to the ceiling, you can feel thier time is near. '
          'Before they go they whisper "God A night of Beacon base was a sick night"'
          '\n\n Dont miss out!',
      eventName: "A Night of Beacon Base",
      price: 0,
      listenUrl: '',
      hostId: '',
      hostLogoUrl: 'https://cdn.xxl.thumbs.canstockphoto.com/french-sailor-stock-photo_csp10455420.jpg',
      hostName: 'Strong Sailors',
      imageUrl: 'https://i2.wp.com/digiday.com/wp-content/uploads/2014/01/shutterstock_715632221.jpg?fit=4127%2C2582&zoom=2&quality=100&strip=all&ssl=1',



    );
  }

  EventModel.fromJson(Map<String, dynamic> json) {
      this.hostName = json['hostName']?? '';
      this.hostLogoUrl =  json['hostLogoUrl']?? '';
      this.eventId =  json['eventId']?? '';
      this.hostId = json['hostId']?? '';
      this.imageUrl = json['imageUrl']?? '';
      this.listenUrl = json['listenUrl']?? '';
      this.fullAddress = json['fullAddress']?? '';
      this.locationName = json['locationName']?? '';
      this.startTime = DateTime.tryParse(json["startTime"]);
     this.endTime = DateTime.tryParse(json['endTime']);
      this.eventName = json['eventName'];
      this.genres = List.from(json['genres']?? []);
      this.mainGenre = json['mainGenre']?? '';
      this.usersAttending = List.from(json['usersAttending']?? []);
      this.lat = json['lat'];
      this.long = json['long'];
      this.desc = json['desc'];
      this.price = json['price'];
  }

  @override
  Map<String, dynamic> toJson() => {
    'eventName': eventName,
    'desc': desc,
    'hostName': hostName,
    'hostLogoUrl': hostLogoUrl,
    'eventId': eventId,
    'locationName' : locationName,
    'hostId' : hostId,
    'imageUrl' : imageUrl,
    'listenUrl' : listenUrl,
    'fullAddress' : fullAddress,
    'genres' : genres,
    'startTime' : startTime.toString(),
    'startTimeMili' : startTime.millisecondsSinceEpoch,
    'endTime' : endTime.toString(),
    'usersAttending' : usersAttending,
    'mainGenre' : mainGenre,
    'lat' : lat,
    'long' : long,
    'price' : price,
  };
}
