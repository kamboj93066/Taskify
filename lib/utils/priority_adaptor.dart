import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/utils/priority.dart'; // Import the Priority enum

class PriorityAdapter extends TypeAdapter<Priority> {
  @override
  Priority read(BinaryReader reader) {
    // Read the index of the enum from binary and return the corresponding enum value
    return Priority.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, Priority obj) {
    // Write the index of the enum to binary
    writer.writeInt(obj.index);
  }

  @override
  int get typeId => 1; // Unique identifier for the adapter
}
