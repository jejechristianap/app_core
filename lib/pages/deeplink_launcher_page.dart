import 'package:deeplink/deeplink.dart';
import 'package:flutter/material.dart';

class DeeplinkLauncherPage extends StatefulWidget {
  const DeeplinkLauncherPage({super.key});

  @override
  State<DeeplinkLauncherPage> createState() => _DeeplinkLauncherPageState();
}

class _DeeplinkLauncherPageState extends State<DeeplinkLauncherPage> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deeplink Launcher'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: _textEditingController,
            decoration:
                const InputDecoration(hintText: 'ex: agriaku://mitra/profile'),
            textInputAction: TextInputAction.next,
            onSubmitted: (val) => launchDeeplink(val),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => launchDeeplink(_textEditingController.value.text),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(double.maxFinite, 20),
            ),
            child: const Text('Launch'),
          ),
        ],
      ),
    );
  }

  void launchDeeplink(String url) {
    if (url.isEmpty) {
      var snackbar = const SnackBar(
        content: Text('Please insert a link'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return;
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
    DeeplinkHandler.handleUri(Uri.parse(url));
  }
}
