import 'package:flutter/material.dart';
import 'package:luminous_e_buy/Constant_Values/lists.dart';
import 'package:luminous_e_buy/Services/masked_text.dart';

class NewAddressPopUp{
  NewAddress(Key formKey, BuildContext context, Function setState){
    final firstName = TextEditingController();
    final lastName = TextEditingController();
    final address = TextEditingController();
    final contactNumber = TextEditingController();
    final email = TextEditingController();
    final city = TextEditingController();
    final country = TextEditingController();
    final title = TextEditingController();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Center(
                            child: TextFormField(
                              controller: title,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Title',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Center(
                            child: TextFormField(
                              controller: firstName,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'First Name',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Center(
                            child: TextFormField(
                              controller: lastName,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Last Name',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Center(
                            child: TextFormField(
                              controller: email,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Email',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Center(
                            child: TextFormField(
                              inputFormatters: [
                                MaskedTextInputFormatter(
                                  mask: 'xxxxx-xxxxxx',
                                  separator: '-',
                                ),
                              ],
                              controller: contactNumber,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Contact Number',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Center(
                            child: TextFormField(
                              controller: address,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Address',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Center(
                            child: TextFormField(
                              obscureText: true,
                              controller: city,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'City',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Center(
                            child: TextFormField(
                              controller: country,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Country',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: const Text("Submitß"),
                            onPressed: () {
                              if(title.text.isNotEmpty && firstName.text.isNotEmpty && email.text.isNotEmpty && lastName.text.isNotEmpty && contactNumber.text.isNotEmpty && address.text.isNotEmpty && city.text.isNotEmpty && country.text.isNotEmpty){
                                addressList.add({
                                  "id": addressList.length, "title": title.text, "first_name": firstName.text, "last_name": lastName.text, "email": email.text, "address": address.text, "city": city.text, "country": country.text, "contact_number": contactNumber.text
                                });
                                print(addressList);
                                setState((){});
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      );
  }
}
