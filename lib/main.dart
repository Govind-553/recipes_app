import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(RecipeApp());
}

class RecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interactive Recipes App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: RecipeScreen(),
    );
  }
}

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> with SingleTickerProviderStateMixin {
  PageController _pageController = PageController();
  bool _isLiked = false;
  late AnimationController _scaleController;

  final List<Map<String, String>> _recipes = [
    {
      "title": "Italian-Style Pasta",
      "image": "assets/images/pasta.png",
      "description": "A classic Italian pasta dish with creamy sauce, eggs, cheese, and pancetta."
    },
    {
      "title": "Avocado Toast",
      "image": "assets/images/avo_toast.png",
      "description": "A delicious and healthy toast topped with fresh avocado, eggs, and spices."
    },
    {
      "title": "Chocolate Cake",
      "image": "assets/images/choco_cake.png",
      "description": "A rich and moist chocolate cake, perfect for dessert lovers."
    },
  ];

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      lowerBound: 0.8,
      upperBound: 1.2,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _likeRecipe() {
    setState(() {
      _isLiked = !_isLiked;
    });

    if (_isLiked) {
      _scaleController.forward().then((_) => _scaleController.reverse());
    }
  }

  void _showDetails(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _recipes[index]["title"]!,
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepOrange),
              ),
              SizedBox(height: 10),
              Text(
                _recipes[index]["description"]!,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(fontSize: 18, color: Colors.grey[800]), // Dark grey color for better visibility
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Recipe Explorer 🍽️",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Swipeable PageView for Sliding Animation
          SizedBox(
            height: 400,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _isLiked = false;
                });
              },
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () => _showDetails(index),
                  child: Column(
                    children: [
                      // Image with Animated Fade Effect
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: ClipRRect(
                          key: ValueKey(index),
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            _recipes[index]["image"]!,
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Recipe Title with Animated Scale Effect
                      ScaleTransition(
                        scale: _scaleController,
                        child: Text(
                          _recipes[index]["title"]!,
                          style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 20),

          // Like Button with Heart Animation
          GestureDetector(
            onTap: _likeRecipe,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _isLiked ? Colors.red : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite,
                color: _isLiked ? Colors.white : Colors.black,
                size: 30,
              ),
            ),
          ),

          SizedBox(height: 20),

          // Swipe Instruction
          Text(
            "Swipe ➡️ to see next recipe",
            style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
