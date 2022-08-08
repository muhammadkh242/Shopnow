import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({Key? key, required this.imageUrl, required this.title})
      : super(key: key);

  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.all(8.0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                child: Image(
                  image: NetworkImage(imageUrl),
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 50,
                  width: 200,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                        fontFamily: 'Anton'),
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {

                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {

                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 30,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
