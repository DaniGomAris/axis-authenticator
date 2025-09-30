import 'package:flutter/material.dart';
import 'qr_page.dart'; 

class HomePage extends StatelessWidget {
  final String token;
  final Map<String, dynamic> user;

  const HomePage({super.key, required this.token, required this.user});

  @override
  Widget build(BuildContext context) {
    final companies = user['companies'] as List<dynamic>;
    final userId = user['_id'];

    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona tu empresa')),
      body: ListView.builder(
        itemCount: companies.length,
        itemBuilder: (context, index) {
          final company = companies[index];
          return ListTile(
            title: Text(company['name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QRPage(
                    token: token,
                    userId: userId,
                    company: company,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
