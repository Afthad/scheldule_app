import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

import '../models.dart';

class TimeLineWidget extends StatelessWidget {
  final List<SchedulerDTO>? data;
  const TimeLineWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Timeline.builder(
        itemBuilder: (s, i) {
          return TimelineTile(
            nodeAlign: TimelineNodeAlign.start,
            node: TimelineNode(
              indicator: const DotIndicator(
                size: 40,
                child: SizedBox(height: 60, child: Icon(Icons.date_range)),
              ),
              startConnector: i != 0 ? const DashedLineConnector() : null,
              endConnector:
                  i == data!.length - 1 ? null : const DashedLineConnector(),
            ),
            contents: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        DateFormat('h:mma').format(data![i].startTime),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      const Text('-',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500)),
                      Text(
                        DateFormat('h:mma').format(data![i].endTime),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    data![i].name,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            direction: Axis.vertical,
          );
        },
        itemCount: data!.length,
      ),
    );
  }
}
