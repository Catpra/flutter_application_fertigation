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
                              onTap: () async {
                                await bluetoothProvider.connect(device);
                                Navigator.pop(context);
                                if (bluetoothProvider.connectedDevice != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Connected to ${device.name}')),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Failed to connect to ${device.name}')),
                                  );
                                }
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
      body: Column(
        children: [
          if (bluetoothProvider.connectedDevice != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Connected to ${bluetoothProvider.connectedDevice!.name}',
                  style: TextStyle(fontSize: 20)),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: scheduleProvider.schedules.length,
              itemBuilder: (context, index) {
                final schedule = scheduleProvider.schedules[index];

                // Calculate individual area durations
                final area1Duration = schedule.duration ~/ 3;
                final area2Duration = schedule.duration ~/ 3;
                final area3Duration =
                    schedule.duration - area1Duration - area2Duration;

                return Card(
                  margin: EdgeInsets.all(12.0),
                  color: Theme.of(context).cardColor.withOpacity(0.7),
                  child: ListTile(
                    title: Text(
                      'Time: ${schedule.hour.toString().padLeft(2, '0')}:${schedule.minute.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Duration Area 1: ${area1Duration ~/ 60} mins',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'Duration Area 2: ${area2Duration ~/ 60} mins',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'Duration Area 3: ${area3Duration ~/ 60} mins',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
