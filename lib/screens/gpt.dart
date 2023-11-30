import 'package:flutter/material.dart';
import 'dart:math';

import 'package:foodrecipe/backend/repo.dart';

class GPT extends StatefulWidget {
  const GPT({super.key});

  @override
  State<GPT> createState() => _GPTState();
}

class _GPTState extends State<GPT> {
  late TextEditingController controller;
  late FocusNode focusNode;
  final List<String> inputTags = [];
  String response = '';

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            const Text(
              'Find the best recipe for cooking!',
              maxLines: 3,
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                    child: TextFormField(
                  autofocus: true,
                  autocorrect: true,
                  focusNode: focusNode,
                  cursorColor: Colors.black,
                  controller: controller,
                  onFieldSubmitted: (value) {
                    controller.clear();
                    setState(() {
                      inputTags.add(value);
                      focusNode.requestFocus();
                    });
                    print(inputTags);
                  },
                  decoration: const InputDecoration(
                      focusedBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.5),
                            bottomLeft: Radius.circular(5.5),
                          )),
                      enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: "Enter the ingredients you have...",
                      labelStyle: TextStyle(
                          color: Colors.black)),
                )),
                Container(
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(9),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          inputTags.add(controller.text);
                          focusNode.requestFocus();
                        });
                        print(inputTags);
                        // controller.clear();
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Wrap(children: [
                for (int i = 0; i < inputTags.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Chip(
                      backgroundColor:
                          Color((Random().nextDouble() * 0xFFFFFF).toInt())
                              .withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.5)),
                      onDeleted: () {
                        inputTags.remove(inputTags[i]);
                        print(inputTags[i]);
                        controller.clear();
                      },
                      label: Text(inputTags[i]),
                      deleteIcon: const Icon(
                        Icons.close,
                        size: 20,
                      ),
                    ),
                  )
              ]),
            ),
            Expanded(
                child: SizedBox(
              child: Center(
                  child: SingleChildScrollView(
                child: Text(
                  response,
                  style: const TextStyle(fontSize: 20),
                ),
              )),
            )),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton.icon(
                onPressed: () async {
                  setState(
                    () => response = "Thinking...",
                  );
                  String a = inputTags.join(', ');
                  print(a);
                  var temp = await HomePageRepo().askAI(a);
                  setState(() => response = temp);
                },
                icon: Icon(Icons.auto_awesome),
                label: Text("Create Recipe"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white),
              ),
            )
          ]),
        ),
      )),
    );
  }
}
