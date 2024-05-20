

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateDonor extends StatefulWidget {
  const UpdateDonor({super.key});

  @override
  State<UpdateDonor> createState() => _UpdateDonorState();
}

class _UpdateDonorState extends State<UpdateDonor> {
  final bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  String? selectedGroups;
  final CollectionReference donor =
      FirebaseFirestore.instance.collection('donor');

  TextEditingController donorName = TextEditingController();
  TextEditingController donorPhone = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> updateDonorFf(docId) async {
    
      final  data =  {
      'name': donorName.text,
      'group': selectedGroups,
      'phone': donorPhone.text,
    };

    donor.doc(docId).update(data);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    donorName.text = args['name'];
    donorPhone.text = args['phone'];
    selectedGroups = args['group'];
    final docId = args['id'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Donors"),
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
                      border: OutlineInputBorder(), label: Text("Donor Name")),
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
                      if (value == null || value.isEmpty) {
                        return 'Please select a blood group';
                      }
                      return null;
                    },
                    value: selectedGroups,
                    decoration: const InputDecoration(
                        label: Text('Select Blood Group')),
                    items: bloodGroups
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedGroups = val;
                      });
                    }),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateDonorFf(docId);
                    Navigator.pop(context);
                   
                  }
                 
                },
                style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(
                        const Size(double.infinity, 50)),
                    backgroundColor: WidgetStateProperty.all(Colors.red)),
                child: const Text(
                  "update",
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
