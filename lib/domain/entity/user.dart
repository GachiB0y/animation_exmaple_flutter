class User {
  var _age = 0;
  int get age => _age;

  User(
    this._age,
  );

  User copyWith({
    int? age,
  }) {
    return User(age ?? this.age);
  }
}
