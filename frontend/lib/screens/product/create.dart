import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stock_landy/layout/appbar.dart';
import 'package:stock_landy/layout/bottom_navigation_bar.dart';
import 'package:stock_landy/layout/drawer.dart';
import 'package:stock_landy/layout/handle_unauthorized_error.dart';
import 'package:stock_landy/layout/toast.dart';
import 'package:stock_landy/models/category.dart';
import 'package:stock_landy/screens/login.dart';
import 'package:stock_landy/screens/product/products.dart';
import 'package:stock_landy/services/category.dart';
import 'package:stock_landy/services/product.dart';

class CreateProduct extends StatefulWidget {
  const CreateProduct({Key? key}) : super(key: key);

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController quantityInStockController = TextEditingController();
  TextEditingController quantityMinController = TextEditingController();
  TextEditingController quantityMaxController = TextEditingController();

  Category selectedCategory = Category(categoryId: 0, categoryName: '');
  List<Category> categoryOptions = [];
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final CategoryService categoryService = CategoryService();
      final List<Category> categories = await categoryService.getAll();

      setState(() {
        categoryOptions = categories;
        selectedCategory = categoryOptions.isNotEmpty ? categoryOptions.first : Category(categoryId: 0, categoryName: '');
      });
    } catch (e) {
      print('Erreur lors du chargement des catégories : $e');

      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Login()));
        } else {
          // Gérer d'autres erreurs Dio
          // ...
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Créer un produit"),
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
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/logo.png", 
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Nom du produit
                  TextFormField(
                    controller: productNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom du produit',
                      
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ce champ est obligatoire';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Description du produit
                  TextFormField(
                    controller: productDescriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description du produit',
                      
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ce champ est obligatoire';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Catégorie
                  DropdownButtonFormField<Category>(
                    value: selectedCategory,
                    onChanged: (Category? value) {
                      setState(() {
                        selectedCategory = value ?? Category(categoryId: 0, categoryName: '');
                      });
                    },
                    items: categoryOptions
                        .map((Category category) =>
                            DropdownMenuItem<Category>(
                              value: category,
                              child: Text(category.categoryName),
                            ))
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: 'Catégorie',
                      
                    ),
                    validator: (value) {
                      if (value == null || value.categoryId == 0) {
                        return 'Veuillez sélectionner une catégorie';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Prix d'achat
                  TextFormField(
                    controller: purchasePriceController,
                    decoration: const InputDecoration(
                      labelText: 'Prix d\'achat',
                      
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ce champ est obligatoire';
                      }
                      if (!_isNumeric(value)) {
                        return 'Veuillez entrer une valeur numérique';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Prix de vente
                  TextFormField(
                    controller: sellingPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Prix de vente',
                      
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ce champ est obligatoire';
                      }
                      if (!_isNumeric(value)) {
                        return 'Veuillez entrer une valeur numérique';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Quantité en stock
                  TextFormField(
                    controller: quantityInStockController,
                    decoration: const InputDecoration(
                      labelText: 'Quantité en stock',
                      
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ce champ est obligatoire';
                      }
                      if (!_isNumeric(value)) {
                        return 'Veuillez entrer une valeur numérique';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Quantité minimale
                  TextFormField(
                    controller: quantityMinController,
                    decoration: const InputDecoration(
                      labelText: 'Seuil minimale',
                      
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ce champ est obligatoire';
                      }
                      if (!_isNumeric(value)) {
                        return 'Veuillez entrer une valeur numérique';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Quantité maximale
                  TextFormField(
                    controller: quantityMaxController,
                    decoration: const InputDecoration(
                      labelText: 'Seuil maximale',
                      
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ce champ est obligatoire';
                      }
                      if (!_isNumeric(value)) {
                        return 'Veuillez entrer une valeur numérique';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30.0),

                  // Bouton de sauvegarde
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        var product = {
                          "product_name": productNameController.text,
                          "product_description": productDescriptionController.text,
                          "category_id": selectedCategory.categoryId,
                          "purchase_price": double.parse(purchasePriceController.text),
                          "selling_price": double.parse(sellingPriceController.text),
                          "quantity_in_stock": int.parse(quantityInStockController.text),
                          "quantity_min": int.parse(quantityMinController.text),
                          "quantity_max": int.parse(quantityMaxController.text),
                        };

                        await _saveProduct(product);
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
                            'Ajouter',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      )
    );
  }

  Future<void> _saveProduct(var product) async {
    setState(() {
      isLoading = true;
    });

    try {
      final ProductService productService = ProductService();

      await productService.create(product);

      _resetForm();

      showToast(context, "Produit créé avec succès");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ShowProducts()));
    } on DioException catch (e) {
      print(e);
      if (e.response!.statusCode == 401) {
        handleUnauthorizedError(context);
      } else
        print('Erreur lors de la sauvegarde du produit : $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool _isNumeric(String? value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  void _resetForm() {
    productNameController.clear();
    productDescriptionController.clear();
    purchasePriceController.clear();
    sellingPriceController.clear();
    quantityInStockController.clear();
    quantityMinController.clear();
    quantityMaxController.clear();

    setState(() {
      selectedCategory = categoryOptions.isNotEmpty ? categoryOptions.first : Category(categoryId: 0, categoryName: '');
    });
  }
}