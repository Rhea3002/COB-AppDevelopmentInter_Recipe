import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodrecipe/screens/recipescreen.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';
import '../model/recipemodel.dart';
import '../widgets/home.dart';

class SearchPage extends StatefulWidget {
  final String? search;
  const SearchPage({this.search, super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Model> list = <Model>[];
  String? text;

  getAPIdata(search) async {
    final url =
      "https://api.edamam.com/search?q=$search&app_id=1e521479&app_key=14be059faa07d6e1b2b560b3bcb2aa42&from=0&to=100&calories=591-722&health=alcohol-free&health=pork-free&excluded=yogurt&excluded=greek+yogurt";
    var response = await http.get(Uri.parse(url));
    Map json = jsonDecode(response.body);
    // print(json);
    json['hits'].forEach((e) {
      Model model = Model(
        url: e['recipe']['url'],
        image: e['recipe']['image'],
        source: e['recipe']['source'],
        label: e['recipe']['label'],
        calories: e['recipe']['calories'],
      );
      setState(() {
        list.add(model);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // Call the API when the widget is inserted into the tree
    getAPIdata(widget.search);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(
          Icons.legend_toggle,
          color: Colors.black,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 3.0,
                        spreadRadius: 3.0,
                        offset: Offset(0.0, 3.0))
                  ],
                  color: Colors.white,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('assets/images/chef.png'),
                      fit: BoxFit.contain)),
            ),
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(child: Column(children: [
        Padding(padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 8,
            ),
            buildTextSubTitleVariation1(
                      'Search Results for ${widget.search}'),
                  SizedBox(
                    height: 20,),
            Container(
              height: 350,
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: buildRecipes(),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
        ],),)
      ],)),
    );
  }

  List<Widget> buildRecipes() {
    return list
        .asMap()
        .entries
        .map((entry) => buildRecipe(entry.value, entry.key))
        .toList();
  }

  Widget buildRecipe(Model recipe, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebPage(url: recipe.url)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [kBoxShadow],
        ),
        margin: EdgeInsets.only(
            right: 16, left: index == 0 ? 16 : 0, bottom: 16, top: 8),
        padding: EdgeInsets.all(16),
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: recipe.label.toString(),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(recipe.image.toString(), scale: 3),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            buildRecipeTitle(recipe.label.toString()),
            buildTextSubTitleVariation2(recipe.source.toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildCalories(recipe.calories!.toStringAsFixed(0) + " Kcal"),
                Icon(
                  Icons.favorite_border,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
