import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stock_landy/layout/toast.dart';
import 'package:stock_landy/layout/appbar.dart';
import 'package:stock_landy/layout/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stock_landy/models/supplier.dart';
import 'package:stock_landy/services/supplier.dart';
import 'package:stock_landy/screens/supplier/create.dart';
import 'package:stock_landy/screens/supplier/update.dart';
import 'package:stock_landy/layout/bottom_navigation_bar.dart';
import 'package:stock_landy/layout/handle_unauthorized_error.dart';


class ShowSuppliers extends StatefulWidget {
  const ShowSuppliers({super.key});

  @override
  State<ShowSuppliers> createState() => _ShowSuppliersState();
}

class _ShowSuppliersState extends State<ShowSuppliers> {
  late List<Supplier> suppliers = [];
  bool isLoading = true;

  final SupplierService _supplierService = SupplierService();

  Future<void> loadSuppliers() async {
    try {
      final response = await _supplierService.getAll();
      setState(() {
        suppliers = response;
        isLoading = false;
      });
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        handleUnauthorizedError(context);
      } else {
        showToast(context, "Erreur lors du chargement des fournisseurs");
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadSuppliers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Liste des fournisseurs"),
      drawer: const CustomAppDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(index: 0),
      body: suppliers.isNotEmpty
          ? ListView.builder(
              itemCount: suppliers.length,
              itemBuilder: (context, index) {
                final supplier = suppliers[index];
                return Card(
                  margin: const EdgeInsetsDirectional.all(5.0),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UpdateSupplier(supplier: supplier),
                        ),
                      ).then((_) => loadSuppliers()); // Recharger après modification
                    },
                    leading: const Icon(Icons.person),
                    title: Text(
                      supplier.supplierName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${supplier.email}'),
                        Text('Téléphone: ${supplier.phone}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.phone, color: Colors.green),
                          onPressed: () => _launch('tel:${supplier.phone}'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.email, color: Colors.blue),
                          onPressed: () => _launch('mailto:${supplier.email}'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chat, color: Colors.green),
                          onPressed: () => _launch('https://wa.me/${supplier.phone}'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.brown)
                  : const Text(
                      "Aucun fournisseur",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => const CreateSupplier(),
                ),
              )
              .then((_) => loadSuppliers()); // Recharger après création
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        showToast(context, "Impossible d'ouvrir : $url");
      }
    } catch (e) {
      showToast(context, "Erreur lors de l'ouverture de : $url");
    }
  }
}