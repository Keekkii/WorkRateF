import 'package:flutter/material.dart';

const Color kBackground = Color(0xFF18191A);
const Color primary = Color(0xFF1156AC);

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key); // Constructor required for routes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
              child: Row(
                children: [
                  Text(
                    "WORKRATE",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontFamily: 'RobotoMono',
                      fontSize: 27,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline_rounded, color: primary, size: 32),
                    onPressed: () {
                      // TODO: Implement new post/job action
                    },
                  ),
                ],
              ),
            ),
            // Divider (simulate underline in the app bar)
            Divider(color: Colors.white24, thickness: 0.9, height: 0),

            // Example Post Card
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
                      // Profile Row
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
            Spacer(),
            // Bottom Navigation Bar
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _BottomIconButton(icon: Icons.home, label: "HOME", selected: true),
                  _BottomIconButton(icon: Icons.add_box_rounded, label: "POST\nA JOB"),
                  _BottomIconButton(icon: Icons.chat_bubble_outline_rounded, label: "", isBig: true),
                  _BottomIconButton(icon: Icons.map, label: "MAP"),
                  _BottomIconButton(icon: Icons.person_outline_rounded, label: "PROFILE"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool isBig;

  const _BottomIconButton({
    required this.icon,
    required this.label,
    this.selected = false,
    this.isBig = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? primary : Colors.white54;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: isBig ? 54 : 36,
          height: isBig ? 54 : 36,
          child: Icon(icon, color: color, size: isBig ? 34 : 26),
        ),
        if (label.isNotEmpty)
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontFamily: "RobotoMono",
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: selected ? 1.2 : 0.5,
            ),
          ),
      ],
    );
  }
}
