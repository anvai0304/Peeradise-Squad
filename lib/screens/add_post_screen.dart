// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';
// import 'package:instagram_flutter/utilis/colors.dart';

// class AddPostScreen extends StatefulWidget {
//   const AddPostScreen({Key? key}) : super(key: key);

//   @override
//   State<AddPostScreen> createState() => _AddPostScreenState();
// }

// class _AddPostScreenState extends State<AddPostScreen> {

//   _selectImage(BuildContext context) async {
//     return showDialog(context: context, builder: (context){
//       return SimpleDialog(
//         title: const Text(''),
//         children: [
          
//         ],
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // return Center(
//     //   child: IconButton(
//     //     icon: const Icon(Icons.upload),
//     //     onPressed: () {},
//     //   ),
//     // );
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: mobileBackgroundColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {},
//         ),
//         title: const Text('Post to'),
//         centerTitle: false,
//         actions: [
//           TextButton(
//             onPressed: () {},
//             child: const Text(
//               'Post',
//               style: TextStyle(
//                 color: Colors.blueAccent,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//             // mainAxisAlignment: MainAxisAlignment.spaceAround,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CircleAvatar(
//                 backgroundImage: NetworkImage(
//                     'https://live.staticflickr.com/7114/6912063224_1d33a92db1.jpg'),
//               ),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.45,
//                 child: TextField(
//                   decoration: const InputDecoration(
//                     hintText: 'Write a Caption..',
//                     border: InputBorder.none,
//                   ),
//                   maxLines: 8,
//                 ),
//               ),
//               SizedBox(
//                 height: 45,
//                 width: 45,
//                 child: AspectRatio(
//                   aspectRatio: 487 / 451,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: NetworkImage(
//                             'https://live.staticflickr.com/7114/6912063224_1d33a92db1.jpg'),
//                         fit: BoxFit.fill,
//                         alignment: FractionalOffset.topCenter,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const Divider(),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
