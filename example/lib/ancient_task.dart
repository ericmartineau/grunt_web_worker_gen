import 'dart:async';

import 'package:worker_service/work.dart';
import 'package:meta/meta.dart';

class AncientParams {
  final int delayInMillis;

  const AncientParams({
    @required this.delayInMillis,
  });

  factory AncientParams.fromJson(map) {
    return AncientParams(
      delayInMillis: (map['delayInMillis'] as int) ?? 1000,
    );
  }

  factory AncientParams.of(map) {
    if (map is AncientParams) return map;
    return AncientParams.fromJson(map);
  }

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return {
      'delayInMillis': this.delayInMillis,
    } as Map<String, dynamic>;
  }
}

@grunt()
class AncientTask with GruntMixin<AncientTask> {
  @override
  Future execute(dynamic params) async {
    final _params = AncientParams.fromJson(params);
    channel.updateStatus(
        currentStatus + WorkStatus(jobId: jobId, phase: WorkPhase.processing));
    sendUpdate(progress: 5);
    for (int i = 0; i < 50; i++) {
      if (isShuttingDown) {
        sendUpdate(message: "Got shutdown!");
        return;
      }
      sendUpdate(
          progress: (i + 1) * 100 / 50.0,
          message: "Doing great.  Sleeping for ${_params.delayInMillis}ms");
      await Future.delayed(Duration(milliseconds: _params.delayInMillis));
    }
    sendUpdate(message: "Completed!");
  }

  AncientParams parseParams(p) => AncientParams.fromJson(p);

  @override
  GruntFactoryFn<AncientTask> get create => newAncientTask;

  @override
  String get key => "ancientTask";

  @override
  String get package => "grunt_web_worker_gen";
}

AncientTask newAncientTask() => AncientTask();
