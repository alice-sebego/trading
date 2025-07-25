import 'package:flutter/material.dart';
import 'package:trading/Services/websocketchannel_service.dart';
import 'package:trading/Services/auth_service.dart';
import 'package:trading/Widgets/account_screen.dart'; 
import 'dart:convert';
import 'package:trading/Widgets/devise_card.dart';
import 'package:trading/Widgets/devise_detail_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  late final WebSocketChannelService _webSocketService;
  final AuthService _authService = AuthService(); 
  final Map<String, Map<String, dynamic>> _tradingData = {};
  final Map<int, String> _channelIdToSymbol = {};
  bool _isConnected = true;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _webSocketService = WebSocketChannelService();

    _webSocketService.addMessageHandler((message) {
      if (!_isMounted) return;
      final data = jsonDecode(message);

      if (data is Map && data['event'] == 'subscribed') {
        final symbol = data['symbol'];
        final chanId = data['chanId'];
        _channelIdToSymbol[chanId] = symbol;
      } else if (data is List && data.length > 1) {
        final chanId = data[0];
        final symbol = _channelIdToSymbol[chanId];
        if (symbol != null) {
          final parsedData = {
            "symbol": symbol,
            "lastPrice": (data[1][6] ?? 0.0).toDouble(),
            "dailyChange": (data[1][5] ?? 0.0).toDouble(),
          };
          setState(() {
            _tradingData[symbol] = parsedData;
          });
        }
      }
    });

    _webSocketService.listenToMessages();
    _webSocketService.connectionStatusStream.listen((isConnected) {
      if (_isMounted) {
        setState(() {
          _isConnected = isConnected;
        });
      }
    });
  }

  @override
  void dispose() {
    _isMounted = false;
    _webSocketService.close();
    super.dispose();
  }

  // Boîte de dialogue de confirmation
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Do you really want to logout ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
                _logout(); // Déconnexion réelle
              },
            ),
          ],
        );
      },
    );
  }

  // Déconnexion + snackbar
  Future<void> _logout() async {
    await _authService.signOut();
    if (context.mounted) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Déconnexion réussie'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 126, 126),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.white),
              tooltip: 'My Account',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const AccountScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              tooltip: 'Logout',
              onPressed: _confirmLogout,
            ),
        ],
      ),
      body: _isConnected
          ? ListView.builder(
              itemCount: _tradingData.length,
              itemBuilder: (context, index) {
                final symbol = _tradingData.keys.elementAt(index);
                final data = _tradingData[symbol]!;
                return DeviseCard(
                  symbol: data['symbol'],
                  lastPrice: data['lastPrice'],
                  dailyChange: data['dailyChange'],
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DeviseDetailPage(
                          symbol: data['symbol'],
                          lastPrice: data['lastPrice'],
                          dailyChange: data['dailyChange'],
                        ),
                      ),
                    );
                  },
                );
              },
            )
            : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 80, color: Colors.red),
                  const SizedBox(height: 20),
                  const Text(
                    'Failed connection',
                    style: TextStyle(fontSize: 24, color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text(
                      'Reconnexion',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _webSocketService.listenToMessages();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tentative de reconnexion...'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 9, 126, 126),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            )

    );
  }
}
