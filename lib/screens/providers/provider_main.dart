import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:multiselect/multiselect.dart';

class ProviderMainScreen extends StatefulWidget {
  const ProviderMainScreen({super.key});

  @override
  State<ProviderMainScreen> createState() {
    return _ProviderMainScreenState();
  }
}

class _ProviderMainScreenState extends State<ProviderMainScreen> {
  bool _available = false;
  final _specialisation = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(children: [Text('History'), Text('')])),
      appBar: AppBar(
        title: const Text('Welcome XYZ'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //kyc status verfifcation pending
            Container(
              // decoration:
              //     BoxDecoration(borderRadius: ),
              color: const Color.fromARGB(117, 244, 67, 54),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your KYC is still pending',
                        style: TextStyle(fontSize: 16),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20)),
                          onPressed: () async {
                            final doc = await FirebaseFirestore.instance
                                .collection('professions')
                                .doc('professions')
                                .get();
                            setState(() {
                              _specialisation.clear();
                              _specialisation.addAll(doc.data()!['Carpenter']);
                            });
                          },
                          child: const Text('Complete it'))
                    ]),
              ),
            ),
            Column(children: [
              Text(
                'Your current ratings:',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                height: 10,
              ),
              RatingBarIndicator(
                rating: 2.5,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ),
            ]),
            Divider(
              color: Colors.black,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Availability status:',
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(
                  width: 20,
                ),
                Switch(
                    value: _available,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        _available = !_available;
                      });
                    })
              ],
            ),
            Divider(
              color: Colors.black,
              thickness: 1,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Select your specialization:',
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 20,
              ),
              DropDownMultiSelect(
                  selected_values_style: TextStyle(fontSize: 20),
                  options: _specialisation,
                  selectedValues: [],
                  onChanged: (selectedValues) {
                    print(selectedValues);
                  }),
            ]),

            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Basic Charges.', prefixText: 'Rs.'),
            ),

            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 50),
                    textStyle: TextStyle(fontSize: 20)),
                onPressed: () {},
                child: const Text('Update'))
          ],
        ),
      ),
    );
  }
}
