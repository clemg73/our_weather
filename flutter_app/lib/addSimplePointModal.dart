import 'package:flutter/material.dart';

class AddSimplePointModal extends StatefulWidget {
  const AddSimplePointModal({super.key});

  @override
  State<AddSimplePointModal> createState() => _AddSimplePointModalState();
}

class _AddSimplePointModalState extends State<AddSimplePointModal> {
  @override
  Widget build(BuildContext context) {
    const pointTypes = [
      {"name": "Orage", "url": "lib/assets/meteo1.png"},
      {"name": "Pluie", "url": "lib/assets/meteo2.png"},
      {"name": "Neige", "url": "lib/assets/meteo3.png"},
      {"name": "Nuageux", "url": "lib/assets/meteo4.png"},
      {"name": "Nuageux", "url": "lib/assets/meteo5.png"}
    ];

    return Container(
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Ajouter un relevé météo"),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.55,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: pointTypes.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      pointTypes[index]["url"] != ""
                          ? ClipOval(
                              child: Image.asset(
                                  pointTypes[index]["url"].toString(),
                                  width: 80))
                          : Container(),
                      Text(pointTypes[index]["name"].toString())
                    ],
                  ),
                ))
          ],
        ));
  }
}
