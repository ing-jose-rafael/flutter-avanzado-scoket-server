class Band {
  String id, name;
  int votes;
  Band({this.id, this.name, this.votes});

  //regresa una nueva instancia de Band
  factory Band.fromMap(Map<String, dynamic> dta) => Band(
        id: dta['id'],
        name: dta['name'],
        votes: dta['votes'],
      );
}
