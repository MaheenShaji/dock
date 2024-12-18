import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: DraggableDock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
          ),
        ),
      ),
    );
  }
}

/// Draggable Dock with reordering functionality.
class DraggableDock extends StatefulWidget {
  final List<IconData> items;

  const DraggableDock({super.key, required this.items});

  @override
  _DraggableDockState createState() => _DraggableDockState();
}

class _DraggableDockState extends State<DraggableDock> {
  late List<IconData> _dockItems;

  @override
  void initState() {
    super.initState();
    _dockItems = List.from(widget.items); // Initialize dock items
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < _dockItems.length; i++) ...[
            if (i != 0) const SizedBox(width: 12), // Spacing between items
            DragTarget<int>(
              onAcceptWithDetails: (data) {
                setState(() {
                  final draggedItem = _dockItems.removeAt(data);
                  _dockItems.insert(i, draggedItem);
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Draggable<int>(
                  data: i,
                  feedback: Material(
                    color: Colors.transparent,
                    child: _buildDockItem(_dockItems[i], isDragging: true),
                  ),
                  childWhenDragging: const SizedBox.shrink(),
                  child: _buildDockItem(_dockItems[i]),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  /// Builds a dock item with optional drag appearance.
  Widget _buildDockItem(IconData icon, {bool isDragging = false}) {
    final Color containerColor =
        Colors.primaries[icon.hashCode % Colors.primaries.length];
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDragging ? containerColor.withOpacity(0.5) : containerColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white, size: 30),
    );
  }
}
