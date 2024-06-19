import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothProvider with ChangeNotifier {
  FlutterBlue _flutterBlue = FlutterBlue.instance;
  BluetoothDevice? _connectedDevice;
  List<BluetoothService> _services = [];
  List<BluetoothDevice> _devices = [];
  bool _isScanning = false;

  BluetoothDevice? get connectedDevice => _connectedDevice;
  List<BluetoothService> get services => _services;
  List<BluetoothDevice> get devices => _devices;
  bool get isScanning => _isScanning;

  BluetoothProvider() {
    _flutterBlue.scanResults.listen((results) {
      _devices = results.map((r) => r.device).toList();
      print("Devices found: ${_devices.length}");
      notifyListeners();
    });
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);
    if (!allGranted) {
      throw Exception("Permissions not granted");
    }
  }

  Future<void> startScan() async {
    try {
      await requestPermissions();
      if (_isScanning) return;
      _isScanning = true;
      _devices.clear();
      notifyListeners();
      print("Starting scan...");
      _flutterBlue.startScan(timeout: Duration(seconds: 4)).then((_) {
        _isScanning = false;
        print("Scan completed.");
        notifyListeners();
      }).catchError((e) {
        print("Error starting scan: $e");
        _isScanning = false;
        notifyListeners();
      });
    } catch (e) {
      print("Error requesting permissions: $e");
    }
  }

  void stopScan() {
    _flutterBlue.stopScan();
    _isScanning = false;
    notifyListeners();
  }

  Future<void> connect(BluetoothDevice device) async {
    try {
      await device.connect();
      _connectedDevice = device;
      _services = await device.discoverServices();
      print("Connected to ${device.name}");
      notifyListeners();
    } catch (e) {
      print("Error connecting to device: $e");
      _connectedDevice = null;
      _services = [];
      notifyListeners();
    }
  }

  Future<void> disconnect() async {
    if (_connectedDevice != null) {
      await _connectedDevice?.disconnect();
      _connectedDevice = null;
      _services = [];
      notifyListeners();
    }
  }

  Future<void> sendData(String data) async {
    if (_connectedDevice == null) return;

    for (BluetoothService service in _services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          try {
            await characteristic.write(data.codeUnits);
            print("Data sent: $data");
            return;
          } catch (e) {
            print("Error sending data: $e");
          }
        }
      }
    }
  }
}
