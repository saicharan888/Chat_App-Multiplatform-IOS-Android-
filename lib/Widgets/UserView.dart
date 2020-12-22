import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({
    Key key,
    this.name,
    this.email,
    this.image,
    this.firstName,
    this.lastName,
  }) : super(key: key);
  final String name, email, image,firstName,lastName;

  // UI to display user profile
  @override
  Widget build(BuildContext context) {
    double defaultSize = 10;
    return SizedBox(
      height: defaultSize * 32, // 240
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              height: defaultSize * 20, //150
              color: Colors.purple.shade900,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                image=="-1" ? Container(
                  margin: EdgeInsets.only(bottom: defaultSize), //10
                  height: defaultSize * 20, //140
                  width: defaultSize * 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueGrey,
                      //borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text(name.substring(0, 1),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 112,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w600)),
                ) :Container(
                  margin: EdgeInsets.only(bottom: defaultSize), //10
                  height: defaultSize * 23, //140
                  width: defaultSize * 23,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: defaultSize * 0.8, //8
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image:image == "-1" ? AssetImage('assets/images/sample.jpg') : NetworkImage(image),
                    ),
                  ),
                ),
                Text(
                  firstName+" "+lastName,
                  style: TextStyle(
                    fontSize: defaultSize * 2.8,
                    fontWeight:FontWeight.bold,// 22
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: defaultSize / 2), //5
                Text(
                  "Email: "+email,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8492A2),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}