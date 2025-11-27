import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

class QuestionGameSource {

  Future<Map<String, dynamic>> questionsFromJSON(String source) async {
    const Map<String,List<String>> jsons = {
    'klasa_1' :['assets/json/klasa_1/klasa_1_1.json'],
    'klasa_2' :['assets/json/klasa_2/klasa_2_1.json'],
    'klasa_3' :['assets/json/klasa_3/klasa_3_1.json']
    };
    
   try{
    int howMuchFiles = jsons[source]!.length;
    int number = Random().nextInt(howMuchFiles) + 1;
    String jsonString = await rootBundle
        .loadString('assets/json/$source/${"${source}_$number"}.json');
    final Map<String, dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse;
   }catch(e){
    rethrow;
   }
  }
}
