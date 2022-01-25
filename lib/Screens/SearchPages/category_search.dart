import 'package:flutter/material.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Screen%20Sizes/screen_size_page.dart';
import '../product_list.dart';

class CategorySearch extends StatelessWidget {
  CategorySearch({Key? key}) : super(key: key);

  String selectedCategory = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SizedBox(
        height: displayHeight(context)*1,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return categoryNameList.where((String option) {
                    selectedCategory=textEditingValue.text;
                    return option.toLowerCase().contains(textEditingValue.text);
                  });

                },
                onSelected: (String selection) {
                },
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor, // background
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductList(),
                      )
                  );
                },
                child: const Text("Search"))
          ],
        ),
      ),
    );
  }
}

