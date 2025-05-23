import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stock_landy/layout/toast.dart';
import 'package:stock_landy/layout/appbar.dart';
import 'package:stock_landy/layout/drawer.dart';
import 'package:stock_landy/services/supplier.dart';
import 'package:stock_landy/screens/supplier/suppliers.dart';
import 'package:stock_landy/layout/bottom_navigation_bar.dart';
import 'package:stock_landy/layout/handle_unauthorized_error.dart';

class CreateSupplier extends StatefulWidget {
  const CreateSupplier({Key? key}) : super(key: key);

  @override
  State<CreateSupplier> createState() => _CreateSupplierState();
}

class _CreateSupplierState extends State<CreateSupplier> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final SupplierService _supplierService = SupplierService();

  Future<void> createSupplier(Map<String, dynamic> data) async {
    setState(() {
      isLoading = true;
    });
    try {
      await _supplierService.create(data);
      showToast(context, "Fournisseur enregistré avec succès");
      
      // Réinitialiser les champs
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      
      // Retourner à la liste des fournisseurs
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ShowSuppliers())
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        if (!mounted) return;
        handleUnauthorizedError(context);
      } else {
        showToast(context, "Une erreur est survenue lors de la création du fournisseur");
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est obligatoire';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer une adresse email valide';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est obligatoire';
    }
    final phoneRegex = RegExp(r'^\d{8,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Le numéro doit contenir au moins 8 chiffres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Nouveau Fournisseur"),
      drawer: const CustomAppDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(index: 0),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email du Fournisseur',
                          prefixIcon: Icon(Icons.email),
                          hintText: 'exemple@email.com',
                        ),
                        validator: validateEmail,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nom du Fournisseur',
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Nom complet',
                        ),
                        validator: (String? value) {
                          return value == null || value.isEmpty
                              ? 'Ce champ est obligatoire'
                              : null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Numéro du Fournisseur',
                          prefixIcon: Icon(Icons.phone),
                          hintText: '22959105267',
                        ),
                        validator: validatePhone,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: isLoading 
                    ? null 
                    : () async {
                        if (formKey.currentState!.validate()) {
                          await createSupplier({
                            "supplierName": nameController.text.trim(),
                            "email": emailController.text.trim(),
                            "phone": phoneController.text.trim(),
                          });
                        }
                      },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF02BB02),
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(double.infinity, 50),
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Ajouter',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
