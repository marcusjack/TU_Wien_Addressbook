import 'package:flutter/material.dart';
import 'package:tu_wien_addressbook/models/person.dart';
import 'package:tu_wien_addressbook/widgets/simple_tile.dart';
import 'package:tu_wien_addressbook/widgets/utils.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;

  EmployeeCard(this.employee);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SimpleTile(
          title: employee.function,
          subtitle: employee.orgRef.name,
        ),
        Builder(builder: (BuildContext context) {
          if (employee.room == null) return Container();

          return SimpleTile(
              title: "Raum " + employee.room.roomCode,
              subtitle: employee.room.address.toString());
        }),
        Builder(builder: (BuildContext context) {
          if (employee.phoneNumbers == null) return Container();

          int numPhones = employee.phoneNumbers.length;

          List<Widget> widgets = List();
          for (int i = 0; i < numPhones; i++) {
            String title = "Telefon";
            if (numPhones > 1) {
              title += " ${i + 1}";
            }
            widgets.add(
                SimpleTile(title: title, subtitle: employee.phoneNumbers[i]));
          }

          return Column(
            children: widgets,
          );
        }),
        Builder(builder: (BuildContext context) {
          if (employee.websites == null) return Container();

          int numWebsites = employee.websites.length;

          List<Widget> widgets = List();
          for (int i = 0; i < numWebsites; i++) {
            String title = "Webseite";
            if (numWebsites > 1) {
              title += " ${i + 1}";
            }
            widgets.add(
                SimpleTile(title: title, subtitle: employee.websites[i].uri));
          }

          return Column(
            children: widgets,
          );
        }),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            Builder(builder: (BuildContext context) {
              if (employee.phoneNumbers == null) return Container();

              // TODO: also display the button if there is more than one phone
              // and open a popup if clicked
              if (employee.phoneNumbers.length != 1) return Container();

              return FlatButton.icon(
                icon: Icon(Icons.phone),
                label: const Text('TEL'),
                onPressed: () {
                  launchPhone(employee.phoneNumbers[0]);
                },
              );
            }),
            Builder(builder: (BuildContext context) {
              if (employee.websites == null) return Container();

              // TODO: also display the button if there is more than one website
              // and open a popup if clicked
              if (employee.websites.length != 1) return Container();

              return FlatButton.icon(
                icon: Icon(Icons.open_in_browser),
                label: const Text('WEB'),
                onPressed: () {
                  launchInBrowser(employee.websites[0].uri);
                },
              );
            }),
            Builder(builder: (BuildContext context) {
              if (employee.room == null) return Container();

              return FlatButton.icon(
                icon: Icon(Icons.map),
                label: const Text('KARTE'),
                onPressed: () {
                  launchInBrowser(employee.room.getMapUrl());
                },
              );
            }),
            Builder(
              builder: (BuildContext context) {
                if (employee.orgRef == null || employee.orgRef.tissId == null)
                  return Container();

                return FlatButton.icon(
                  icon: Icon(Icons.school),
                  label: Text('TISS'),
                  onPressed: () {
                    launchInBrowser(employee.orgRef.getTissUrl());
                  },
                );
              },
            ),
          ],
        ),
      ],
    ));
  }
}