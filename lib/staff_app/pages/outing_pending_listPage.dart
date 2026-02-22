import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app/staff_app/model/model2.dart';
import 'package:student_app/staff_app/pages/verify_outing_page.dart';
import 'package:student_app/staff_app/controllers/outing_pending_controller.dart';
import 'package:student_app/staff_app/widgets/skeleton.dart';

class OutingPendingListPage extends StatefulWidget {
  const OutingPendingListPage({super.key});

  @override
  State<OutingPendingListPage> createState() => _OutingPendingListPageState();
}

class _OutingPendingListPageState extends State<OutingPendingListPage> {
  final OutingPendingController controller = Get.put(OutingPendingController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1a1a2e),
                    Color(0xFF16213e),
                    Color(0xFF0f3460),
                    Color(0xFF533483),
                  ],
                  stops: [0.0, 0.3, 0.6, 1.0],
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
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: controller.fetchOutings,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildAppTitle(context, isDark),
                      const SizedBox(height: 20),
                    ]),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Theme.of(context).cardColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.1)
                              : Theme.of(context).dividerColor,
                        ),
                      ),
                      child: TextField(
                        onChanged: controller.searchStudent,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search Student",
                          hintStyle: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? Colors.white.withOpacity(0.1)
                              : Theme.of(context).colorScheme.surface,
                          prefixIcon: Icon(
                            Icons.search,
                            color: isDark ? Colors.white : Colors.black54,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: SkeletonList(itemCount: 5),
                      ),
                    );
                  }

                  if (controller.filteredStudents.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: Text("No pending outings found")),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final StudentModel s =
                            controller.filteredStudents[index];
                        final isLast =
                            index == controller.filteredStudents.length - 1;

                        return Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Theme.of(context).cardColor,
                            borderRadius: isLast
                                ? const BorderRadius.vertical(
                                    bottom: Radius.circular(24),
                                  )
                                : null,
                            border: Border(
                              left: BorderSide(
                                color: isDark
                                    ? Colors.white.withOpacity(0.1)
                                    : Theme.of(context).dividerColor,
                              ),
                              right: BorderSide(
                                color: isDark
                                    ? Colors.white.withOpacity(0.1)
                                    : Theme.of(context).dividerColor,
                              ),
                              bottom: BorderSide(
                                color: isDark
                                    ? Colors.white.withOpacity(0.1)
                                    : Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                _buildStudentItem(context, s, isDark),
                                if (isLast) const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        );
                      }, childCount: controller.filteredStudents.length),
                    ),
                  );
                }),
                const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentItem(BuildContext context, StudentModel s, bool isDark) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyOutingPage(
              key: ValueKey(s.outingId), // Enable explicit reset by key
              adm: s.admNo,
              name: s.name,
              status: s.status,
              imageUrl: s.image,
              outingId: s.outingId,
            ),
          ),
        );
        controller.fetchOutings(); // Refresh list on return
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: s.status.toLowerCase() == "approved"
              ? const Color(0xFF2EBD85)
              : const Color(0xFF7B7FD4),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            // IMAGE
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: (s.image != null && s.image!.isNotEmpty)
                      ? NetworkImage(s.image!)
                      : const AssetImage("assets/girl.jpg") as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.admNo,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s.name,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Permission By : ${s.permissionBy}",
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppTitle(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Row(
        children: [
          Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          const SizedBox(width: 8),
          Text(
            "Outing Pending",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
