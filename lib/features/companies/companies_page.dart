import 'package:flutter/material.dart';
import '../qr/qr_page.dart';
import '../../core/widgets/side_menu.dart';
import 'widgets/companies_list.dart';
import 'widgets/top_bar.dart';
import 'widgets/company_search_bar.dart';
import 'widgets/empty_state.dart';

// Pantalla principal de empresas
class CompaniesPage extends StatefulWidget {
  final String token; // Token del usuario
  final Map<String, dynamic> user; // Datos del usuario

  const CompaniesPage({super.key, required this.token, required this.user});

  @override
  State<CompaniesPage> createState() => _CompaniesPageState();
}

class _CompaniesPageState extends State<CompaniesPage> {
  late List<Map<String, dynamic>> companies; // Lista completa de empresas
  late List<Map<String, dynamic>> filteredCompanies; // Lista filtrada por busqueda
  final searchController = TextEditingController(); // Controlador del campo de busqueda

  @override
  void initState() {
    super.initState();
    // Inicializa las listas con los datos del usuario
    companies = List<Map<String, dynamic>>.from(widget.user['companies'] ?? []);
    filteredCompanies = List.from(companies);
  }

  // Filtra las empresas por el texto ingresado
  void _filterCompanies(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredCompanies = companies
          .where((c) => (c['name'] as String).toLowerCase().contains(lowerQuery))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b1014),
      body: CustomSideMenu(
        token: widget.token,
        menuWidth: 280,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Logo superior centrado
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 110,
                  height: 150,
                ),
              ),
              const SizedBox(height: 5),

              // Titulo de la pantalla
              const TopBar(title: "Tus empresas"),
              const SizedBox(height: 10),

              // Barra de busqueda
              CompanySearchBar(
                controller: searchController,
                onChanged: _filterCompanies,
              ),
              const SizedBox(height: 20),

              // Lista de empresas o estado vacio
              Expanded(
                child: filteredCompanies.isEmpty
                    ? const EmptyState(message: "No tienes empresas registradas")
                    : CompaniesList(
                        companies: filteredCompanies,
                        onCompanyTap: (company) {
                          // Al tocar una empresa, abrir QRPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QRPage(
                                token: widget.token,
                                user: widget.user,
                                company: company,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
