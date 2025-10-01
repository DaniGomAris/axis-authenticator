import 'package:flutter/material.dart';
import '../../../qr/presentation/pages/qr_page.dart';

class HomePage extends StatelessWidget {
  final String token;
  final Map<String, dynamic> user;

  const HomePage({super.key, required this.token, required this.user});

  @override
  Widget build(BuildContext context) {
    final companies = user['companies'] as List<dynamic>;

    return Scaffold(
      backgroundColor: const Color(0xFF0b1014),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/images/logo.png',
                width: 110,
                height: 150,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Selecciona tu empresa',
                style: TextStyle(
                  color: Color(0xFF085f5d),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10), 
            Expanded(
              child: ListView.separated(
                itemCount: companies.length,
                separatorBuilder: (_, __) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final company = companies[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QRPage(
                            token: token,
                            user: user,
                            company: company,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFF25292e),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            company['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: Color(0xFF085f5d),
                            size: 22,
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
      ),
    );
  }
}
