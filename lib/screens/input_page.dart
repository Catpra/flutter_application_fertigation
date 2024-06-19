import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';
import '../models/schedule.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  int _hour = 0;
  int _minute = 0;
  int _durationArea1 = 0;
  int _durationArea2 = 0;
  int _durationArea3 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Schedule',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Hour (hh)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _hour = int.parse(value!);
                },
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.parse(value) < 0 ||
                      int.parse(value) > 23) {
                    return 'Please enter a valid hour (00-23)';
                  }
                  if (value.length != 2) {
                    return 'Please enter hour in "hh" format';
                  }
                  return null;
                },
                style: TextStyle(fontSize: 20),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Minute (mm)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _minute = int.parse(value!);
                },
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.parse(value) < 0 ||
                      int.parse(value) > 59) {
                    return 'Please enter a valid minute (00-59)';
                  }
                  if (value.length != 2) {
                    return 'Please enter minute in "mm" format';
                  }
                  return null;
                },
                style: TextStyle(fontSize: 20),
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Duration for Area 1 (minutes)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _durationArea1 = int.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty || int.parse(value) <= 0) {
                    return 'Please enter a valid duration for Area 1 (greater than 0)';
                  }
                  return null;
                },
                style: TextStyle(fontSize: 20),
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Duration for Area 2 (minutes)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _durationArea2 = int.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty || int.parse(value) <= 0) {
                    return 'Please enter a valid duration for Area 2 (greater than 0)';
                  }
                  return null;
                },
                style: TextStyle(fontSize: 20),
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Duration for Area 3 (minutes)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _durationArea3 = int.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty || int.parse(value) <= 0) {
                    return 'Please enter a valid duration for Area 3 (greater than 0)';
                  }
                  return null;
                },
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final totalDuration = _durationArea1 * 60 +
                        _durationArea2 * 60 +
                        _durationArea3 * 60;
                    Provider.of<ScheduleProvider>(context, listen: false)
                        .addSchedule(
                      Schedule(
                        hour: _hour,
                        minute: _minute,
                        duration: totalDuration,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Schedule', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
