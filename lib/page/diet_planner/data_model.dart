// To parse this JSON data, do
//
//     final foodModel = foodModelFromJson(jsonString);

import 'dart:convert';

FoodModel foodModelFromJson(String str) => FoodModel.fromJson(json.decode(str));

String foodModelToJson(FoodModel data) => json.encode(data.toJson());

class FoodModel {
  String q;
  int from;
  int to;
  bool more;
  int count;
  List<Hit> hits;

  FoodModel({
    required this.q,
    required this.from,
    required this.to,
    required this.more,
    required this.count,
    required this.hits,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
    q: json["q"],
    from: json["from"],
    to: json["to"],
    more: json["more"],
    count: json["count"],
    hits: List<Hit>.from(json["hits"].map((x) => Hit.fromJson(x) ?? [])),
  );

  Map<String, dynamic> toJson() => {
    "q": q,
    "from": from,
    "to": to,
    "more": more,
    "count": count,
    "hits": List<dynamic>.from(hits.map((x) => x.toJson())),
  };
}

class Hit {
  Recipe recipe;

  Hit({
    required this.recipe,
  });

  factory Hit.fromJson(Map<String, dynamic> json) => Hit(
    recipe: Recipe.fromJson(json["recipe"]),
  );

  Map<String, dynamic> toJson() => {
    "recipe": recipe.toJson(),
  };
}

class Recipe {
  String uri;
  String label;
  String image;
  String source;
  String url;
  String shareAs;
  double recipeYield;
  List<String> dietLabels;
  List<String> healthLabels;
  List<String> cautions;
  List<String> ingredientLines;
  List<Ingredient> ingredients;
  double calories;
  double totalWeight;
  double totalTime;
  List<String> cuisineType;
  List<String> mealType;

  // List<String> dishType;
  Map<String, Total> totalNutrients;
  Map<String, Total> totalDaily;
  List<Digest> digest;

  Recipe({
    required this.uri,
    required this.label,
    required this.image,
    required this.source,
    required this.url,
    required this.shareAs,
    required this.recipeYield,
    required this.dietLabels,
    required this.healthLabels,
    required this.cautions,
    required this.ingredientLines,
    required this.ingredients,
    required this.calories,
    required this.totalWeight,
    required this.totalTime,
    required this.cuisineType,
    required this.mealType,
    // required this.dishType,
    required this.totalNutrients,
    required this.totalDaily,
    required this.digest,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    uri: json["uri"],
    label: json["label"],
    image: json["image"],
    source: json["source"],
    url: json["url"],
    shareAs: json["shareAs"],
    recipeYield: json["yield"],
    dietLabels: List<String>.from(json["dietLabels"].map((x) => x)),
    healthLabels: List<String>.from(json["healthLabels"].map((x) => x)),
    cautions: List<String>.from(json["cautions"].map((x) => x)),
    ingredientLines: List<String>.from(json["ingredientLines"].map((x) => x ?? [])),
    ingredients:
    List<Ingredient>.from(json["ingredients"].map((x) => Ingredient.fromJson(x ?? []))),
    calories: json["calories"]?.toDouble(),
    totalWeight: json["totalWeight"]?.toDouble(),
    totalTime: json["totalTime"],
    cuisineType: List<String>.from(json["cuisineType"].map((x) => x)),
    mealType: List<String>.from(json["mealType"].map((x) => x)),
    // dishType: List<String>.from(json["dishType"].map((x) => x)),
    totalNutrients: Map.from(json["totalNutrients"])
        .map((k, v) => MapEntry<String, Total>(k, Total.fromJson(v))),
    totalDaily: Map.from(json["totalDaily"])
        .map((k, v) => MapEntry<String, Total>(k, Total.fromJson(v))),
    digest: List<Digest>.from(json["digest"].map((x) => Digest.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "uri": uri,
    "label": label,
    "image": image,
    "source": source,
    "url": url,
    "shareAs": shareAs,
    "yield": recipeYield,
    "dietLabels": List<dynamic>.from(dietLabels.map((x) => x)),
    "healthLabels": List<dynamic>.from(healthLabels.map((x) => x)),
    "cautions": List<dynamic>.from(cautions.map((x) => x)),
    "ingredientLines": List<dynamic>.from(ingredientLines.map((x) => x)),
    "ingredients": List<dynamic>.from(ingredients.map((x) => x.toJson())),
    "calories": calories,
    "totalWeight": totalWeight,
    "totalTime": totalTime,
    "cuisineType": List<dynamic>.from(cuisineType.map((x) => x)),
    "mealType": List<dynamic>.from(mealType.map((x) => x)),
    // "dishType": List<dynamic>.from(dishType!.map((x) => x)),
    "totalNutrients":
    Map.from(totalNutrients).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "totalDaily": Map.from(totalDaily).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "digest": List<dynamic>.from(digest.map((x) => x.toJson())),
  };
}

class Digest {
  String label;
  String tag;
  String? schemaOrgTag;
  double total;
  bool hasRdi;
  double daily;
  Unit unit;
  List<Digest>? sub;

  Digest({
    required this.label,
    required this.tag,
    required this.schemaOrgTag,
    required this.total,
    required this.hasRdi,
    required this.daily,
    required this.unit,
    this.sub,
  });

  factory Digest.fromJson(Map<String, dynamic> json) => Digest(
    label: json["label"],
    tag: json["tag"],
    schemaOrgTag: json["schemaOrgTag"],
    total: json["total"]?.toDouble(),
    hasRdi: json["hasRDI"],
    daily: json["daily"]?.toDouble(),
    unit: unitValues.map[json["unit"]]!,
    sub: json["sub"] == null
        ? []
        : List<Digest>.from(json["sub"]!.map((x) => Digest.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "tag": tag,
    "schemaOrgTag": schemaOrgTag,
    "total": total,
    "hasRDI": hasRdi,
    "daily": daily,
    "unit": unitValues.reverse[unit],
    "sub": sub == null ? [] : List<dynamic>.from(sub!.map((x) => x.toJson())),
  };
}

enum Unit { EMPTY, G, KCAL, MG, UNIT_G }

final unitValues = EnumValues(
    {"%": Unit.EMPTY, "g": Unit.G, "kcal": Unit.KCAL, "mg": Unit.MG, "µg": Unit.UNIT_G});

class Ingredient {
  String text;
  double quantity;
  String? measure;
  String food;
  double weight;
  String foodCategory;
  String foodId;
  String? image;

  Ingredient({
    required this.text,
    required this.quantity,
    required this.measure,
    required this.food,
    required this.weight,
    required this.foodCategory,
    required this.foodId,
    required this.image,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
    text: json["text"],
    quantity: json["quantity"]?.toDouble(),
    measure: json["measure"],
    food: json["food"],
    weight: json["weight"]?.toDouble(),
    foodCategory: json["foodCategory"] ?? "",
    foodId: json["foodId"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "quantity": quantity,
    "measure": measure,
    "food": food,
    "weight": weight,
    "foodCategory": foodCategory,
    "foodId": foodId,
    "image": image,
  };
}

class Total {
  String label;
  double quantity;
  Unit unit;

  Total({
    required this.label,
    required this.quantity,
    required this.unit,
  });

  factory Total.fromJson(Map<String, dynamic> json) => Total(
    label: json["label"],
    quantity: json["quantity"]?.toDouble(),
    unit: unitValues.map[json["unit"]]!,
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "quantity": quantity,
    "unit": unitValues.reverse[unit],
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
