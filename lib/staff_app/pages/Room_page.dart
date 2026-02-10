import 'package:flutter/material.dart';
import '../widgets/search_field.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  String _query = '';
  String _viewBy = 'Floor Wise';

  // ================= DARK COLORS =================
  static const Color dark1 = Color(0xFF1a1a2e);
  static const Color dark2 = Color(0xFF16213e);
  static const Color dark3 = Color(0xFF0f3460);
  static const Color purpleDark = Color(0xFF533483);
  static const Color neon = Color(0xFF00FFF5);

  // ROOM DATA
  final List<Map<String, String>> _rooms = [
    {'room': '101', 'floor': 'Ground Floor', 'hostel': 'SSG EAMCET CAMPUS'},
    {'room': '102', 'floor': 'Ground Floor', 'hostel': 'SSG EAMCET CAMPUS'},
    {'room': '201', 'floor': 'First Floor', 'hostel': 'SSG EAMCET CAMPUS'},
    {'room': '202', 'floor': 'First Floor', 'hostel': 'SSG EAMCET CAMPUS'},
    {'room': '301', 'floor': 'Second Floor', 'hostel': 'SSG NEET & MAINS'},
  ];

  // ================= FILTER SHEET =================
  void _chooseViewBy() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final options = ['Floor Wise', 'Hostel Wise', 'Room Wise'];

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    colors: [dark2, dark3],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : LinearGradient(
                    colors: [
                      Theme.of(context).cardColor,
                      Theme.of(context).colorScheme.surface,
                    ],
                  ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map(
                  (o) => RadioListTile<String>(
                    title: Text(
                      o,
                      style: TextStyle(
                        color:
                            isDark ? const Color(0xFFB5C7E8) : Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    activeColor: neon,
                    value: o,
                    groupValue: _viewBy,
                    onChanged: (v) {
                      setState(() => _viewBy = v!);
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = _rooms.where((r) {
      return r['room']!.contains(_query) ||
          r['floor']!.toLowerCase().contains(_query.toLowerCase()) ||
          r['hostel']!.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Rooms List",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: _chooseViewBy,
            icon:
                Icon(Icons.filter_list, color: isDark ? neon : Colors.black54),
            label: Text(
              _viewBy,
              style: TextStyle(
                color: isDark ? neon : Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ================= BODY =================
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  colors: [dark1, dark2, dark3, purpleDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).colorScheme.surface,
                  ],
                ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 95),

            // ================= SEARCH =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.12)
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? Colors.white24
                        : Theme.of(context).dividerColor,
                  ),
                ),
                child: SearchField(
                  hint: 'Search room / floor / hostel',
                  hintStyle: TextStyle(
                    color: isDark ? const Color(0xFFB5C7E8) : Colors.black54,
                  ),
                  textColor: isDark ? Colors.white : Colors.black,
                  iconColor: isDark ? neon : Colors.black54,
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ================= ROOM LIST =================
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  final r = filtered[i];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? LinearGradient(
                              colors: [
                                dark3.withOpacity(0.45),
                                purpleDark.withOpacity(0.45),
                              ],
                            )
                          : LinearGradient(
                              colors: [
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.08),
                                Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.08),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark
                            ? neon.withOpacity(0.35)
                            : Theme.of(context).dividerColor,
                        width: 1.3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              isDark ? neon.withOpacity(0.22) : Colors.black12,
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Room: ${r['room']}",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Floor: ${r['floor']}",
                              style: TextStyle(
                                color: isDark
                                    ? const Color(0xFFB5C7E8)
                                    : Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Hostel: ${r['hostel']}",
                              style: TextStyle(
                                color: isDark
                                    ? const Color(0xFFB5C7E8)
                                    : Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        // ROOM BADGE
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: neon,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            r['room']!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ================= FAB =================
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: isDark ? neon : Theme.of(context).colorScheme.primary,
        icon: Icon(Icons.add, color: isDark ? Colors.black : Colors.white),
        label: Text(
          "Add Room",
          style: TextStyle(
            color: isDark ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 12,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Add Room (Dummy Action)")),
          );
        },
      ),
    );
  }
}
