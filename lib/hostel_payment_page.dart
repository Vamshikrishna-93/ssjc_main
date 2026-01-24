import 'package:flutter/material.dart';
import 'package:student_app/hostel_fee_page.dart';
import 'package:student_app/theme_controller.dart';

class HostelPaymentPage extends StatefulWidget {
  const HostelPaymentPage({super.key});

  @override
  State<HostelPaymentPage> createState() => _HostelPaymentPageState();
}

class _HostelPaymentPageState extends State<HostelPaymentPage> {
  int selectedMethod = 0;

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get bg => Theme.of(context).scaffoldBackgroundColor;
  Color get card => Theme.of(context).cardColor;
  Color get border => Theme.of(context).dividerColor;
  Color get textPrimary => Theme.of(context).textTheme.bodyLarge!.color!;
  Color get textSecondary => Theme.of(context).textTheme.bodyMedium!.color!;
  Color get primary => const Color(0xFF1677FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Pay Hostel Fees"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitConfirmation(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            onPressed: ThemeController.toggleTheme,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pay your hostel fees securely",
                style: TextStyle(color: textSecondary),
              ),

              const SizedBox(height: 16),

              // PAYMENT AMOUNT CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: const Icon(Icons.warning, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Payment Amount: ₹39,200",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "This includes all pending fee heads",
                            style: TextStyle(color: textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Text(
                "Select Payment Method",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),

              const SizedBox(height: 16),

              _paymentOption(
                index: 0,
                icon: Icons.account_balance_wallet_outlined,
                iconColor: Colors.deepPurple,
                title: "UPI Payment",
                subtitle: "Google Pay, PhonePe, Paytm",
              ),
              _paymentOption(
                index: 1,
                icon: Icons.credit_card,
                iconColor: Colors.blue,
                title: "Credit/Debit Card",
                subtitle: "Visa, MasterCard, Rupay",
              ),
              _paymentOption(
                index: 2,
                icon: Icons.account_balance,
                iconColor: Colors.orange,
                title: "Net Banking",
                subtitle: "All major Indian banks",
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Pay ₹39,200",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: Text(
                  "Your payment is secured with 256-bit SSL encryption",
                  style: TextStyle(color: textSecondary, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // CONFIRM EXIT
  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(
          "Cancel Payment?",
          style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary),
        ),
        content: Text(
          "Are you sure you want to go back? Your payment is not completed.",
          style: TextStyle(color: textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Stay", style: TextStyle(color: textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primary),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HostelFeesPage()),
              );
            },
            child: const Text("Go Back", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // PAYMENT OPTION TILE
  Widget _paymentOption({
    required int index,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    final bool isSelected = selectedMethod == index;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => setState(() => selectedMethod = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primary : border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<int>(
              value: index,
              groupValue: selectedMethod,
              onChanged: (v) => setState(() => selectedMethod = v!),
              activeColor: primary,
            ),
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
