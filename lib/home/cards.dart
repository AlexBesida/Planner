import 'dart:async';

import 'package:slikker_kit/slikker_kit.dart';
import 'package:flutter/material.dart';
import 'package:tasker/create/collection.dart';

import 'package:tasker/resources/info_card.dart';
import 'package:tasker/data/data.dart';

// Return sorted tasks
class TasksCompleter {
  final Completer<Map<String, List<Map<String, dynamic>>>> _completer =
      new Completer();

  TasksCompleter() {
    Map<String, List<Map<String, dynamic>>> result = {};
    collections.keys.forEach((key) => result[key] = []);
    tasks.toMap().forEach((key, value) {
      result[value['collection']]!.add(key);
    });
    resolve(result);
  }

  Future<Map<String, List<Map<String, dynamic>>>> wait() => _completer.future;

  void resolve(Map<String, List<Map<String, dynamic>>> result) =>
      _completer.complete(result);
}

class CollectionCard extends StatelessWidget {
  final String collection;
  final LocalEvent event;
  final TasksCompleter resolver;

  CollectionCard(this.collection, this.event, this.resolver);

  @override
  Widget build(BuildContext context) {
    return SlikkerCard(
      accent: 240,
      isFloating: false,
      child: Column(
        children: [
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Container(
                  width: 60,
                  alignment: Alignment.center,
                  child: Text(
                    "📚",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Text(
                    event.summary ?? event.description ?? 'No Title',
                    style: TextStyle(fontSize: 18),
                    softWrap: false,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    event.start?.dateTime != null
                        ? "${event.start!.dateTime!.hour}:${event.start!.dateTime!.minute}"
                        : "${event.start!.date!.weekday}",
                    style: TextStyle(
                      fontSize: 16,
                      color: HSVColor.fromAHSV(0.5, 240, 0.1, 0.7).toColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              clipBehavior: Clip.none,
              padding: EdgeInsets.fromLTRB(0, 0, 15, 15),
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
                    future: resolver.wait(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return SlikkerCard(
                          accent: 240,
                          isFloating: false,
                          child: Center(
                            child: Text('Please wait.'),
                          ),
                        );
                      return InfoCard(
                        isFloating: true,
                        accent: 240,
                        title:
                            collections.get(collection)?['title'] ?? "No title",
                        description: 'edsdeed',
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
