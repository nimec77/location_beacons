import 'package:location_beacons_example/domain/types/position_item_type.dart';

class PositionItem {
  final PositionItemType type;
  final String displayValue;

  const PositionItem(this.type, this.displayValue);
}
