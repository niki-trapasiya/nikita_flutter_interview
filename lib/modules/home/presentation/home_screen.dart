import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikita_flutter_interview/core/constants/app_string.dart';
import 'package:nikita_flutter_interview/core/constants/app_colors.dart';
import 'package:nikita_flutter_interview/core/utils/task_utils.dart';
import 'package:nikita_flutter_interview/core/widgets/common_widgets.dart';
import 'package:nikita_flutter_interview/core/widgets/banner_ad_widget.dart';
import 'package:nikita_flutter_interview/core/services/ad_service.dart';
import 'package:nikita_flutter_interview/core/utils/navigation_helper.dart';
import '../controller/task_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskController controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppString.myTasks,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Obx(
                          () => Text(
                            '${controller.tasks.length} tasks',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.white70Color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () => CommonWidgets.syncButton(
                        isLoading: controller.isSyncing.value,
                        onPressed: () => controller.syncWithInternetCheck(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Obx(() {
                          final tasks = controller.tasks;

                          if (controller.isLoading.value) {
                            return CommonWidgets.loadingIndicator();
                          }

                          if (tasks.isEmpty) {
                            return CommonWidgets.emptyState(
                              icon: Icons.task_alt,
                              title: AppString.noTask,
                              subtitle: AppString.firstTask,
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: tasks.length,
                            itemBuilder: (_, index) {
                              final task = tasks[index];
                              final isOverdue = TaskUtils.isOverdue(
                                task.dueDate,
                              );

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.textSecondary.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 15,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () async {
                                      final adService = Get.find<AdService>();
                                      await adService
                                          .showInterstitialAdOnTaskEdit();

                                      NavigationHelper.navigateToTaskForm(
                                        context,
                                        task,
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 4,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: TaskUtils.getPriorityColor(
                                                task.priority,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                          const SizedBox(width: 16),

                                          // Task content
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  task.title,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        AppColors.textPrimary,
                                                  ),
                                                ),
                                                if (task.description != null &&
                                                    task
                                                        .description!
                                                        .isNotEmpty) ...[
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    task.description!,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.textLight,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.calendar_today,
                                                      size: 16,
                                                      color:
                                                          isOverdue
                                                              ? AppColors.error
                                                              : AppColors
                                                                  .textLight,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      TaskUtils.formatDate(
                                                        task.dueDate,
                                                      ),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            isOverdue
                                                                ? Colors.red
                                                                : AppColors
                                                                    .textLight,
                                                        fontWeight:
                                                            isOverdue
                                                                ? FontWeight
                                                                    .w600
                                                                : FontWeight
                                                                    .normal,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    CommonWidgets.priorityBadge(
                                                      task.priority,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color: Colors.red[400],
                                              size: 24,
                                            ),
                                            onPressed: () async {
                                              await controller.deleteTask(
                                                task.id,
                                              );
                                              Get.snackbar(
                                                AppString.deleted,
                                                '${AppString.task} "${task.title}" "${AppString.delete}"',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor: Colors.red,
                                                colorText: AppColors.whiteColor,
                                                borderRadius: 12,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                      // Banner Ad at the bottom
                      const BannerAdWidget(
                        height: 70,
                        margin: EdgeInsets.fromLTRB(16, 8, 16, 6),
                        showBackground: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 55),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGradientStart.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => NavigationHelper.navigateToTaskForm(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.add, color: AppColors.whiteColor, size: 28),
          label: Text(
            AppString.addTask,
            style: TextStyle(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
