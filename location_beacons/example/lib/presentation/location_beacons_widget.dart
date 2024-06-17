import 'package:flutter/material.dart';
import 'package:location_beacons_example/domain/entities/position_item.dart';
import 'package:location_beacons_example/domain/repositories/location_beacons_repository.dart';
import 'package:location_beacons_example/domain/types/position_item_type.dart';
import 'package:baseflow_plugin_template/baseflow_plugin_template.dart';
import 'package:location_beacons_example/presentation/location_beacons_floating_buttons.dart';
import 'package:location_beacons_example/presentation/location_beacons_popup_menu_button.dart';

final MaterialColor themeMaterialColor =
    BaseflowPluginExample.createMaterialColor(
        const Color.fromRGBO(48, 49, 60, 1));

class LocationBeaconsWidget extends StatefulWidget {
  const LocationBeaconsWidget({super.key});

  @override
  State<LocationBeaconsWidget> createState() => _LocationBeaconsWidgetState();
}

class _LocationBeaconsWidgetState extends State<LocationBeaconsWidget> {
  late final LocationBeaconsRepository _locationBeaconsRepository;

  final _positionItems = <PositionItem>[];

  @override
  void initState() {
    _locationBeaconsRepository = LocationBeaconsRepository(onLog: _onLog);
    _locationBeaconsRepository.toggleServiceStatusStream();
    super.initState();
  }

  @override
  void dispose() {
    _locationBeaconsRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseflowPluginExample(
      pluginName: 'Location Beacons',
      githubURL: 'https://github.com/nimec77/location_beacons.git',
      pubDevURL: 'https://pub.dev/packages/geolocator',
      appBarActions: [
        LocationBeaconsPopupMenuButton(
          locationBeaconsRepository: _locationBeaconsRepository,
          onClear: _clear,
        ),
      ],
      pages: [
        ExamplePage(
          Icons.location_on,
          (_) => Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: ListView.builder(
              itemCount: _positionItems.length,
              itemBuilder: (_, index) {
                final positionItem = _positionItems[index];

                if (positionItem.type.isLog) {
                  return ListTile(
                    title: Text(
                      positionItem.displayValue,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  return Card(
                    child: ListTile(
                      textColor: themeMaterialColor,
                      title: Text(
                        positionItem.displayValue,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
              },
            ),
            floatingActionButton: LocationBeaconsFloatingButtons(
              locationBeaconsRepository: _locationBeaconsRepository,
            ),
          ),
        ),
      ],
    );
  }

  void _onLog(PositionItemType type, String displayValue) {
    final positionItem = PositionItem(type, displayValue);
    setState(() {
      _positionItems.add(positionItem);
    });
  }

  void _clear() {
    setState(_positionItems.clear);
  }
}
