class Band {
  String id, name;
  int votes;
  Band({this.id, this.name, this.votes});

  //regresa una nueva instancia de Band
  factory Band.fromMap(Map<String, dynamic> dta) => Band(
        id: dta.containsKey('id') ? dta['id'] : 'No-id',
        name: dta.containsKey('name') ? dta['name'] : 'No-name',
        votes: dta.containsKey('votes') ? dta['votes'] : 0,
      );
}
