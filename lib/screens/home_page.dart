import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'profile.dart';
import 'search.dart';
import 'map.dart';

const Color primary = Color(0xFF1156AC);

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4.0),
              child: Row(
                children: [
                  Text(
                    "WORKRATE",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontFamily: 'RobotoMono',
                      fontSize: 27,
                      letterSpacing: 2,
                      color: primary,
                    ),
                  ),
                  Spacer(),
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.search, color: primary, size: 28),
                      onPressed: () {
                        print('Search button pressed - Using Builder');
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SearchScreen(),
                          ),
                        ).then((_) {
                          print('Returned from SearchScreen');
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black26,
              thickness: 1,
              height: 0,
              indent: 10,
              endIndent: 10,
            ),

            // Example Post/Profile Card
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Card(
                color: Color(0xFF23272C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, size: 32, color: Colors.white),
                          ),
                          SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "JOHN SMITH",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17,
                                  fontFamily: 'RobotoMono',
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                "TURBO D.O.O.",
                                style: TextStyle(
                                  color: primary,
                                  fontFamily: "RobotoMono",
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 17),
                      Text(
                        "Lorem ipsum ahsdasdh asduh asoudh9 asdoijsha dasud asdasas sa sauas sadas  das ...Click for more",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.5,
                          fontFamily: "RobotoMono",
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 140,
                        width: double.infinity,
                        color: Colors.white10,
                        child: Center(child: Icon(Icons.image, color: Colors.white24, size: 52)),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Icon(Icons.thumb_up_alt_outlined, size: 22, color: Colors.white54),
                          SizedBox(width: 4),
                          Text("1234", style: TextStyle(color: Colors.white, fontFamily: "RobotoMono")),
                          Spacer(),
                          Icon(Icons.chat_bubble_outline_rounded, size: 20, color: Colors.white54),
                          SizedBox(width: 4),
                          Text("12", style: TextStyle(color: Colors.white, fontFamily: "RobotoMono")),
                          SizedBox(width: 18),
                          Icon(Icons.share_rounded, size: 20, color: Colors.white54),
                          SizedBox(width: 4),
                          Text("321", style: TextStyle(color: Colors.white, fontFamily: "RobotoMono")),
                        ],
                      ),
                      SizedBox(height: 7),
                      Text(
                        "10 hours ago",
                        style: TextStyle(color: Colors.white38, fontSize: 12, fontFamily: "RobotoMono"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Remove Spacer() to avoid extra space below
          ],
        ),
      ),
      // Bottom Navigation Bar anchored flush to bottom
      bottomNavigationBar: Container(
  color: Color(0xFFEEEEEE),
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
  child: SizedBox(
    height: 80, // Lower this for a slimmer background; try 36 or 32 as needed
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _BottomSvgButton(svgPath: 'assets/icons/home.svg', label: "HOME", selected: true),
        _BottomSvgButton(svgPath: 'assets/icons/search.svg', label: "SEARCH"),
        _BottomSvgButton(svgPath: 'assets/icons/message.svg', label: "", isBig: true),
        _BottomSvgButton(svgPath: 'assets/icons/map.svg', label: "MAP"),
        _BottomSvgButton(svgPath: 'assets/icons/profile.svg', label: "PROFILE"),
      ],
    ),
  ),
),

    );
  }
}

class _BottomSvgButton extends StatelessWidget {
  final String svgPath;
  final String label;
  final bool selected;
  final bool isBig;

  const _BottomSvgButton({
    required this.svgPath,
    required this.label,
    this.selected = false,
    this.isBig = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == "PROFILE") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else if (label == "SEARCH") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchScreen()),
          );
        } else if (label == "MAP") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapScreen()),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        Transform.translate(
          offset: isBig ? const Offset(0, -30) : Offset.zero,
          child: SizedBox(
            width: isBig ? 100 : 36,
            height: isBig ? 100 : 36,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (selected)
                  SvgPicture.asset(
                    'assets/icons/backgroundselector.svg',
                    width: isBig ? 100 : 36,
                    height: isBig ? 100 : 36,
                  ),
                SvgPicture.asset(
                  svgPath,
                  width: isBig ? 80 : 26,
                  height: isBig ? 80 : 26,
                ),
              ],
            ),
          ),
        ),
        if (label.isNotEmpty)
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: primary,
              fontFamily: "RobotoMono",
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: selected ? 1.2 : 0.5,
            ),
          ),
        ],
      ),
    );
  }
}