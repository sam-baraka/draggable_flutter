// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreImageSwitcher extends StatefulWidget {
  const FirestoreImageSwitcher({super.key});

  @override
  _FirestoreImageSwitcherState createState() => _FirestoreImageSwitcherState();
}

class _FirestoreImageSwitcherState extends State<FirestoreImageSwitcher> {
  List<String> imageUrls = []; // List to store the image URLs
  int selectedImageIndex = -1; // Index of the currently selected image
  double imageWidth = 100.0; // Width of each image
  double imageHeight = 100.0; // Height of each image

  @override
  void initState() {
    super.initState();
    // Fetch the image URLs from Firestore
    fetchImageUrls();
  }

  void fetchImageUrls() async {
    // Replace 'your_collection_name' with the actual collection name in Firestore
    // Replace 'your_document_id' with the actual document ID
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('images')
        .doc('first_images')
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      List<dynamic> urls = data['links'];
      if (urls != null && urls is List) {
        setState(() {
          imageUrls = urls.cast<String>();
        });
      }
    }
  }

  void switchImages(int index1, int index2) {
    setState(() {
      // Swap the image URLs in the list
      String temp = imageUrls[index1];
      imageUrls[index1] = imageUrls[index2];
      imageUrls[index2] = temp;
    });
  }

  updateImages() {
    FirebaseFirestore.instance
        .collection('images')
        .doc('first_images')
        .update({'links': imageUrls});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Switcher'),
        actions: [
          IconButton(
            onPressed: () {
              updateImages();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Center(
        child: imageUrls.isEmpty
            ? const CircularProgressIndicator()
            : GridView.builder(
                itemCount: imageUrls.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return Draggable(
                    data: index,
                    feedback: SizedBox(
                      width: imageWidth,
                      height: imageHeight,
                      child: Image.network(
                        imageUrls[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: DragTarget(
                      builder: (context, List<int?> data, rejectedData) {
                        // Update the data type to List<int?>
                        return Container(
                          width: imageWidth,
                          height: imageHeight,
                          margin: const EdgeInsets.all(8.0),
                          color: selectedImageIndex == index
                              ? Colors.green // Highlight the selected image
                              : Colors.transparent,
                          child: Image.network(
                            imageUrls[index],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                      onAccept: (int data) {
                        // Switch the positions of the images when dropped
                        switchImages(data, index);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
