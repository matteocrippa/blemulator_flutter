part of blemulator;

class SimulatedService {
  final String uuid;
  final int id;
  final bool isAdvertised;
  final String? convenienceName;
  late final Map<int, SimulatedCharacteristic> _characteristics;

  SimulatedService({
    required String uuid,
    required this.isAdvertised,
    required List<SimulatedCharacteristic> characteristics,
    this.convenienceName,
  })  : uuid = uuid.toLowerCase(),
        id = IdGenerator().nextId() {
    _characteristics = Map.fromIterable(characteristics, key: (v) => v.id);
    for (var characteristic in _characteristics.values) {
      characteristic.attachToService(this);
    }
  }

  List<SimulatedCharacteristic> characteristics() =>
      _characteristics.values.toList();

  SimulatedCharacteristic? characteristic(int id) => _characteristics[id];

  SimulatedCharacteristic? characteristicByUuid(String uuid) =>
      _characteristics.values.firstWhere(
        (characteristic) =>
            characteristic.uuid.toLowerCase() == uuid.toLowerCase(),
      );
}
