import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:victu/objects/ingredient.dart';
import 'package:victu/objects/meal.dart';
import 'package:victu/objects/measurement_type.dart';
import 'package:victu/utils/database.dart';

class CreateMeal extends StatefulWidget {
  const CreateMeal({super.key});

  @override
  State<CreateMeal> createState() => _CreateMealState();
}

class _CreateMealState extends State<CreateMeal> {
  TextEditingController dishNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageURLController = TextEditingController();
  List<TextEditingController> ingredientControllers =
      List<TextEditingController>.empty(growable: true);
  List<TextEditingController> quantityControllers =
      List<TextEditingController>.empty(growable: true);
  List<MeasurementType> measurementTypes =
      List<MeasurementType>.empty(growable: true);
  List<TextEditingController> recipeControllers =
      List<TextEditingController>.empty(growable: true);

  @override
  void initState() {
    ingredientControllers.add(TextEditingController());
    quantityControllers.add(TextEditingController());
    measurementTypes.add(MeasurementType.kg);
    recipeControllers.add(TextEditingController());
    super.initState();
  }

  @override
  void dispose() {
    for (var element in ingredientControllers) {
      element.dispose();
    }

    for (var element in quantityControllers) {
      element.dispose();
    }

    super.dispose();
  }

  createIngredient() {
    ingredientControllers.add(TextEditingController());
    quantityControllers.add(TextEditingController());
    measurementTypes.add(MeasurementType.kg);
  }

  createRecipe() {
    recipeControllers.add(TextEditingController());
  }

  changeMeasurement(MeasurementType measurementType, int index) {
    setState(() {
      measurementTypes[index] = measurementType;
    });
  }

  deleteIngredient(int index) {
    setState(() {
      ingredientControllers.removeAt(index);
      quantityControllers.removeAt(index);
      measurementTypes.removeAt(index);
    });
  }

  deleteRecipe(TextEditingController recipeController) {
    setState(() {
      recipeControllers.remove(recipeController);
    });
  }

  newMeal() {
    List<Ingredient> ingredients = [];

    ingredientControllers.asMap().forEach((key, value) {
      int quantity = int.parse(quantityControllers[key].text);
      ingredients.add(Ingredient(value.text, quantity, measurementTypes[key]));
    });

    List<String> recipe = recipeControllers.map((e) => e.text).toList();

    Meal meal = Meal(dishNameController.text, descriptionController.text,
        imageURLController.text, ingredients, recipe);

    meal.setId(saveMeal(meal));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffebebeb),
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff2b9685),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "Create a Dish",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 18,
            color: Color(0xffffffff),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              ///***If you have exported images you must have to copy those images in assets/images directory.
              const Image(
                image: NetworkImage(
                    "https://cdn1.iconfinder.com/data/icons/image-files-11/24/image_add_photo_image_files_color_shadow_f-256.png"),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(
                  "Enter the details of the dish below.",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: TextField(
                  controller: dishNameController,
                  obscureText: false,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Color(0xff2d9871), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Color(0xff2d9871), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Color(0xff2d9871), width: 1),
                    ),
                    hintText: "Dish Name",
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    filled: true,
                    fillColor: const Color(0xffffffff),
                    isDense: false,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    prefixIcon: const Icon(Icons.menu_book,
                        color: Color(0xff212435), size: 24),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: TextField(
                  controller: imageURLController,
                  obscureText: false,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Color(0xff2d9871), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Color(0xff2d9871), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Color(0xff2d9871), width: 1),
                    ),
                    hintText: "Image URL",
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    filled: true,
                    fillColor: const Color(0xffffffff),
                    isDense: false,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    prefixIcon: const Icon(Icons.image,
                        color: Color(0xff212435), size: 24),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: TextField(
                  controller: descriptionController,
                  textAlign: TextAlign.start,
                  maxLines: null,
                  minLines: 10,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Color(0xff2d9871), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Color(0xff2d9871), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Color(0xff2d9871), width: 1),
                    ),
                    label: const Text("Description"),
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    filled: true,
                    fillColor: const Color(0xffffffff),
                    isDense: false,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    prefixIcon: const Icon(Icons.description,
                        color: Color(0xff212435), size: 24),
                  ),
                ),
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: ingredientControllers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return IngredientEntry(
                      index: index,
                      ingredientController:
                          ingredientControllers.elementAt(index),
                      quantityController: quantityControllers.elementAt(index),
                      measurementType: measurementTypes.elementAt(index),
                      changeMeasurementCallback: changeMeasurement,
                      deleteCallback: deleteIngredient,
                    );
                  }),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      createIngredient();
                    });
                  },
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(10),
                  textColor: const Color(0xff2d9871),
                  height: 25,
                  minWidth: MediaQuery.of(context).size.width,
                  child: const Text(
                    "Add Ingredient",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: recipeControllers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RecipeEntry(
                      recipeController: recipeControllers.elementAt(index),
                      deleteCallback: deleteRecipe,
                    );
                  }),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      createRecipe();
                    });
                  },
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(10),
                  textColor: const Color(0xff2d9871),
                  height: 25,
                  minWidth: MediaQuery.of(context).size.width,
                  child: const Text(
                    "Add Recipe",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: MaterialButton(
                  onPressed: () {
                    newMeal();
                    Navigator.of(context).pop();
                  },
                  color: const Color(0xff2d9871),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(16),
                  textColor: const Color(0xffffffff),
                  height: 45,
                  minWidth: MediaQuery.of(context).size.width,
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IngredientEntry extends StatefulWidget {
  const IngredientEntry(
      {super.key,
      required this.index,
      required this.ingredientController,
      required this.quantityController,
      required this.measurementType,
      required this.changeMeasurementCallback,
      required this.deleteCallback});

  final int index;
  final TextEditingController ingredientController;
  final TextEditingController quantityController;
  final MeasurementType measurementType;
  final Function changeMeasurementCallback;
  final Function deleteCallback;

  @override
  State<IngredientEntry> createState() => _IngredientEntryState();
}

class _IngredientEntryState extends State<IngredientEntry> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: TextField(
                controller: widget.ingredientController,
                obscureText: false,
                textAlign: TextAlign.start,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
                decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  hintText: "Ingredient",
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  filled: true,
                  fillColor: const Color(0xffffffff),
                  isDense: false,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  prefixIcon: const Icon(Icons.menu,
                      color: Color(0xff212435), size: 24),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 55,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                controller: widget.quantityController,
                obscureText: false,
                textAlign: TextAlign.start,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
                decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  hintText: "Qty",
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  filled: true,
                  fillColor: const Color(0xffffffff),
                  isDense: false,
                  contentPadding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 70,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  border: Border.all(color: const Color(0xff2d9871), width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: widget.measurementType,
                    items: MeasurementType.values
                        .map((MeasurementType measurementType) {
                      return DropdownMenuItem<MeasurementType>(
                          value: measurementType,
                          child: Text(measurementType.name));
                    }).toList(),
                    style: const TextStyle(
                      color: Color(0xff000000),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        widget.changeMeasurementCallback(
                            newValue, widget.index);
                      });
                    },
                    elevation: 8,
                    isExpanded: true,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: MaterialButton(
                onPressed: () {
                  widget.deleteCallback(widget.index);
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                color: Colors.red,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(0),
                textColor: const Color(0xffffffff),
                height: 45,
                minWidth: MediaQuery.of(context).size.width,
                child: const Icon(Icons.delete),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeEntry extends StatelessWidget {
  const RecipeEntry(
      {super.key,
      required this.recipeController,
      required this.deleteCallback});

  final TextEditingController recipeController;
  final Function deleteCallback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: TextField(
                controller: recipeController,
                obscureText: false,
                textAlign: TextAlign.start,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
                decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  hintText: "Recipe",
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  filled: true,
                  fillColor: const Color(0xffffffff),
                  isDense: false,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  prefixIcon: const Icon(Icons.menu,
                      color: Color(0xff212435), size: 24),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: MaterialButton(
                onPressed: () {
                  deleteCallback(recipeController);
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                color: Colors.red,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(0),
                textColor: const Color(0xffffffff),
                height: 45,
                minWidth: MediaQuery.of(context).size.width,
                child: const Icon(Icons.delete),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
