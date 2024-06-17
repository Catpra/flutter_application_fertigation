import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';
import '../providers/bluetooth_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final bluetoothProvider = Provider.of<BluetoothProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Scheduler', style: Theme.of(context).textTheme.headlineSmall),
        actions: [
          IconButton(
            icon: Icon(Icons.bluetooth),
            onPressed: () async {
              await bluetoothProvider.startScan();
              await showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Consumer<BluetoothProvider>(
                    builder: (context, bluetoothProvider, child) {
                      if (bluetoothProvider.isScanning) {
                        // Correctly reference the getter
                        return Center(child: CircularProgressIndicator());
                      } else if (bluetoothProvider.devices.isEmpty) {
                        return Center(child: Text('No devices found'));
                      } else {
                        return ListView(
                          children: bluetoothProvider.devices.map((device) {
                            return ListTile(
                              title: Text(device.name.isEmpty
                                  ? 'Unknown device'
                                  : device.name),
                              subtitle: Text(device.id.toString()),
                              onTap: () {
                                bluetoothProvider.connect(device);
                                Navigator.pop(context);
                              },
                            );
                          }).toList(),
                        );
                      }
                    },
                  );
                },
              );
              bluetoothProvider.stopScan();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 3, // There are 3 areas
        itemBuilder: (context, index) {
          int area = index + 1;
          List schedules =
              scheduleProvider.schedules.where((s) => s.area == area).toList();

          return Card(
            margin: EdgeInsets.all(12.0),
            color: Theme.of(context).cardColor.withOpacity(0.7),
            child: ExpansionTile(
              backgroundColor: Theme.of(context).cardColor,
              title: Text('Area $area',
                  style: Theme.of(context).textTheme.headlineSmall),
              children: schedules.map((schedule) {
                return ListTile(
                  title: Text(
                    'Time: ${schedule.hour}:${schedule.minute}, Duration: ${schedule.duration} min',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/input');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
