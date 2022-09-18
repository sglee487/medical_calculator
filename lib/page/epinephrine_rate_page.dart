import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:uuid/uuid.dart';

import 'epinephrine_rate_list.dart';

import '/components/navigation_drawer.dart';
import '/components/topBar.dart';

import '/constants.dart';
import '/globals.dart';
import '/utils.dart';

class EpinephrineRate {
  final int? id;
  final String uuid;
  final String created_at;
  final String result;
  final String dose;
  final String weight;
  final String drug;
  final String afterShuffleIV;

  const EpinephrineRate({
    this.id,
    required this.uuid,
    required this.created_at,
    required this.result,
    required this.dose,
    required this.weight,
    required this.drug,
    required this.afterShuffleIV,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'created_at': created_at,
      'result': result,
      'dose': dose,
      'weight': weight,
      'drug': drug,
      'afterShuffleIV': afterShuffleIV,
    };
  }

  @override
  String toString() {
    return 'EpinephrineRate{id: $id, created_at: $created_at, result: $result}';
  }
}

class EpinephrineRatePage extends StatefulWidget {
  const EpinephrineRatePage({Key? key}) : super(key: key);

  @override
  State<EpinephrineRatePage> createState() => _EpinephrineRatePageState();
}

class _EpinephrineRatePageState extends State<EpinephrineRatePage> {
  final LocalStorage storage = LocalStorage('epinephrine');
  final Globals globals = Globals();

  String _calculateResult = '0.00';

  final TextEditingController doseController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController drugController = TextEditingController();
  final TextEditingController afterShuffleIVController =
      TextEditingController();

  late final database;

  double convertTextToDouble(String input) {
    try {
      return double.parse(input);
    } catch (e) {
      return 0.0;
    }
  }

  String _calculate() {
    double dose = convertTextToDouble(doseController.text);
    double weight = convertTextToDouble(weightController.text);
    double drug = convertTextToDouble(drugController.text);
    double afterShuffleIV = convertTextToDouble(afterShuffleIVController.text);

    if (drug == 0.0) {
      return '0.00';
    }

    return (dose * afterShuffleIV * weight / drug).toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    storage.ready.then((_) {
      var lastSaved = storage.getItem('lastSaved');
      if (lastSaved != null) {
        doseController.text = lastSaved['dose'];
        weightController.text = lastSaved['weight'];
        drugController.text = lastSaved['drug'];
        afterShuffleIVController.text = lastSaved['afterShuffleIV'];
        setState(() {
          _calculateResult = lastSaved['calculateResult'];
        });
      }
    });

    WidgetsFlutterBinding.ensureInitialized();
    getDatabasesPath().then((path) => {
          database = openDatabase(
            join(path, 'epinephrine_rate.db'),
            onCreate: (db, version) {
              return db.execute(
                'CREATE TABLE epinephrine_rate(id INTEGER PRIMARY KEY, uuid TEXT, created_at TEXT, result TEXT, dose TEXT, weight TEXT, drug TEXT, afterShuffleIV TEXT )',
              );
            },
            version: 1,
          )
        });
  }

  void calculate() async {
    setState(() {
      _calculateResult = _calculate();
    });
    if (_calculateResult != '0.00') {
      await storage.setItem('lastSaved', {
        'dose': doseController.text,
        'weight': weightController.text,
        'drug': drugController.text,
        'afterShuffleIV': afterShuffleIVController.text,
        'calculateResult': _calculateResult
      });
    }
  }

  Future<void> addEpinephrineRate(EpinephrineRate epinephrineRate) async {
    final db = await database;

    db.insert('epinephrine_rate', epinephrineRate.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void _save(EpinephrineRate epinephrineRate) async {
    if (_calculateResult == '0.00') {
      return;
    }

    await addEpinephrineRate(epinephrineRate);
    showToastMessage('Saved!');
  }

  void _reset() {
    doseController.text = '';
    weightController.text = '';
    drugController.text = '';
    afterShuffleIVController.text = '';
    setState(() {
      _calculateResult = '0.00';
    });
    storage.deleteItem('lastSaved');
  }

  String dateTimeToString(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.month}:${dateTime.second / 10000}';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: const TopBar(title: 'Epinephrine Rate'),
        body: Container(
          decoration: const BoxDecoration(color: kBackgroundColor1),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(kDefaultPadding * 2),
                        child: Form(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextFormField(
                                    controller: doseController,
                                    keyboardType: TextInputType.number,
                                    cursorColor: Colors.black,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
                                        labelText: '주입용량단위(mcg/kg/min)'),
                                    onChanged: (value) {
                                      calculate();
                                    },
                                    textInputAction: TextInputAction.next),
                                const Divider(
                                  color: Colors.transparent,
                                  height: kDefaultPadding / 2,
                                ),
                                TextFormField(
                                    controller: weightController,
                                    keyboardType: TextInputType.number,
                                    cursorColor: Colors.black,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
                                        labelText: '체중(kg)'),
                                    onChanged: (value) {
                                      calculate();
                                    },
                                    textInputAction: TextInputAction.next),
                                const Divider(
                                  color: Colors.transparent,
                                  height: kDefaultPadding / 2,
                                ),
                                TextFormField(
                                    controller: drugController,
                                    keyboardType: TextInputType.number,
                                    cursorColor: Colors.black,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
                                        labelText: '약물의 용량(mg)'),
                                    onChanged: (value) {
                                      calculate();
                                    },
                                    textInputAction: TextInputAction.next),
                                const Divider(
                                  color: Colors.transparent,
                                  height: kDefaultPadding / 2,
                                ),
                                TextFormField(
                                    controller: afterShuffleIVController,
                                    keyboardType: TextInputType.number,
                                    cursorColor: Colors.black,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
                                        labelText: '혼합 후 수액량(ml)'),
                                    onChanged: (value) {
                                      calculate();
                                    },
                                    textInputAction: TextInputAction.done),
                                Padding(
                                  padding:
                                      const EdgeInsets.all(kDefaultPadding),
                                  child: ElevatedButton(
                                      onPressed: () => _save(EpinephrineRate(
                                          uuid: const Uuid().v4(),
                                          created_at:
                                              DateTime.now().toIso8601String(),
                                          result: _calculateResult,
                                          dose: doseController.text,
                                          weight: weightController.text,
                                          drug: drugController.text,
                                          afterShuffleIV:
                                              afterShuffleIVController.text)),
                                      child: const Text(
                                        'save',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                                const Divider(
                                  height: 3,
                                  color: Colors.transparent,
                                ),
                                TextButton(
                                    onPressed: () {
                                      _reset();
                                    },
                                    child: const Text(
                                      'reset',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline),
                                    ))
                              ],
                            ),
                          ),
                        )),
                  ),
                ),
                Container(
                  width: size.width,
                  decoration: BoxDecoration(color: Colors.blueGrey[800]!),
                  child: Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '주입 속도는 ',
                            style: TextStyle(
                                color: Colors.blueGrey[200]!, fontSize: 18),
                          ),
                          Text(
                            '${_calculateResult}cc/hr',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                          Text(
                            ' 입니다.',
                            style: TextStyle(
                                color: Colors.blueGrey[200]!, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 15, 80),
          child: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: const SqlEpinephrineRateList(),
                      ));
            },
            tooltip: 'history',
            child: const Icon(Icons.history_outlined),
          ),
        ), // Thi,
        drawer: const NavigationDrawer(index: 1));
  }
}
