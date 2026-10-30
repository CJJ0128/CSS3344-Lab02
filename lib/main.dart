
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const StudentProfileScreen(),
    );
  }
}

// Main Screen
class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {

  // Selected values
  DateTime _selectedDate = DateTime.now();
  String _selectedRole = 'Student';

  final List<String> roles = [
    'Student',
    'Developer',
    'Designer',
  ];

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        centerTitle: true,
        backgroundColor:
        Theme.of(context).colorScheme.primaryContainer,
      ),

      // Exercise 2.2: Orientation Builder
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView()
              : _buildLandscapeView();
        },
      ),
    );
  }

  // Portrait Mode
  Widget _buildPortraitView() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const StudentDetailsSection(
          name: 'CHIA JONG JIN',
          studentId: 'BCS24020059',
          quote: '"Keep pushing forward and never give up!"',
          imagePath: 'assets/my_photo.jpeg',
        ),
        const SizedBox(height: 20),
        const TitleSection(
          name: 'Location Details',
          location: 'Sibu, Sarawak, Malaysia',
          starCount: 41,
        ),
        const SizedBox(height: 20),
        _buildPickerSection(),
      ],
    );
  }

  // Landscape Mode
  Widget _buildLandscapeView() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: const StudentDetailsSection(
              name: 'CHIA JONG JIN',
              studentId: 'BCS24020059',
              quote: '"Keep pushing forward and never give up!"',
              imagePath: 'assets/my_photo.jpeg',
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const TitleSection(
                name: 'Location Details',
                location: 'Sibu, Sarawak, Malaysia',
                starCount: 41,
              ),
              const SizedBox(height: 16),
              _buildPickerSection(),
            ],
          ),
        ),
      ],
    );
  }

  // All Four Pickers
  Widget _buildPickerSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Interactive Pickers',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // Selected Date
            Text(
              'Selected Date: ${formatDate(_selectedDate)}',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 12),

            // 1. Material Date Picker
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final DateTime? picked =
                  await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );

                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                child: const Text('Material Date Picker'),
              ),
            ),

            const SizedBox(height: 8),

            // 2. Cupertino Date Picker
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (_) => Container(
                      height: 240,
                      color: CupertinoColors.systemBackground
                          .resolveFrom(context),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: _selectedDate,
                        maximumDate: DateTime.now(),
                        minimumDate: DateTime(1950),
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() {
                            _selectedDate = newDate;
                          });
                        },
                      ),
                    ),
                  );
                },
                child: const Text('Cupertino Date Picker'),
              ),
            ),

            const Divider(height: 32),

            // Selected Role
            Text(
              'Selected Role: $_selectedRole',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 12),

            // 3. Material DropdownButton
            const Text(
              'Material Dropdown',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            DropdownButton<String>(
              value: _selectedRole,
              isExpanded: true,
              items: roles.map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            // 4. Cupertino Wheel Picker
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (_) => Container(
                      height: 200,
                      color: CupertinoColors.systemBackground
                          .resolveFrom(context),
                      child: CupertinoPicker(
                        itemExtent: 32,
                        scrollController:
                        FixedExtentScrollController(
                          initialItem: roles.indexOf(_selectedRole),
                        ),
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            _selectedRole = roles[index];
                          });
                        },
                        children: roles.map((role) {
                          return Center(
                            child: Text(role),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
                child: const Text('Cupertino Wheel Picker'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Student Details Section
class StudentDetailsSection extends StatelessWidget {
  final String name;
  final String studentId;
  final String quote;
  final String imagePath;

  const StudentDetailsSection({
    super.key,
    required this.name,
    required this.studentId,
    required this.quote,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.indigo,
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Student ID: $studentId',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const Divider(height: 32, thickness: 1),
            const Text(
              'Personal Life Goal / Quote:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              quote,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Exercise 2.1: Title Section
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          const SizedBox(width: 4),
          Text('$starCount'),
        ],
      ),
    );
  }
}
