import 'package:flutter/material.dart';
import '../widgets/search_field.dart';

class HostelMembersPage extends StatefulWidget {
  const HostelMembersPage({super.key});

  @override
  State<HostelMembersPage> createState() => _HostelMembersPageState();
}

class _HostelMembersPageState extends State<HostelMembersPage> {
  // ================= DARK COLORS =================
  static const Color dark1 = Color(0xFF1a1a2e);
  static const Color dark2 = Color(0xFF16213e);
  static const Color dark3 = Color(0xFF0f3460);
  static const Color purpleDark = Color(0xFF533483);
  static const Color neon = Color(0xFF00FFF5);

  String _viewBy = 'Hostel Wise';
  String _selectedHostel = 'SSJC-ADARSA CAMPUS';
  String _selectedBranch = 'ADARSA';
  String _query = '';

  final List<String> _viewOptions = [
    'Hostel Wise',
    'Floor Wise',
    'Room Wise',
    'Batch Wise',
  ];

  final List<String> _hostels = ['SSJC-ADARSA CAMPUS', 'SSJC-NEET CAMPUS'];

  final List<String> _branches = ['ADARSA', 'NEET', 'MAINS'];

  final List<Map<String, String>> _members = [
    {'admNo': '240018', 'name': 'PATHAN AFFAN', 'room': '101'},
    {'admNo': '240025', 'name': 'KUMAR SAI', 'room': '101'},
    {'admNo': '240040', 'name': 'TEJA REDDY', 'room': '102'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = _members.where((m) {
      return m['name']!.toLowerCase().contains(_query.toLowerCase()) ||
          m['admNo']!.contains(_query) ||
          m['room']!.contains(_query);
    }).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Hostel Members",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
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

            // ================= FILTER CARD =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withOpacity(0.18)
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark
                        ? Colors.white24
                        : Theme.of(context).dividerColor,
                  ),
                ),
                child: Column(
                  children: [
                    _dropdown(
                      context,
                      "View By",
                      _viewBy,
                      _viewOptions,
                      (v) => setState(() => _viewBy = v!),
                    ),
                    const SizedBox(height: 10),
                    _dropdown(
                      context,
                      "Hostel",
                      _selectedHostel,
                      _hostels,
                      (v) => setState(() => _selectedHostel = v!),
                    ),
                    const SizedBox(height: 10),
                    _dropdown(
                      context,
                      "Branch",
                      _selectedBranch,
                      _branches,
                      (v) => setState(() => _selectedBranch = v!),
                    ),
                    const SizedBox(height: 14),

                    // ================= ACTION BUTTONS =================
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Get Students (Demo Action)'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.search),
                            label: const Text('Get Students'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark
                                  ? const Color(0xFF6C63FF)
                                  : Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Assign Students (Demo Action)'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Assign Students'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark
                                  ? const Color(0xFF1ABC9C)
                                  : Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ================= TITLE =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hostel Members List',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ================= LIST + SEARCH =================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white12
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark
                              ? Colors.white24
                              : Theme.of(context).dividerColor,
                        ),
                      ),
                      child: SearchField(
                        hint: 'Search by Name, Adm No, Room',
                        hintStyle: TextStyle(
                          color:
                              isDark ? const Color(0xFFB5C7E8) : Colors.black54,
                        ),
                        textColor: isDark ? Colors.white : Colors.black,
                        iconColor: isDark ? neon : Colors.black54,
                        onChanged: (v) => setState(() => _query = v),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final m = filtered[i];

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
                                  color: isDark
                                      ? neon.withOpacity(0.22)
                                      : Colors.black12,
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
                                      m['name']!,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Adm No: ${m['admNo']}",
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
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: neon,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    m['room']!,
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
            ),
          ],
        ),
      ),
    );
  }

  // ================= DROPDOWN =================
  Widget _dropdown(
    BuildContext context,
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.06)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.white24 : Theme.of(context).dividerColor,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: isDark ? dark3 : Theme.of(context).cardColor,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: neon),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
          items: items
              .map(
                (o) => DropdownMenuItem(
                  value: o,
                  child: Text(o),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
