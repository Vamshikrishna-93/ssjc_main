import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentCalendar extends StatefulWidget {
  final bool showAppBar;

  const StudentCalendar({super.key, this.showAppBar = true});

  @override
  State<StudentCalendar> createState() => _StudentCalendarState();
}

class _StudentCalendarState extends State<StudentCalendar> {
  DateTime _currentMonth = DateTime.now();
  late Map<DateTime, List<CalendarEvent>> _events;

  @override
  void initState() {
    super.initState();
    _events = _generateMockEvents();
  }

  Map<DateTime, List<CalendarEvent>> _generateMockEvents() {
    final now = DateTime.now();
    final year = now.year;
    // Helper to generate a date in current month
    DateTime date(int month, int day) => DateTime(year, month, day);

    return {
      date(1, 1): [CalendarEvent("Holiday", Colors.blue)],
      date(1, 2): [CalendarEvent("Math Exam", Colors.blue)],
      date(1, 5): [CalendarEvent("Nature Day", Colors.blue)],
      date(1, 8): [
        CalendarEvent("Music Fest", Colors.blue),
        CalendarEvent("Speech", Colors.blue),
      ],
      date(1, 12): [CalendarEvent("Sports Meet", Colors.blue)],
      date(1, 15): [CalendarEvent("Art Fair", Colors.blue)],
      date(1, 20): [CalendarEvent("Plantation", Colors.blue)],
      date(1, 25): [CalendarEvent("Unit Test", Colors.blue)],
      date(1, 28): [
        CalendarEvent("Debate", Colors.blue),
        CalendarEvent("Dance", Colors.blue),
      ],
      // Add some for current month if not Jan
      DateTime(year, now.month, 5): [CalendarEvent("Monthly Test", Colors.red)],
      DateTime(year, now.month, 10): [CalendarEvent("Holiday", Colors.green)],
    };
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  void _prevMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  List<DateTime> _daysInMonth(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final daysBefore = first.weekday % 7;
    final firstToDisplay = first.subtract(Duration(days: daysBefore));
    final last = DateTime(month.year, month.month + 1, 0);
    final daysAfter = 7 - (last.weekday % 7) - 1;
    final lastToDisplay = last.add(
      Duration(days: daysAfter == -1 ? 6 : daysAfter),
    ); // Fix if saturday

    // Easier approach: Just display 6 weeks (42 days) to cover all cases
    // Or just generating accurate days for the month grid
    // Logic: finding the first Sunday associated with this month block
    var start = first.subtract(
      Duration(days: first.weekday == 7 ? 0 : first.weekday),
    ); // Start from Sunday

    return List.generate(42, (index) => start.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthName = DateFormat('MMMM yyyy').format(_currentMonth);

    // Days logic
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final daysInMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;

    // 0 = Sunday, 1 = Monday... 6 = Saturday (Standard US calendar)
    // DateTime.weekday returns 1=Mon...7=Sun.
    // We want 0=Sun. So map 7->0.
    final firstWeekday = firstDayOfMonth.weekday == 7
        ? 0
        : firstDayOfMonth.weekday;

    final totalSlots = firstWeekday + daysInMonth;
    final rows = (totalSlots / 7).ceil();

    final calendarContent = SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          child: const Icon(Icons.chevron_left, size: 20),
                        ),
                        onPressed: _prevMonth,
                      ),
                      Text(
                        monthName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          child: const Icon(Icons.chevron_right, size: 20),
                        ),
                        onPressed: _nextMonth,
                      ),
                    ],
                  ),
                ),

                // Weekdays Row
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
                        .map(
                          (d) => SizedBox(
                            width: 40,
                            child: Center(
                              child: Text(
                                d,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),

                // Calendar Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rows * 7,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1, // Square cells
                  ),
                  itemBuilder: (context, index) {
                    final dayOffset = index - firstWeekday;
                    if (dayOffset < 0 || dayOffset >= daysInMonth) {
                      return const SizedBox.shrink();
                    }

                    final currentDate = DateTime(
                      _currentMonth.year,
                      _currentMonth.month,
                      dayOffset + 1,
                    );
                    final dayNum = dayOffset + 1;

                    // Check for events
                    // Normalize date to ignore time for key lookup
                    final dateKey = DateTime(
                      currentDate.year,
                      currentDate.month,
                      currentDate.day,
                    );
                    final dayEvents = _events[dateKey] ?? [];
                    final hasEvents = dayEvents.isNotEmpty;

                    // Check if today
                    final now = DateTime.now();
                    final isToday =
                        currentDate.year == now.year &&
                        currentDate.month == now.month &&
                        currentDate.day == now.day;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: isToday
                              ? const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                )
                              : null,
                          child: Text(
                            "$dayNum",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: isToday
                                  ? Colors.white
                                  : theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Event Dots
                        if (hasEvents)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: dayEvents
                                .take(3)
                                .map(
                                  (e) => Container(
                                    width: 4,
                                    height: 4,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: e.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                                .toList(),
                          )
                        else
                          const SizedBox(
                            height: 4,
                          ), // Placeholder for alignment
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Events List Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "EVENTS THIS MONTH",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // Events List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _getEventsForMonth().length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.withOpacity(0.1),
              indent: 16,
              endIndent: 16,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final entry = _getEventsForMonth()[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text(
                        "${entry.date.day}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: entry.event.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        entry.event.title,
                        style: TextStyle(
                          fontSize: 15,
                          color: theme.textTheme.bodyLarge?.color?.withOpacity(
                            0.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );

    // Return with or without Scaffold based on showAppBar
    if (widget.showAppBar) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text(
            "Student Calendar",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: theme.cardColor,
          foregroundColor: theme.textTheme.bodyLarge?.color,
        ),
        body: calendarContent,
      );
    } else {
      return calendarContent;
    }
  }

  // Helper to flatten events for the list
  List<EventEntry> _getEventsForMonth() {
    final List<EventEntry> list = [];
    final days = _daysInMonth(
      _currentMonth,
    ); // Using the grid logic's month dates

    // Better: Iterate specific days of this month
    final lastDay = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;
    for (int i = 1; i <= lastDay; i++) {
      final d = DateTime(_currentMonth.year, _currentMonth.month, i);
      if (_events.containsKey(d)) {
        for (var e in _events[d]!) {
          list.add(EventEntry(d, e));
        }
      }
    }
    return list;
  }
}

class CalendarEvent {
  final String title;
  final Color color;
  CalendarEvent(this.title, this.color);
}

class EventEntry {
  final DateTime date;
  final CalendarEvent event;
  EventEntry(this.date, this.event);
}
