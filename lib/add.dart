import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  String? selectedGroups;
  final CollectionReference donor =
      FirebaseFirestore.instance.collection('donor');

  void addDonor() {
    final data = {
      'name': donorName.text,
      'group': selectedGroups,
      'phone': donorPhone.text
    };
    donor.add(data);
  }

  TextEditingController donorName = TextEditingController();
  TextEditingController donorPhone = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Donors"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter name';
                    }
                    return null;
                  },
                  controller: donorName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Donor Name"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter phone number';
                    }
                    return null;
                  },
                  controller: donorPhone,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Phone Number")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please select your blood group';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        label: Text('Select Blood Group')),
                    items: bloodGroups
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (val) {
                      selectedGroups = val as String;
                    }),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addDonor();
                    Navigator.pop(context);
                  }
                },
                style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(
                        const Size(double.infinity, 50)),
                    backgroundColor: WidgetStateProperty.all(Colors.red)),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
