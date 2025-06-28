import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikita_flutter_interview/core/constants/app_string.dart';
import 'package:nikita_flutter_interview/data/models/task.dart';
import 'package:uuid/uuid.dart';
import 'package:nikita_flutter_interview/core/constants/app_colors.dart';
import 'package:nikita_flutter_interview/core/utils/task_utils.dart';
import 'package:nikita_flutter_interview/core/widgets/common_widgets.dart';
import 'package:nikita_flutter_interview/core/utils/snackbar_utils.dart';
import 'package:nikita_flutter_interview/core/services/ad_service.dart';
import '../../../core/widgets/banner_ad_widget.dart';
import '../controller/task_controller.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? existingTask;

  const TaskFormScreen({super.key, this.existingTask});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TaskController controller = Get.find();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _selectedDate;
  int _priority = 0;

  @override
  void initState() {
    super.initState();
    if (widget.existingTask != null) {
      final t = widget.existingTask!;
      _titleController.text = t.title;
      _descController.text = t.description ?? '';
      _selectedDate = t.dueDate;
      _priority = t.priority;
    } else {
      _selectedDate = DateTime.now();
    }
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final newTask = Task(
        id: widget.existingTask?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        dueDate: _selectedDate!,
        priority: _priority,
        updatedAt: DateTime.now(),
        isDirty: true,
        isSynced: false,
      );

      await controller.addOrEditTask(newTask);

      var connectivityResult = await Connectivity().checkConnectivity();
      bool isOnline = connectivityResult != ConnectivityResult.none;

      if (isOnline) {
        final AdService adService = Get.put(AdService());
        await adService.showRewardedVideoAdForTaskCompletion();
      }

      Get.back();

      SnackbarUtils.showSuccess(
        AppString.success,
        widget.existingTask != null
            ? AppString.taskUpdated
            : AppString.taskAdded,
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGradientStart,
              onPrimary: AppColors.whiteColor,
              surface: AppColors.whiteColor,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

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
                  children: [
                    CommonWidgets.iconButtonWithBackground(
                      icon: Icons.arrow_back,
                      onPressed: () async {
                        final adService = Get.find<AdService>();
                        await adService.showInterstitialAdOnNavigation();
                        Get.back();
                      },
                    ),
                    const SizedBox(width: 16),
                    Text(
                      widget.existingTask != null
                          ? AppString.editTask
                          : AppString.addNewTask,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          CommonWidgets.formFieldContainer(
                            child: TextFormField(
                              controller: _titleController,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                labelText: AppString.taskTitle,
                                labelStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(20),
                              ),
                              validator:
                                  (val) =>
                                      val == null || val.isEmpty
                                          ? AppString.enterTaskTitle
                                          : null,
                            ),
                          ),

                          const SizedBox(height: 20),

                          CommonWidgets.formFieldContainer(
                            child: TextFormField(
                              controller: _descController,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 4,
                              decoration: const InputDecoration(
                                labelText: AppString.descriptionOptional,
                                labelStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.fromLTRB(
                                  20,
                                  20,
                                  20,
                                  20,
                                ),
                                alignLabelWithHint: true,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          CommonWidgets.formFieldContainer(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: _pickDate,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          AppString.dueDate,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _selectedDate
                                                  ?.toLocal()
                                                  .toString()
                                                  .split(" ")
                                                  .first ??
                                              AppString.selectDate,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                _selectedDate == null
                                                    ? AppColors.textLight
                                                    : AppColors.textPrimary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          CommonWidgets.formFieldContainer(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.priority_high,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 16),
                                  const Text(
                                    AppString.priority,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const Spacer(),
                                  DropdownButton<int>(
                                    value: _priority,
                                    underline: Container(),
                                    items: TaskUtils.getPriorityDropdownItems(),
                                    onChanged:
                                        (val) => setState(
                                          () => _priority = val ?? 0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          Obx(() {
                            return controller.isSaving.value
                                ? CommonWidgets.loadingIndicator()
                                : CommonWidgets.gradientButton(
                                  text: AppString.saveTask,
                                  onPressed: _saveTask,
                                );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: AppColors.whiteColor,
                child: const BannerAdWidget(height: 70, showBackground: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
