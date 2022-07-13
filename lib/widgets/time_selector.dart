import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scheduler_app/models.dart';

class TimeSelector extends StatefulWidget {
  Function(SchedulerDTO) onComplete;
  TimeSelector({Key? key, required this.onComplete}) : super(key: key);

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  Future<TimeOfDay?> _selectTimePicker(BuildContext context) async {
    return await showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  Future<DateTime?> _selectDatePicker(BuildContext context) async {
    return await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1));
  }

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  DateTime? _date;
  String? _name;

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add Schedule',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close))
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            'Name',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(
            height: 5,
          ),
          Form(
            key: formkey,
            child: TextFormField(
              decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  filled: true,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Colors.blue[100]),
              validator: (s) {
                if (s!.isEmpty) {
                  return 'Name cannot be empty';
                }
                if (s.length < 3) {
                  return 'Name should have at least 3 characters';
                }
              },
              onChanged: (s) {
                _name = s;
              },
              onSaved: (s) {
                _name = s;
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Date & Time',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  timeSelectionWidget(
                    onTap: () async {
                      _startTime = await _selectTimePicker(context);
                      if (_startTime != null && _endTime != null) {
                        if (!timeDifference(_startTime, _endTime)) {
                          _startTime = null;
                        }
                      }

                      setState(() {});
                    },
                    title: 'Start Time',
                    selectionText: _startTime != null
                        ? _startTime!.format(context)
                        : "Select Time",
                  ),
                  const Divider(),
                  timeSelectionWidget(
                    onTap: () async {
                      _endTime = await _selectTimePicker(context);

                      if (_startTime != null && _endTime != null) {
                        if (!timeDifference(_startTime, _endTime)) {
                          _endTime = null;
                        }
                      }

                      setState(() {});
                    },
                    title: 'End Time',
                    selectionText: _endTime != null
                        ? _endTime!.format(context)
                        : "Select time",
                  ),
                  const Divider(),
                  timeSelectionWidget(
                    onTap: () async {
                      _date = await _selectDatePicker(context);

                      setState(() {});
                    },
                    title: 'Date',
                    selectionText: _date != null
                        ? DateFormat('EEE, M/d/y').format(_date!)
                        : "Select Date",
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: MaterialButton(
                color: Colors.blue,
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    {
                      formkey.currentState!.save();
                      widget.onComplete(SchedulerDTO(
                          name: _name!,
                          startTime: DateTime(_date!.year, _date!.month,
                              _date!.day, _startTime!.hour, _startTime!.minute),
                          endTime: DateTime(_date!.year, _date!.month,
                              _date!.day, _endTime!.hour, _endTime!.minute),
                          date: _date!,
                          phoneNumber: '9207023603'));
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Add Schedule',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget timeSelectionWidget({
    required VoidCallback onTap,
    required String title,
    required String selectionText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            Text(selectionText),
            IconButton(
                onPressed: onTap,
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                ))
          ],
        )
      ],
    );
  }

  bool timeDifference(startTm, endTm) {
    bool result = false;
    int startTime = (startTm.hour * 60 + startTm.minute) * 60;
    int endTime = (endTm.hour * 60 + endTm.minute) * 60;
    int dif = startTime - endTime;

    if (endTime > startTime) {
      result = true;
    } else {
      result = false;
    }
    return result;
  }
}
