import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:victu/objects/measurement_type.dart';
import 'package:victu/objects/product.dart';
import 'package:victu/objects/users/farmer_data.dart';
import 'package:victu/utils/database.dart';

class EditProducts extends StatefulWidget {
  final FarmerData farmerData;
  const EditProducts({super.key, required this.farmerData});

  @override
  State<EditProducts> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  List<TextEditingController> productNameControllers =
      List<TextEditingController>.empty(growable: true);
  List<TextEditingController> productPriceControllers =
      List<TextEditingController>.empty(growable: true);

  @override
  void initState() {
    initializeProducts();
    productNameControllers.add(TextEditingController());
    productPriceControllers.add(TextEditingController());
    super.initState();
  }

  void initializeProducts() {
    widget.farmerData.products.forEach((element) {
      productNameControllers.add(TextEditingController(text: element.title));
      productPriceControllers
          .add(TextEditingController(text: element.price.toString()));
    });
  }

  @override
  void dispose() {
    for (var element in productNameControllers) {
      element.dispose();
    }

    for (var element in productPriceControllers) {
      element.dispose();
    }

    super.dispose();
  }

  createProduct() {
    productNameControllers.add(TextEditingController());
    productPriceControllers.add(TextEditingController());
  }

  deleteProduct(TextEditingController productNameController,
      TextEditingController productPriceController) {
    setState(() {
      productNameControllers.remove(productNameController);
      productPriceControllers.remove(productPriceController);
    });
  }

  saveProducts() {
    List<Product> newProducts = <Product>[];

    for (int i = 0; i < productNameControllers.length; i++) {
      if (productNameControllers[i].text.isNotEmpty &&
          productPriceControllers[i].text.isNotEmpty) {
        newProducts.add(Product(productNameControllers[i].text,
            double.parse(productPriceControllers[i].text)));
      }
    }

    widget.farmerData.products = newProducts;
    widget.farmerData.update();
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
          "Edit Products",
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
                  "List your available products below.",
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
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: productNameControllers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductEntry(
                      productNameController:
                          productNameControllers.elementAt(index),
                      productPriceController:
                          productPriceControllers.elementAt(index),
                      deleteCallback: deleteProduct,
                    );
                  }),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      createProduct();
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
                    "Add Product",
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
                    saveProducts();
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

class ProductEntry extends StatelessWidget {
  const ProductEntry(
      {super.key,
      required this.productNameController,
      required this.productPriceController,
      required this.deleteCallback});

  final TextEditingController productNameController;
  final TextEditingController productPriceController;
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
                controller: productNameController,
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
                  hintText: "Produce",
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
                controller: productPriceController,
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
                  hintText: "Php.",
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
            width: 40,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: MaterialButton(
                onPressed: () {
                  deleteCallback(productNameController, productPriceController);
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
