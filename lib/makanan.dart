import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class detailMeal extends StatefulWidget {
  final String mealId;

  detailMeal({required this.mealId});

  @override
  _detailMealState createState() => _detailMealState();
}

class _detailMealState extends State<detailMeal> {
  Map<String, dynamic>? _meal;

  @override
  void initState() {
    super.initState();
    _fetchMealDetail();
  }

  Future<void> _fetchMealDetail() async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.mealId}'));

    if (response.statusCode == 200) {
      setState(() {
        _meal = json.decode(response.body)['meals'][0];
      });
    } else {
      throw Exception('Failed to load meal detail');
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_meal?['strMeal'] ?? 'Detail Makanan')),
      body: _meal == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(_meal!['strMealThumb']),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      _meal!['strMeal'],
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Bahan-bahan:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(20, (index) {
                        final ingredient = _meal!['strIngredient${index + 1}'];
                        final measure = _meal!['strMeasure${index + 1}'];
                        if (ingredient != null && ingredient.isNotEmpty) {
                          return Text('$ingredient: $measure');
                        }
                        return SizedBox.shrink();
                      }),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final videoUrl = _meal!['strYoutube'];
                        _launchURL(videoUrl);
                      },
                      child: Text('Tonton Video Tutorial'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
