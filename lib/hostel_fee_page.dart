import 'package:flutter/material.dart';
import 'package:student_app/hostel_payment_page.dart';
import 'package:student_app/receipt_page.dart';
import 'package:student_app/services/fee_services_page.dart';
import 'package:student_app/studentdrawer.dart';
import 'package:student_app/theme_controller.dart';

enum SummaryType { danger, success, warning, info }

class HostelFeesPage extends StatefulWidget {
  const HostelFeesPage({super.key});

  @override
  State<HostelFeesPage> createState() => _HostelFeesPageState();
}

class _HostelFeesPageState extends State<HostelFeesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  dynamic _feeData;
  String? _errorMessage;

  // Safe accessors
  Map<String, dynamic> get _data =>
      _feeData is Map<String, dynamic> ? _feeData : {};

  List<dynamic> get _feeDetails =>
      _data['student_fee_details'] is List ? _data['student_fee_details'] : [];
  List<dynamic> get _paymentHistory =>
      _data['payment_history'] is List ? _data['payment_history'] : [];

  double get _totalFee {
    if (_data['total_fee'] != null)
      return double.tryParse(_data['total_fee'].toString()) ?? 0.0;
    return _feeDetails.fold(
      0.0,
      (sum, item) =>
          sum + (double.tryParse(item['total_amount']?.toString() ?? '0') ?? 0),
    );
  }

  double get _totalPaid {
    if (_data['total_paid'] != null)
      return double.tryParse(_data['total_paid'].toString()) ?? 0.0;
    return _feeDetails.fold(
      0.0,
      (sum, item) =>
          sum + (double.tryParse(item['paid_amount']?.toString() ?? '0') ?? 0),
    );
  }

  double get _totalDue {
    if (_data['total_due'] != null)
      return double.tryParse(_data['total_due'].toString()) ?? 0.0;
    return _feeDetails.fold(
      0.0,
      (sum, item) =>
          sum +
          (double.tryParse(item['balance_amount']?.toString() ?? '0') ?? 0),
    );
  }

  String get _branchName =>
      _data['branch_name']?.toString() ?? 'SSJC-ADARSA CAMPUS';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await HostelFeeService.getHostelFeeData();
      if (mounted) {
        setState(() {
          if (data is Map<String, dynamic> &&
              data.containsKey('data') &&
              data['data'] is Map) {
            _feeData = data['data'];
          } else {
            _feeData = data;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // BACKGROUND
  Color get bg => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF020617) // deep navy background
      : const Color(0xFFF8FAFC);

  // CARD SURFACE
  Color get card => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF020617) // seamless dark surface
      : Colors.white;

  // BORDER
  Color get border => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF334155) // slate border
      : const Color(0xFFE5E7EB);

  // PRIMARY TEXT (WHITE IN DARK MODE)
  Color get textPrimary => Theme.of(context).brightness == Brightness.dark
      ? Colors.white
      : const Color(0xFF020617);

  // SECONDARY TEXT (READABLE GRAY)
  Color get textSecondary => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFFCBD5E1)
      : const Color(0xFF6B7280);

  // MUTED / HINT TEXT
  Color get textMuted => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF94A3B8)
      : const Color(0xFF9CA3AF);

  // SUCCESS (PAID)
  Color get success => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF4ADE80)
      : const Color(0xFF16A34A);

  // WARNING (PENDING / ATTENTION)
  Color get warning => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFFFACC15)
      : const Color(0xFFF59E0B);

  // ERROR (DUE / OVERDUE)
  Color get danger => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFFF87171)
      : const Color(0xFFDC2626);

  // INFO / PRIMARY ACTION
  Color get primary => const Color(0xFF1677FF);

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentDrawerPage()),
              );
            },
          ),
        ),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeController.themeMode,
            builder: (context, themeMode, _) {
              final isDark = themeMode == ThemeMode.dark;
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: Material(
                  color: isDark
                      ? const Color(0xFF6366F1) // Light purple for dark mode
                      : const Color(0xFFEFEFEF), // Light gray for light mode
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () {
                      ThemeController.toggleTheme();
                    },
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: Icon(
                        isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        color: isDark
                            ? Colors.white
                            : const Color(
                                0xFF333333,
                              ), // Dark gray for moon icon
                        size: 20,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: $_errorMessage"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchData,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    const SizedBox(height: 16),
                    _summaryCard(
                      type: SummaryType.danger,
                      title: "Total Due Amount",
                      value: "₹${_totalDue.toStringAsFixed(0)}",
                      badgeText: "Immediate attention required",
                    ),
                    const SizedBox(height: 16),
                    _summaryCard(
                      type: SummaryType.success,
                      title: "Total Paid Amount",
                      value: "₹${_totalPaid.toStringAsFixed(0)}",
                      badgeText:
                          "${(_totalFee > 0 ? (_totalPaid / _totalFee * 100) : 0).toStringAsFixed(1)}% of total fee paid",
                    ),
                    const SizedBox(height: 16),
                    _summaryCard(
                      type: SummaryType.warning,
                      title: "Next Due Date",
                      value: _data['next_due_date']?.toString() ?? "Immediate Payment Required",
                      badgeText: _totalDue > 0 ? "Payment pending" : "No dues",
                    ),
                    const SizedBox(height: 16),
                    _summaryCard(
                      type: SummaryType.info,
                      title: "Payment Status",
                      value: _totalDue > 0 ? "Pending" : "Completed",
                      badgeText: "Total Fee: ₹${_totalFee.toStringAsFixed(0)}",
                    ),
                    const SizedBox(height: 28),
                    _tabsSection(),
                    const SizedBox(height: 28),
                    _feeSummaryCard(),
                    const SizedBox(height: 28),
                    _branchSummaryCard(),
                  ],
                ),
              ),
            ),
    );
  }

  // ================= HEADER =================

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.attach_money, size: 32),
                  const SizedBox(width: 12),

                  // TITLE + SUBTITLE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hostel Fees & Payments",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF6D5DD3),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Manage your hostel fees, track payments, and view receipts",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // BUTTON ROW (HORIZONTAL SCROLL – SAFE)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _outlinedBtn(
                      Icons.refresh,
                      "Refresh",
                      onPressed: _fetchData,
                    ),
                    const SizedBox(width: 12),

                    _outlinedBtn(
                      Icons.download,
                      "Export History",
                      onPressed: () {
                        _toast("Exporting history...");
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) _toast("History exported to Downloads");
                        });
                      },
                    ),
                    const SizedBox(width: 12),

                    ElevatedButton.icon(
                      onPressed: () {
                        _toast("Generating statement...");
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) _toast("Statement sent to printer");
                        });
                      },
                      icon: const Icon(Icons.print),
                      label: const Text("Print Statement"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1677FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _outlinedBtn(IconData icon, String label, {VoidCallback? onPressed}) {
    return OutlinedButton.icon(
      onPressed: onPressed ?? () => _toast("$label clicked"),
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: textPrimary,
        side: BorderSide(color: border),
      ),
    );
  }

  // ================= SUMMARY CARD =================

  Widget _summaryCard({
    required SummaryType type,
    required String title,
    required String value,
    required String badgeText,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color iconBg;
    Color valueColor;
    Color badgeBg;

    switch (type) {
      case SummaryType.danger:
        iconBg = isDark ? const Color(0xFFF87171) : const Color(0xFFFF4D4F);
        valueColor = iconBg;
        badgeBg = isDark ? const Color(0xFF3F1D1D) : const Color(0xFFFFF1F0);
        break;

      case SummaryType.success:
        iconBg = isDark ? const Color(0xFF4ADE80) : const Color(0xFF52C41A);
        valueColor = iconBg;
        badgeBg = isDark ? const Color(0xFF1F3D2B) : const Color(0xFFF6FFED);
        break;

      case SummaryType.warning:
        iconBg = isDark ? const Color(0xFFFACC15) : const Color(0xFFFA8C16);
        valueColor = iconBg;
        badgeBg = isDark ? const Color(0xFF3D2F0F) : const Color(0xFFFFF7E6);
        break;

      case SummaryType.info:
        iconBg = isDark ? const Color(0xFF60A5FA) : const Color(0xFF1890FF);
        valueColor = iconBg;
        badgeBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFE6F7FF);
        break;
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155) // ✅ subtle dark-mode border
              : const Color(0xFFE5E7EB), // ✅ normal light-mode border
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: iconBg,
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= TABS + TABLE =================

  Widget _tabsSection() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Current Fees"),
            Tab(text: "Payment History"),
            Tab(text: "Payment By Head"),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 600,
          child: TabBarView(
            controller: _tabController,
            children: [
              currentFeesScrollableTable(),
              paymentHistoryView(),
              _paymentByHeadCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget currentFeesScrollableTable() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PAYMENT PENDING BANNER
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7E0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFE08A)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "₹${_totalDue.toStringAsFixed(0)} Payment Pending",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Please make the payment at the earliest to avoid any inconvenience.",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HostelPaymentPage(payableAmount: _totalDue),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1677FF),
                    ),
                    child: const Text(
                      "Pay Now",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // HORIZONTAL SCROLL TABLE (SAFE)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width: 1100, // prevents column squeeze
                child: Column(
                  children: [
                    // HEADER
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _H("Fee Head", 3),
                          _H("Total Amount", 2),
                          _H("Paid Amount", 2),
                          _H("Balance", 2),
                          _H("Status", 2),
                          _H("Actions", 2),
                        ],
                      ),
                    ),

                    if (_feeDetails.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("No fee details available"),
                      ),

                    ..._feeDetails.map((fee) {
                      final balance =
                          double.tryParse(
                            fee['balance_amount']?.toString() ?? '0',
                          ) ??
                          0;
                      return _feeRow(
                        head:
                            fee['fee_head']?.toString() ??
                            fee['fee_head_name']?.toString() ??
                            'Unknown',
                        committed: "₹${fee['total_amount'] ?? 0}",
                        total: "₹${fee['total_amount'] ?? 0}",
                        paid: "₹${fee['paid_amount'] ?? 0}",
                        balance: "₹${fee['balance_amount'] ?? 0}",
                        pending: balance > 0,
                        balanceValue: balance,
                      );
                    }),

                    // GRAND TOTAL
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 12,
                      ),
                      decoration: const BoxDecoration(color: Color(0xFFF9FAFB)),
                      child: Row(
                        children: [
                          _GT("Grand Total", 3),
                          _GT(
                            "₹${_totalFee.toStringAsFixed(0)}",
                            2,
                            color: warning,
                          ),
                          _GT(
                            "₹${_totalPaid.toStringAsFixed(0)}",
                            2,
                            color: success,
                          ),
                          _GT(
                            "₹${_totalDue.toStringAsFixed(0)}",
                            2,
                            color: danger,
                          ),
                          Expanded(
                            flex: 4,
                            child: LinearProgressIndicator(
                              value: _totalFee > 0 ? _totalPaid / _totalFee : 0,
                              backgroundColor: const Color(0xFFE5E7EB),
                              color: const Color(0xFF22C55E),
                              minHeight: 8,
                            ),
                          ),
                        ],
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

  /// ---------------- HELPERS ----------------

  Widget _H(String text, int flex) => Expanded(
    flex: flex,
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
  );

  Widget _feeRow({
    required String head,
    required String committed,
    required String total,
    required String paid,
    required String balance,
    bool pending = false,
    double balanceValue = 0.0,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(head, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  "Committed: $committed",
                  style: const TextStyle(color: Colors.black54),
                ),
                const Text(
                  "Discount: ₹0",
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          _cell(total, Colors.blue, 2),
          _cell(paid, Colors.green, 2),
          _cell(balance, pending ? Colors.red : Colors.green, 2),
          Expanded(
            flex: 2,
            child: pending
                ? _tag("Pending", Colors.orange)
                : _tag("Paid", Colors.green),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                if (pending)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HostelPaymentPage(payableAmount: balanceValue),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1677FF),
                    ),
                    child: const Text(
                      "Pay Now",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiptPage(
                            data: {
                              'amount': paid,
                              'receipt_no':
                                  "STMT-${head.replaceAll(RegExp(r'[^a-zA-Z]'), '').substring(0, 3).toUpperCase()}-${DateTime.now().year}",
                              'date': DateTime.now().toString().split(' ')[0],
                            },
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.receipt, size: 16),
                    label: const Text("Receipt"),
                  ),
                const SizedBox(width: 8),
                const Icon(Icons.info_outline, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(String text, Color color, int flex) => Expanded(
    flex: flex,
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w600, color: color),
    ),
  );

  Widget _tag(String text, Color color) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    ),
  );

  Widget _GT(String text, int flex, {Color? color}) => Expanded(
    flex: flex,
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        color: color ?? Colors.black,
      ),
    ),
  );

  // ================= PAYMENT HISTORY =================

  Widget paymentHistoryView() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SUMMARY
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT COLUMN (STACKED TEXTS)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Transactions: ${_paymentHistory.length}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Total Paid: ₹${_totalPaid.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              // RIGHT TEXT
              Expanded(
                child: Text(
                  "Showing payment distribution across all fee categories",
                  style: const TextStyle(color: Colors.black54),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // HORIZONTAL SCROLL AREA (CRITICAL FOR MOBILE)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 900, // prevents column squeeze
              child: Column(
                children: [
                  // TABLE HEADER
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _HeaderPH("Date", 2),
                        _HeaderPH("Invoice No.", 2),
                        _HeaderPH("Type", 2),
                        _HeaderPH("Amount", 2),
                        _HeaderPH("Payment Mode", 2),
                        _HeaderPH("Status", 2),
                        _HeaderPH("Actions", 1),
                      ],
                    ),
                  ),

                  if (_paymentHistory.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("No payment history available"),
                    ),

                  ..._paymentHistory.map((payment) => _paymentRow(payment)),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          // Removed static pagination
        ],
      ),
    );
  }

  /// ---------------- HELPERS ----------------

  Widget _HeaderPH(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _paymentRow(Map<String, dynamic> payment) {
    final date = payment['payment_date']?.toString() ?? '';
    final invoice = payment['receipt_no']?.toString() ?? '';
    final amount = "₹${payment['amount'] ?? 0}";
    final type = payment['fee_head']?.toString() ?? 'Fee Payment';
    final mode = payment['payment_mode']?.toString() ?? 'Online';
    final status = payment['status']?.toString() ?? 'Paid';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          _cellPH(date, 2),
          _cellPH(invoice, 2, link: true),
          _tagPH(
            type,
            2,
            const Color(0xFFF3E8FF),
            const Color(0xFF7C3AED),
          ),
          _cellPH(amount, 2, color: Colors.green, bold: true),
          _tagPH(mode, 2, const Color(0xFFFFF7ED), const Color(0xFFF97316)),
          _tagPH(status, 2, const Color(0xFFF0FDF4), const Color(0xFF22C55E)),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.remove_red_eye,
                  color: Color(0xFF1677FF),
                  size: 18,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReceiptPage(
                        data: {
                          'amount': amount,
                          'receipt_no': invoice,
                          'date': date,
                        },
                      ),
                    ),
                  );
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(
                  Icons.download,
                  color: Color(0xFF1677FF),
                  size: 18,
                ),
                onPressed: () => _toast("Downloading receipt $invoice..."),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cellPH(
    String text,
    int flex, {
    Color? color,
    bool bold = false,
    bool link = false,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          color: link ? Colors.pink : (color ?? Colors.black87),
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _tagPH(String text, int flex, Color bg, Color fg) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: fg,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget paymentByHeadHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Expanded(
            flex: 3,
            child: Text(
              "Fee Head",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Text(
              "Amount Paid",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Text(
              "Percentage",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Expanded(
            flex: 3,
            child: Text(
              "Contribution",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Expanded(flex: 2, child: SizedBox()),
        ],
      ),
    );
  }

  Widget _paymentByHeadCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: SingleChildScrollView(
        // ✅ VERTICAL SCROLL ADDED
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // INFO BANNER
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    backgroundColor: Color(0xFF1677FF),
                    child: Icon(Icons.info, color: Colors.white, size: 18),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Payments Breakdown by Fee Head",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "This shows how your total payments are distributed across different fee categories.",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // SUMMARY
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT SIDE (STACKED TEXT)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Fee Heads: ${_feeDetails.length}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Total Paid: ₹${_totalPaid.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 20),

                // RIGHT SIDE TEXT
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Showing payment distribution across all fee categories",
                      style: const TextStyle(color: Colors.black54),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // HORIZONTAL SCROLL TABLE (UNCHANGED)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width: 1000,
                child: Column(
                  children: [
                    paymentByHeadHeader(),
                    if (_feeDetails.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("No fee details available"),
                      ),
                    ..._feeDetails.map((fee) {
                      final paid =
                          double.tryParse(
                            fee['paid_amount']?.toString() ?? '0',
                          ) ??
                          0;
                      final percentage = _totalPaid > 0
                          ? paid / _totalPaid
                          : 0.0;
                      return paymentByHeadData(
                        fee['fee_head']?.toString() ??
                            fee['fee_head_name']?.toString() ??
                            'Unknown',
                        "₹${paid.toStringAsFixed(0)}",
                        percentage,
                        percentage > 0.5
                            ? "Major Contribution"
                            : (percentage > 0.1
                                  ? "Moderate Contribution"
                                  : "Minor Contribution"),
                        percentage > 0.5
                            ? Colors.green
                            : (percentage > 0.1
                                  ? Colors.orange
                                  : Colors.purple),
                      );
                    }),

                    // TOTAL ROW
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 12,
                      ),
                      decoration: const BoxDecoration(color: Color(0xFFF9FAFB)),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 3,
                            child: Text(
                              "Total Payments",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          const Expanded(flex: 3, child: SizedBox()),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "₹${_totalPaid.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: LinearProgressIndicator(
                              value: _totalFee > 0 ? _totalPaid / _totalFee : 0,
                              minHeight: 8,
                              color: Colors.green,
                              backgroundColor: Colors.grey.shade300,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: tag("Complete Distribution", Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // VISUALIZATION TITLE
            const Row(
              children: [
                Icon(Icons.pie_chart_outline),
                SizedBox(width: 8),
                Text(
                  "Payment Distribution Visualization",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ..._feeDetails.map((fee) {
              final paid =
                  double.tryParse(fee['paid_amount']?.toString() ?? '0') ?? 0;
              final percentage = _totalPaid > 0 ? paid / _totalPaid : 0.0;
              return visualRow(
                fee['fee_head']?.toString() ??
                    fee['fee_head_name']?.toString() ??
                    'Unknown',
                "₹${paid.toStringAsFixed(0)} (${(percentage * 100).toStringAsFixed(1)}%)",
                percentage,
                Colors.blue,
              );
            }),
          ],
        ),
      ),
    );
  }

  // ================= FEE SUMMARY =================

  Widget _feeSummaryCard() {
    final double progress = _totalFee > 0 ? _totalPaid / _totalFee : 0.0;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: const [
              Icon(
                Icons.description_outlined,
                size: 22,
                color: Color(0xFF2563EB),
              ),
              SizedBox(width: 8),
              Text(
                "Fee Summary",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const Divider(height: 20, thickness: 1),

          const SizedBox(height: 18),

          row("Total Fee", "₹${_totalFee.toStringAsFixed(0)}"),
          row("Discount", "₹0", valueColor: Colors.green),
          row("Committed Fee", "₹${_totalFee.toStringAsFixed(0)}"),

          const SizedBox(height: 14),

          row(
            "Total Paid",
            "₹${_totalPaid.toStringAsFixed(0)}",
            valueColor: const Color(0xFF16A34A),
          ),
          row(
            "Total Due",
            "₹${_totalDue.toStringAsFixed(0)}",
            valueColor: const Color(0xFFDC2626),
          ),

          const SizedBox(height: 18),

          // Payment Progress
          Row(
            children: [
              const Text(
                "Payment Progress",
                style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF22C55E),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "${(progress * 100).toStringAsFixed(0)}%",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= BRANCH SUMMARY =================

  Widget _branchSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Row(
            children: [
              Icon(Icons.account_balance, size: 22, color: Color(0xFF7C3AED)),
              SizedBox(width: 8),
              Text(
                "Branch Summary",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const Divider(height: 32, thickness: 1),
          const SizedBox(height: 16),

          Text(
            _branchName,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 6),

          Text(
            "Total Paid: ₹${_totalPaid.toStringAsFixed(0)}",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // ================= COMMON ROW =================

  Widget row(
    String label,
    String value, {
    Color valueColor = const Color(0xFF111827),
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label:",
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // ================= UTILS =================

  Widget paymentByHeadData(
    String head,
    String amount,
    double percentage,
    String contribution,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              head,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              amount,
              style: TextStyle(fontWeight: FontWeight.w600, color: color),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "${(percentage * 100).toStringAsFixed(0)}%",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(flex: 3, child: tag(contribution, color)),
          const Expanded(flex: 2, child: SizedBox()),
        ],
      ),
    );
  }

  Widget visualRow(String label, String value, double percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  value,
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget tag(String text, Color color) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
