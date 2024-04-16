import 'package:app_core/pages/deeplink_launcher_page.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:networking/networking.dart';
import 'package:storage/local_storage.dart';

class ConfigPage extends StatefulWidget {
  final List<Map<String, Widget>>? customMonitoring;

  const ConfigPage({
    super.key,
    this.customMonitoring,
  });

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'App Configurations',
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Network Monitoring'),
              onTap: _navigateToNetworkMonitoring,
            ),
            ListTile(
              title: const Text('Storage Monitoring'),
              onTap: _navigateToStorageMonitoring,
            ),
            ...?widget.customMonitoring?.map(
              (e) => ListTile(
                title: Text(e.keys.first),
                onTap: () => _navigateTo(e.values.first),
              ),
            ),
            ListTile(
              title: const Text('Deeplink Launcher'),
              onTap: _navigateToDeeplinkLauncher,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToNetworkMonitoring() {
    _navigateTo(const ANMonitoring());
  }

  void _navigateToStorageMonitoring() {
    _navigateTo(const ASMonitoring());
  }


  void _navigateToDeeplinkLauncher() {
    _navigateTo(const DeeplinkLauncherPage());
  }

  void _navigateTo(Widget page) {
    Navigation.push(
      context: context,
      page: page,
    );
  }
}
