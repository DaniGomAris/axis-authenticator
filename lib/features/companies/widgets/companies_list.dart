import 'package:flutter/material.dart';
import 'company_card.dart';

// Lista de tarjetas de empresas
class CompaniesList extends StatelessWidget {
    final List<Map<String, dynamic>> companies; // Lista de empresas a mostrar
    final Function(Map<String, dynamic>) onCompanyTap; // Callback al tocar una empresa

    const CompaniesList({
        super.key,
        required this.companies,
        required this.onCompanyTap,
    });

    @override
    Widget build(BuildContext context) {
        // Si no hay empresas, retorna un widget vacio
        if (companies.isEmpty) {
        return const SizedBox();
        }

        // ListView con separador entre tarjetas
        return ListView.separated(
        itemCount: companies.length,
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
            final company = companies[index];

            return CompanyCard(
            company: company,
            onTap: () => onCompanyTap(company), // Ejecuta callback al tocar
            );
        },
        );
    }
}
