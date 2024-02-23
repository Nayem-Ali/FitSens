import 'package:http/http.dart' as http;
import 'data_model.dart';

class PostController {
  Future<FoodModel?> getFoods(String q) async {
    var response =
    await http.get(Uri.parse("https://api.edamam.com/search?q=$q&app_id=5834cb40&app_key"
        "=5d93df1f51d88e0a4990cf9297afb2c1&from=0&to=100&calories=0-260&health=alcohol-free"
        ""));
    if (response.statusCode == 200) {
      var data = response.body;
      return foodModelFromJson(data);
    }
  }
}
