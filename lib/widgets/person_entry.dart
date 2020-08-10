import 'package:flutter/material.dart';
import 'package:tu_wien_addressbook/models/person.dart';

class PersonEntry extends StatelessWidget {
  final Person person;

  const PersonEntry(this.person);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: person.getCircleAvatar(28),
      title: Text(
        "${person.firstName} ${person.lastName}",
      ),
      subtitle: Text(person.getShortDescription()),
    ));
  }
}