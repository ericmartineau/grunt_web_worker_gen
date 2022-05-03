// ignore: unused_import
import 'dart:html';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfile/pfile_api.dart';
import 'package:sunny_services/upload_large_file.dart';
import 'package:worker_service/work.dart';

import 'ancient_task.dart';

class TestWorkProxies extends StatefulWidget {
  const TestWorkProxies({Key key}) : super(key: key);

  @override
  _TestWorkProxiesState createState() => _TestWorkProxiesState();
}

class SupervisorAndArgs<G extends Grunt> {
  final Supervisor<G> supervisor;
  final dynamic args;

  SupervisorAndArgs(this.supervisor, this.args);
}

class _TestWorkProxiesState extends State<TestWorkProxies> {
  final _items = <SupervisorAndArgs>[];
  var i = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Isolates"),
        ),
        // backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                child: Row(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          var supervisor = await Supervisor.create(
                              UploadLargeFile(),
                              isProduction: false);
                          setState(() {
                            _items.add(SupervisorAndArgs(
                                supervisor,
                                UploadFileParams.ofPFile(
                                  file: PFile.of("/tmp/foo.file"),
                                  keyName: "hell/foo",
                                )));
                          });
                        },
                        child: Text("Upload Large File")),
                    SizedBox(width: 15),
                    ElevatedButton(
                        onPressed: () async {
                          var supervisor =
                              // ignore: missing_required_param
                              await Supervisor.create(AncientTask(),
                                  isProduction: false);
                          // supervisor.start(AncientParams(
                          //     delayInMillis: 1234 * (pow(10, i++).toInt())));
                          setState(() {
                            _items.add(SupervisorAndArgs(
                                supervisor,
                                AncientParams(
                                    delayInMillis: (pow(10, i++).toInt()))));
                          });
                        },
                        child: Text("Start Counter")),
                  ],
                ),
              ),
              for (var s in _items)
                JobTile(
                  supervisor: s.supervisor,
                  onStop: (phase) {
                    if (phase >= WorkPhase.processing) {
                      s.supervisor.stop();
                    } else {
                      s.supervisor.start(params: s.args);
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef EmptyCallback = void Function(WorkPhase p);

class JobTile extends StatelessWidget {
  final Supervisor supervisor;
  final EmptyCallback onStop;
  final WorkStatus initialStatus;

  JobTile({Key key, @required this.supervisor, this.onStop})
      : initialStatus = supervisor.status,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<WorkStatus>(
        key: Key("Update ${supervisor.jobId ?? 'unknown'}"),
        stream: supervisor.onStatus,
        initialData: initialStatus,
        builder: (context, snapshot) {
          var phase = snapshot.data.phase;
          var status = snapshot.data;
          print("Rebuilding List tile with ${snapshot.data.phase}");
          return ListTile(
            leading: CircleAvatar(
                child: Text("${status.percentComplete?.round() ?? 0}")),
            title: Text("Supervisor: ${supervisor.gruntType}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.data.phase.toString()),
                if (status.message != null && status.message.isNotEmpty)
                  Text(status.message,
                      style: TextStyle(fontStyle: FontStyle.italic))
              ],
            ),
            trailing: MaterialButton(
              child: (phase > WorkPhase.initializing)
                  ? (phase == WorkPhase.stopped)
                      ? Text("Stopped")
                      : Text("Stop")
                  : (phase == WorkPhase.starting)
                      ? Text("Starting...")
                      : Text("Start"),
              onPressed:
                  (phase == WorkPhase.stopped) ? null : (() => onStop(phase)),
            ),
          );
        });
  }
}
