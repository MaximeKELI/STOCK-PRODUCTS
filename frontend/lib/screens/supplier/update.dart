import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stock_landy/layout/toast.dart';
import 'package:stock_landy/layout/appbar.dart';
import 'package:stock_landy/layout/drawer.dart';
import 'package:stock_landy/models/supplier.dart';
import 'package:stock_landy/services/supplier.dart';
import 'package:stock_landy/screens/supplier/suppliers.dart';
import 'package:stock_landy/layout/bottom_navigation_bar.dart';
import 'package:stock_landy/layout/handle_unauthorized_error.dart';

class UpdateSupplier extends StatefulWidget {
  final Supplier supplier;

  const UpdateSupplier({Key? key, required this.supplier}) : super(key: key);

  @override
  State<UpdateSupplier> createState() => _UpdateSupplierState();
}

class _UpdateSupplierState extends State<UpdateSupplier> {
  late TextEditingController nameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  SupplierService supplierService = SupplierService();

  @override
  void initState() {
    super.initState();
    var supplier = widget.supplier;

    nameController.text = supplier.supplierName;
    emailController.text = supplier.email;
    phoneController.text = supplier.phone;
  }

  update(data) async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await supplierService.update(
          widget.supplier.supplierId.toString(), data);
      showToast(context, "Modification effectuée avec succès");
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ShowSuppliers()));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        handleUnauthorizedError(context);
      } else {
        showToast(context, "Une erreur est intervenue");
        print(e.message);
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Modifier le Fournisseur"),
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
                        ),
                        validator: (String? value) {
                          return value == null || value.isEmpty
                              ? 'Ce champ est obligatoire'
                              : null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nom du Fournisseur',
                          prefixIcon: Icon(Icons.person),
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
                        validator: (String? value) {
                          return value == null || value.isEmpty
                              ? 'Ce champ est obligatoire'
                              : null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await update({
                        "supplierName": nameController.text,
                        "email": emailController.text,
                        "phone": phoneController.text,
                        "supplierId": widget.supplier.supplierId
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF02BB02),
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Sauvegarder',
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
}
