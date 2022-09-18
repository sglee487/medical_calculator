import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '/constants.dart';
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

class SqlEpinephrineRateList extends StatefulWidget {
  const SqlEpinephrineRateList({Key? key}) : super(key: key);

  @override
  State<SqlEpinephrineRateList> createState() => _SqlEpinephrineRateListState();
}

class _SqlEpinephrineRateListState extends State<SqlEpinephrineRateList> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  Future<void> deleteEpinephrineRate(int id) async {
    final dbPath = await getDatabasesPath();
    final db = await openDatabase(
      join(dbPath, 'epinephrine_rate.db'),
      version: 1,
    );

    await db.delete(
      'epinephrine_rate',
      where: 'id = ?',
      whereArgs: [id],
    );

    showToastMessage('Deleted!');
  }

  void _delete(int id) async {
    await deleteEpinephrineRate(id);
    showToastMessage('Deleted!');
  }

  Future<List<EpinephrineRate>> _loadLocalSql(BuildContext context) async {
    final dbPath = await getDatabasesPath();
    final db = await openDatabase(
      join(dbPath, 'epinephrine_rate.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE epinephrine_rate(id INTEGER PRIMARY KEY, uuid TEXT, created_at TEXT, result TEXT, dose TEXT, weight TEXT, drug TEXT, afterShuffleIV TEXT )',
        );
      },
      version: 1,
    );

    try {
      final List<Map<String, dynamic>> maps =
          await db.query('epinephrine_rate');

      // Convert the List<Map<String, dynamic> into a List<Dog>.
      return List.generate(maps.length, (i) {
        return EpinephrineRate(
          id: maps[i]['id'],
          uuid: maps[i]['uuid'],
          created_at: maps[i]['created_at'],
          result: maps[i]['result'],
          dose: maps[i]['dose'],
          weight: maps[i]['weight'],
          drug: maps[i]['drug'],
          afterShuffleIV: maps[i]['afterShuffleIV'],
        );
      });
    } on DatabaseException {
      throw "no saved record";
    }
  }

  Widget _localSqlListView(
      BuildContext context, List<EpinephrineRate> epinephrineRates) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: epinephrineRates.length,
      itemBuilder: (BuildContext context, int index) {
        final savedTime = DateTime.parse(epinephrineRates[index].created_at);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 50,
              height: 50,
            ),
            Column(
              children: [
                Column(
                  children: [
                    Text(DateFormat('y-MM-dd hh:mm:ss a').format(savedTime),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(epinephrineRates[index].id.toString()),
                    Row(
                      children: [
                        const Text('주입용량단위: ', style: TextStyle(fontSize: 12)),
                        Text(epinephrineRates[index].dose,
                            style: const TextStyle(
                              fontSize: 14,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            )),
                        const Text('mcg/kg/min',
                            style: TextStyle(fontSize: 12)),
                        const VerticalDivider(),
                        const Text('체중: ', style: TextStyle(fontSize: 12)),
                        Text(epinephrineRates[index].weight,
                            style: const TextStyle(
                              fontSize: 14,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            )),
                        const Text('kg', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('약물의 용량: ', style: TextStyle(fontSize: 12)),
                        Text(epinephrineRates[index].drug,
                            style: const TextStyle(
                              fontSize: 14,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            )),
                        const Text('mg', style: TextStyle(fontSize: 12)),
                        const VerticalDivider(),
                        const Text('혼합 후 수액량: ',
                            style: TextStyle(fontSize: 12)),
                        Text(epinephrineRates[index].afterShuffleIV,
                            style: const TextStyle(
                              fontSize: 14,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            )),
                        const Text('ml', style: TextStyle(fontSize: 12)),
                      ],
                    )
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    const Text(
                      '주입용량 속도는 ',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      epinephrineRates[index].result,
                      style: const TextStyle(
                          fontSize: 16,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'cc/hr 입니다',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ],
            ),
            IconButton(
                onPressed: () {
                  _delete(epinephrineRates[index].id!);
                  setState(() {
                    epinephrineRates.length;
                    _loadLocalSql(context);
                    epinephrineRates.length;
                  });
                },
                icon: const Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.red,
                ))
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EpinephrineRate>>(
      future: _loadLocalSql(context),
      builder: (BuildContext context,
          AsyncSnapshot<List<EpinephrineRate>> snapshot) {
        return Center(
          child: FutureBuilder<List<EpinephrineRate>>(
              future: _loadLocalSql(context),
              builder: (BuildContext context,
                  AsyncSnapshot<List<EpinephrineRate>> snapshot) {
                Widget child;
                if (snapshot.hasData) {
                  var data = snapshot.data;
                  data?.sort((a, b) => b.created_at.compareTo(a.created_at));
                  if (data!.isEmpty) {
                    child = Column(children: const [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          'no saved data.\nPlease try to use "save"!',
                          textAlign: TextAlign.center,
                        ),
                      )
                    ]);
                  } else {
                    child = _localSqlListView(context, data);
                  }
                } else if (snapshot.hasError) {
                  child = Column(children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: not supported on web'),
                    )
                  ]);
                } else {
                  child = Column(
                    children: const [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      )
                    ],
                  );
                }
                return Center(
                  child: child,
                );
              }),
        );
      },
    );
  }
}
