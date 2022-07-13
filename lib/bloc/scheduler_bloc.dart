import 'dart:async';

import 'package:dio/dio.dart';

import '../models.dart';

class SchedulerBLoc {
  late Response response;
  var dio = Dio();

  Future<bool> sendData(SchedulerDTO dto) async {
    try {
      response = await dio.post(
          'https://alpha.classaccess.io/api/challenge/v1/save/schedule',
          data: dto.toMap());
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  List<SchedulerDTO> schedules = [];

  final StreamController<List<SchedulerDTO>> _dataController =
      StreamController<List<SchedulerDTO>>();

  Stream<List<SchedulerDTO>> get dataStream => _dataController.stream;

  void addData(SchedulerDTO schedulerDTO) {
    schedules.add(schedulerDTO);
    _dataController.sink.add(schedules);
  }

  dispose() {
    _dataController.close();
  }

  SchedulerBLoc() {
    getData();
  }
  Future<void> getData() async {
    var data = await dio.get(
        'https://alpha.classaccess.io/api/challenge/v2/schedule/:9207023603');
    schedules.addAll(List<SchedulerDTO>.from(
        data.data['data']?.map((x) => SchedulerDTO.fromMap(x))));
    _dataController.sink.add(schedules);
  }
}
