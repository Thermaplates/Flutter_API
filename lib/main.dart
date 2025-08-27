import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Monster Model Class
class Monster {
  final String id;
  final String name;
  final String size;
  final String type;
  final String? challengeRating;
  final String? description;
  final int? strength;
  final int? dexterity;
  final int? constitution;
  final int? intelligence;
  final int? wisdom;
  final int? charisma;
  final List<dynamic>? actions;
  final List<dynamic>? images;

  Monster({
    required this.id,
    required this.name,
    required this.size,
    required this.type,
    this.challengeRating,
    this.description,
    this.strength,
    this.dexterity,
    this.constitution,
    this.intelligence,
    this.wisdom,
    this.charisma,
    this.actions,
    this.images,
  });

  factory Monster.fromJson(Map<String, dynamic> json) {
    return Monster(
      id:
          json['slug'] ??
          json['name']?.toString().toLowerCase().replaceAll(' ', '-') ??
          'unknown',
      name: json['name'] ?? 'Unknown',
      size: json['size'] ?? 'Unknown',
      type: json['type'] ?? 'Unknown',
      challengeRating: json['challenge_rating']?.toString(),
      description: json['desc'],
      strength: json['strength'],
      dexterity: json['dexterity'],
      constitution: json['constitution'],
      intelligence: json['intelligence'],
      wisdom: json['wisdom'],
      charisma: json['charisma'],
      actions: json['actions'],
      images: json['images'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'size': size,
      'type': type,
      'challenge_rating': challengeRating,
      'desc': description,
      'strength': strength,
      'dexterity': dexterity,
      'constitution': constitution,
      'intelligence': intelligence,
      'wisdom': wisdom,
      'charisma': charisma,
      'actions': actions,
      'images': images,
    };
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lovecraft Monsters',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        primaryColor: Color(0xFF8B4513), // Saddle Brown
        scaffoldBackgroundColor: Color(0xFF2C1810), // Dark brown background
        cardColor: Color(0xFF3E2723), // Dark brown cards
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF5D4037), // Dark brown app bar
          elevation: 8,
          shadowColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Color(0xFFD7CCC8), // Light beige text
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: Color(0xFFD7CCC8), // Light beige
            fontSize: 16,
            fontFamily: 'serif',
          ),
          bodyMedium: TextStyle(
            color: Color(0xFFD7CCC8), // Light beige
            fontSize: 14,
            fontFamily: 'serif',
          ),
          titleLarge: TextStyle(
            color: Color(0xFFD7CCC8), // Light beige
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
          ),
        ),
        cardTheme: CardTheme(
          color: Color(0xFF3E2723), // Dark brown
          elevation: 6,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Color(0xFF8B4513), // Saddle Brown border
              // ignore: physical-property-detected
              width: 2.0,
            ),
          ),
        ),
      ),
      home: MonsterListPage(),
    );
  }
}

class MonsterListPage extends StatefulWidget {
  @override
  _MonsterListPageState createState() => _MonsterListPageState();
}

class _MonsterListPageState extends State<MonsterListPage> {
  List<Monster> monsters = [];
  bool isLoading = true;
  bool isGridView = false;

  // Function to generate placeholder image URL based on monster name and type
  String _getMonsterImageUrl(String monsterName, [String? monsterType]) {
    final encodedName = Uri.encodeComponent(monsterName);

    // Choose different image styles based on monster type
    String style = 'avataaars';
    String backgroundColor = 'brown';
    String mouth = 'smile';

    if (monsterType != null) {
      monsterType = monsterType.toLowerCase();
      if (monsterType.contains('dragon')) {
        style = 'bottts';
        backgroundColor = 'red';
        mouth = 'serious';
      } else if (monsterType.contains('undead') ||
          monsterType.contains('skeleton') ||
          monsterType.contains('zombie')) {
        style = 'pixel-art';
        backgroundColor = 'gray';
        mouth = 'serious';
      } else if (monsterType.contains('beast') ||
          monsterType.contains('animal')) {
        style = 'avataaars';
        backgroundColor = 'green';
        mouth = 'smile';
      } else if (monsterType.contains('fiend') ||
          monsterType.contains('demon')) {
        style = 'bottts';
        backgroundColor = 'dark';
        mouth = 'serious';
      } else if (monsterType.contains('celestial') ||
          monsterType.contains('angel')) {
        style = 'avataaars';
        backgroundColor = 'lightblue';
        mouth = 'smile';
      }
    }

    return 'https://api.dicebear.com/7.x/$style/svg?seed=$encodedName&backgroundColor=$backgroundColor&mouth=$mouth&style=circle';
  }

  @override
  void initState() {
    super.initState();
    fetchMonsters();
  }

  Future<void> fetchMonsters() async {
    final url = Uri.parse('https://api.open5e.com/monsters/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        monsters =
            (jsonData['results'] as List)
                .map((monsterJson) => Monster.fromJson(monsterJson))
                .toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load monsters');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.auto_awesome, color: Color(0xFFFFD700)), // Gold star
            SizedBox(width: 8),
            Text('Bestiary of Eldritch Horrors'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isGridView ? Icons.list : Icons.grid_view,
              color: Color(0xFFFFD700),
            ),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
          Icon(Icons.auto_awesome, color: Color(0xFFFFD700)),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2C1810), // Dark brown
              Color(0xFF1B0F0A), // Even darker brown
            ],
          ),
        ),
        child:
            isLoading
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 50,
                        color: Color(0xFFFFD700),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Summoning creatures from the void...',
                        style: TextStyle(
                          color: Color(0xFFD7CCC8),
                          fontSize: 16,
                          fontFamily: 'serif',
                        ),
                      ),
                    ],
                  ),
                )
                : isGridView
                ? GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: monsters.length,
                  itemBuilder: (context, index) {
                    final monster = monsters[index];
                    return Container(
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF3E2723), Color(0xFF4E342E)],
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          MonsterDetailPage(monster: monster),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  // Monster Image
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(
                                        color: Color(0xFFFFD700),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(38),
                                      child: Image.network(
                                        _getMonsterImageUrl(
                                          monster.name,
                                          monster.type,
                                        ),
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFF8B4513),
                                              borderRadius:
                                                  BorderRadius.circular(38),
                                            ),
                                            child: Icon(
                                              Icons.auto_awesome,
                                              color: Color(0xFFFFD700),
                                              size: 40,
                                            ),
                                          );
                                        },
                                        loadingBuilder: (
                                          context,
                                          child,
                                          loadingProgress,
                                        ) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFF8B4513),
                                              borderRadius:
                                                  BorderRadius.circular(38),
                                            ),
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                color: Color(0xFFFFD700),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  // Monster Name
                                  Text(
                                    monster.name,
                                    style: TextStyle(
                                      color: Color(0xFFFFD700),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'serif',
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
                                  // Monster Type
                                  Text(
                                    '${monster.size} - ${monster.type}',
                                    style: TextStyle(
                                      color: Color(0xFFD7CCC8),
                                      fontSize: 12,
                                      fontFamily: 'serif',
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
                                  // Challenge Rating
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF8B4513),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'CR: ${monster.challengeRating ?? 'Unknown'}',
                                      style: TextStyle(
                                        color: Color(0xFFFFD700),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'serif',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
                : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: monsters.length,
                  itemBuilder: (context, index) {
                    final monster = monsters[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF3E2723), Color(0xFF4E342E)],
                            ),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            leading: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Color(0xFFFFD700),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: Image.network(
                                  _getMonsterImageUrl(
                                    monster.name,
                                    monster.type,
                                  ),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF8B4513),
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                      child: Icon(
                                        Icons.auto_awesome,
                                        color: Color(0xFFFFD700),
                                        size: 30,
                                      ),
                                    );
                                  },
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF8B4513),
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                          color: Color(0xFFFFD700),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            title: Text(
                              monster.name,
                              style: TextStyle(
                                color: Color(0xFFFFD700), // Gold text
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'serif',
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4),
                                Text(
                                  '${monster.size} - ${monster.type}',
                                  style: TextStyle(
                                    color: Color(0xFFD7CCC8),
                                    fontSize: 14,
                                    fontFamily: 'serif',
                                  ),
                                ),
                                SizedBox(height: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF8B4513),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'CR: ${monster.challengeRating ?? 'Unknown'}',
                                    style: TextStyle(
                                      color: Color(0xFFFFD700),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'serif',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xFFFFD700),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          MonsterDetailPage(monster: monster),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}

class MonsterDetailPage extends StatelessWidget {
  final Monster monster;

  MonsterDetailPage({required this.monster});

  // Function to generate placeholder image URL based on monster name and type
  String _getMonsterImageUrl(String monsterName, [String? monsterType]) {
    final encodedName = Uri.encodeComponent(monsterName);

    // Choose different image styles based on monster type
    String style = 'avataaars';
    String backgroundColor = 'brown';
    String mouth = 'smile';

    if (monsterType != null) {
      monsterType = monsterType.toLowerCase();
      if (monsterType.contains('dragon')) {
        style = 'bottts';
        backgroundColor = 'red';
        mouth = 'serious';
      } else if (monsterType.contains('undead') ||
          monsterType.contains('skeleton') ||
          monsterType.contains('zombie')) {
        style = 'pixel-art';
        backgroundColor = 'gray';
        mouth = 'serious';
      } else if (monsterType.contains('beast') ||
          monsterType.contains('animal')) {
        style = 'avataaars';
        backgroundColor = 'green';
        mouth = 'smile';
      } else if (monsterType.contains('fiend') ||
          monsterType.contains('demon')) {
        style = 'bottts';
        backgroundColor = 'dark';
        mouth = 'serious';
      } else if (monsterType.contains('celestial') ||
          monsterType.contains('angel')) {
        style = 'avataaars';
        backgroundColor = 'lightblue';
        mouth = 'smile';
      }
    }

    return 'https://api.dicebear.com/7.x/$style/svg?seed=$encodedName&backgroundColor=$backgroundColor&mouth=$mouth&style=circle';
  }

  String _formatValue(dynamic value) {
    if (value == null) return 'N/A';
    if (value is List) {
      return value.join(', ');
    }
    return value.toString();
  }

  Widget _buildActionsSection() {
    final actions = monster.actions;
    if (actions == null) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF3E2723),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFF8B4513)),
        ),
        child: Text(
          'No actions listed.',
          style: TextStyle(
            color: Color(0xFFD7CCC8),
            fontStyle: FontStyle.italic,
            fontFamily: 'serif',
          ),
        ),
      );
    }

    if (actions is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            actions.map<Widget>((action) {
              if (action is Map) {
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF3E2723),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFF8B4513)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.flash_on,
                            color: Color(0xFFFFD700),
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            action['name'] ?? 'Unknown Action',
                            style: TextStyle(
                              color: Color(0xFFFFD700),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'serif',
                            ),
                          ),
                        ],
                      ),
                      if (action['desc'] != null) ...[
                        SizedBox(height: 8),
                        Text(
                          action['desc'],
                          style: TextStyle(
                            color: Color(0xFFD7CCC8),
                            fontSize: 14,
                            fontFamily: 'serif',
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              } else {
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF3E2723),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFF8B4513)),
                  ),
                  child: Text(
                    action.toString(),
                    style: TextStyle(
                      color: Color(0xFFD7CCC8),
                      fontFamily: 'serif',
                    ),
                  ),
                );
              }
            }).toList(),
      );
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF3E2723),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF8B4513)),
      ),
      child: Text(
        actions.toString(),
        style: TextStyle(color: Color(0xFFD7CCC8), fontFamily: 'serif'),
      ),
    );
  }

  Widget _buildStatCard(String label, dynamic value) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF3E2723),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF8B4513)),
      ),
      child: Row(
        children: [
          Icon(Icons.fitness_center, color: Color(0xFFFFD700), size: 16),
          SizedBox(width: 8),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFFD700),
              fontFamily: 'serif',
            ),
          ),
          SizedBox(width: 8),
          Text(
            _formatValue(value),
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFD7CCC8),
              fontFamily: 'serif',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(monster.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFFFD700)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2C1810), Color(0xFF1B0F0A)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Monster Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF3E2723),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFFFD700), width: 2),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(color: Color(0xFFFFD700), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(57),
                        child: Image.network(
                          _getMonsterImageUrl(monster.name, monster.type),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF8B4513),
                                borderRadius: BorderRadius.circular(57),
                              ),
                              child: Icon(
                                Icons.auto_awesome,
                                color: Color(0xFFFFD700),
                                size: 60,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF8B4513),
                                borderRadius: BorderRadius.circular(57),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                  color: Color(0xFFFFD700),
                                  strokeWidth: 3,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      monster.name,
                      style: TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'serif',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${monster.size} - ${monster.type}',
                      style: TextStyle(
                        color: Color(0xFFD7CCC8),
                        fontSize: 16,
                        fontFamily: 'serif',
                      ),
                    ),
                    if (monster.challengeRating != null) ...[
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF8B4513),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Challenge Rating: ${monster.challengeRating}',
                          style: TextStyle(
                            color: Color(0xFFFFD700),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'serif',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Monster Images Section (if available)
              if (monster.images != null &&
                  monster.images is List &&
                  (monster.images as List).isNotEmpty) ...[
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF3E2723),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFF8B4513)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.image, color: Color(0xFFFFD700)),
                          SizedBox(width: 8),
                          Text(
                            'Monster Images',
                            style: TextStyle(
                              color: Color(0xFFFFD700),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: 'serif',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Container(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: (monster.images as List).length,
                          itemBuilder: (context, index) {
                            final imageUrl = monster.images![index];
                            return Container(
                              width: 150,
                              margin: EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Color(0xFFFFD700)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Color(0xFF8B4513),
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Color(0xFFFFD700),
                                        size: 50,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],

              // Description
              if (monster.description != null) ...[
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF3E2723),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFF8B4513)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.book, color: Color(0xFFFFD700)),
                          SizedBox(width: 8),
                          Text(
                            'Description',
                            style: TextStyle(
                              color: Color(0xFFFFD700),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: 'serif',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        monster.description!,
                        style: TextStyle(
                          color: Color(0xFFD7CCC8),
                          fontSize: 16,
                          fontFamily: 'serif',
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],

              // Stats Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF3E2723),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF8B4513)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.fitness_center, color: Color(0xFFFFD700)),
                        SizedBox(width: 8),
                        Text(
                          'Ability Scores',
                          style: TextStyle(
                            color: Color(0xFFFFD700),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'serif',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    _buildStatCard('Strength', monster.strength),
                    _buildStatCard('Dexterity', monster.dexterity),
                    _buildStatCard('Constitution', monster.constitution),
                    _buildStatCard('Intelligence', monster.intelligence),
                    _buildStatCard('Wisdom', monster.wisdom),
                    _buildStatCard('Charisma', monster.charisma),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Actions Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF3E2723),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF8B4513)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.flash_on, color: Color(0xFFFFD700)),
                        SizedBox(width: 8),
                        Text(
                          'Actions',
                          style: TextStyle(
                            color: Color(0xFFFFD700),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'serif',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    _buildActionsSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatRow extends StatelessWidget {
  final String label;
  final dynamic value;

  StatRow({required this.label, required this.value});

  String _formatValue(dynamic value) {
    if (value == null) return 'N/A';
    if (value is List) {
      return value.join(', ');
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFF3E2723),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xFF8B4513)),
      ),
      child: Row(
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFFD700),
              fontFamily: 'serif',
            ),
          ),
          SizedBox(width: 8),
          Text(
            _formatValue(value),
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFD7CCC8),
              fontFamily: 'serif',
            ),
          ),
        ],
      ),
    );
  }
}
