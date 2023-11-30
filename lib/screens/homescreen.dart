import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodrecipe/screens/gpt.dart';
import 'package:foodrecipe/screens/recipescreen.dart';
import 'package:foodrecipe/screens/searchscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';
import '../model/recipemodel.dart';
import '../widgets/home.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<bool> optionSelected = [true, false, false];

  List<Model> list1 = <Model>[];

  List<Model> list2 = <Model>[];

  String? text;

  final url2 =
      "https://api.edamam.com/search?q=biryani&app_id={YOUR_ID}&app_key={YOUR_KEY}&from=0&to=100&calories=591-722&health=alcohol-free&health=pork-free&excluded=yogurt&excluded=greek+yogurt";

  final url1 =
      "https://api.edamam.com/search?q=bhaji&cuisineType=Indian&mealType=lunch&app_id={YOUR_ID}&app_key={YOUR_KEY}&from=0&to=100&calories=591-722&health=alcohol-free&health=pork-free&excluded=yogurt&excluded=greek+yogurt";

  getAPIdata1() async {
    var response = await http.get(Uri.parse(url1));
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
        list1.add(model);
      });
    });
  }

  getAPIdata2() async {
    var response1 = await http.get(Uri.parse(url2));
    Map json1 = jsonDecode(response1.body);
    // print(json);
    json1['hits'].forEach((e) {
      Model model = Model(
        url: e['recipe']['url'],
        image: e['recipe']['image'],
        source: e['recipe']['source'],
        label: e['recipe']['label'],
        calories: e['recipe']['calories'],
      );
      setState(() {
        list2.add(model);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // Call the API when the widget is inserted into the tree
    getAPIdata1();
    getAPIdata2();
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
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextTitleVariation1('Food Recipe App'),
                    buildTextSubTitleVariation1(
                        'What would you like to cook today?'),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 5.0),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: TextField(
                          onChanged: (v) {
                            text = v;
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchPage(
                                              search: text,
                                            )));
                              },
                              icon: Icon(Icons.search),
                            ),
                            hintText: 'Search',
                            hintStyle: GoogleFonts.notoSans(fontSize: 14.0),
                            border: InputBorder.none,
                            fillColor: Colors.grey.withOpacity(0.5),
                          ),
                        )),
                    SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child:
                    buildTextTitleVariation2('Today\'s Fresh Recipes', false),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                height: 350,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: buildRecipes(),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    buildTextTitleVariation2('Recommended for Lunch', false),
                    // SizedBox(
                    //   width: 8,
                    // ),
                    // buildTextTitleVariation2('Food', true),
                  ],
                ),
              ),
              Container(
                height: 190,
                child: PageView(
                  physics: BouncingScrollPhysics(),
                  children: buildPopulars(),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("Try This"),
          icon: Icon(Icons.auto_awesome),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const GPT()));
          },
        ));
  }

  Widget option(String text, String image, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          optionSelected[index] = !optionSelected[index];
        });
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: optionSelected[index] ? kPrimaryColor : Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [kBoxShadow],
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            SizedBox(
              height: 32,
              width: 32,
              child: Image.asset(
                image,
                color: optionSelected[index] ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              text,
              style: TextStyle(
                color: optionSelected[index] ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildRecipes() {
    return list2
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
          MaterialPageRoute(builder: (context) => WebPage(url: recipe.url)),
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

  List<Widget> buildPopulars() {
    return list1.map((model) => buildPopular(model)).toList();
  }

  Widget buildPopular(Model recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WebPage(url: recipe.url)),
        );
      },
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [kBoxShadow],
        ),
        child: Row(
          children: [
            Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(recipe.image.toString(), scale: 3),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRecipeTitle(recipe.label.toString()),
                    buildRecipeSubTitle(recipe.source.toString()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildCalories(
                            recipe.calories!.toStringAsFixed(0) + " Kcal"),
                        Icon(
                          Icons.favorite_border,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
