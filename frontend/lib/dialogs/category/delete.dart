import 'package:flutter/material.dart';
import 'package:stock_landy/layout/handle_unauthorized_error.dart';
import 'package:stock_landy/layout/toast.dart';
import 'package:stock_landy/screens/category/categories.dart';
import 'package:stock_landy/services/category.dart';
import 'package:dio/dio.dart';
class DeleteCategory extends StatefulWidget {
  final int categoryId;

  const DeleteCategory({Key? key, required this.categoryId}) : super(key: key);

  @override
  State<DeleteCategory> createState() => _DeleteCategoryState();
}

class _DeleteCategoryState extends State<DeleteCategory> {

   CategoryService categoryService = CategoryService();

  delete() async {
    try {
      await categoryService.delete(widget.categoryId.toString());
      showToast(context, "Suppression effectué avec succès");
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ShowCategories()));
    } on DioException catch (e) {
      print(e);
      if (e.response!.statusCode == 401) {
        handleUnauthorizedError(context);
      } else if (e.response != null) {
        showToast(context, "Une erreur est intervenue");
        print(e.response!.data);
      } else {
        showToast(context, "Une erreur est intervenue");
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifier une catégorie'),
      content: const Text(
        'Voulez-vous vraiment supprimé ?'
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Annuler'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Confirmer'),
          onPressed: () async {
            await delete();
          },
        ),
      ],
    );
  }
}
