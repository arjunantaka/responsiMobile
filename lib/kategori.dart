import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'makanan.dart';

class kategoriPage extends StatefulWidget {
  final String category;

  kategoriPage({required this.category});

  @override
  _kategoriPageState createState() => _kategoriPageState();
}

class _kategoriPageState extends State<kategoriPage> {
  List<dynamic> _meals = [];

  @override
  void initState() {
    super.initState();
    _fetchMeals();
  }

  Future<void> _fetchMeals() async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.category}'));
    setState(() {
      _meals = json.decode(response.body)['meals'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kategori Makanan')),
      body: _meals.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _meals.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_meals[index]['strMeal']),
                  leading: Image.network(_meals[index]['strMealThumb']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            detailMeal(mealId: _meals[index]['idMeal']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
