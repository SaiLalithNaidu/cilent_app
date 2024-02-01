import 'package:flutter/material.dart';

import '../Widgets/drop_Down_Widget.dart';
import '../Widgets/multi_select_dropDown.dart';
import '../Widgets/products_card.dart';
import 'Product_Description_Sscreen.dart';

class Home_Page extends StatelessWidget {
  const Home_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 15,
                itemBuilder: (context, index) {
                  return const Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Chip(
                      label: Text('Catogery'),
                    ),
                  );
                }),
          ),
          Row(
            children: [
              Flexible(
                child: DropDownWidget(
                  items: const [
                    'Rs: low to high',
                    'Rs: height to low',
                  ],
                  dropBtnName: 'Sort',
                  onSelected: (selecetdValue) {},
                ),
              ),
              Flexible(
                  child: MultiSelectDropDown(
                items: [
                  'Items-1',
                  'Items-2',
                  'Items-3',
                  'Items-4',
                ],
                onSelctionChange: (selectedItems) {},
              )),
            ],
          ),
          Expanded(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ProductCard(
                      name: 'White Min',
                      imageUrl:
                          'https://aquadeals.in/admin/assets//images/product_imgs/20170208164856464013.jpg',
                      price: 1499,
                      offerTag: '45 % Off',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const ProductDescription()));
                      });
                }),
          )
        ],
      ),
    );
  }
}
