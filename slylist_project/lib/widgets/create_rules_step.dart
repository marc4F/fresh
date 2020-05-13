import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slylist_project/screens/playlist_creation.dart';

class CreateRulesStep extends StatefulWidget {
  @override
  _CreateRulesStepState createState() => _CreateRulesStepState();
}

class _CreateRulesStepState extends State<CreateRulesStep> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ScreenProvider, PlaylistStepperProvider>(
        builder: (context, screenProvider, playlistStepperProvider, child) {
      return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  trailing:
                      FlatButton(onPressed: null, child: const Text('Add')),
                  title: Text('Group 1'),
                ),
                Row(
                  children: <Widget>[
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                  ],
                ),
                Row(
                  children: <Widget>[
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                  ],
                ),
                Row(
                  children: <Widget>[
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                  ],
                ),
                Row(
                  children: <Widget>[
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                  ],
                ),
                Row(
                  children: <Widget>[
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                  ],
                ),
                Row(
                  children: <Widget>[
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                  ],
                ),
                Row(
                  children: <Widget>[
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                  ],
                ),
                Row(
                  children: <Widget>[
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                  ],
                ),
                Row(
                  children: <Widget>[
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                  ],
                ),
                Row(
                  children: <Widget>[
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                  ],
                ),
                Row(
                  children: <Widget>[
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                  ],
                ),
                Row(
                  children: <Widget>[
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                  ],
                ),
                Row(
                  children: <Widget>[
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                  ],
                ),
                Row(
                  children: <Widget>[
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                    FlatButton(onPressed: null, child: const Text('button')),
                  ],
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: const Text('BUY TICKETS'),
                      onPressed: () {/* ... */},
                    ),
                    FlatButton(
                      child: const Text('LISTEN'),
                      onPressed: () {/* ... */},
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
