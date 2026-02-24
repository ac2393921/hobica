import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hobica/core/router/routes.dart';
import 'package:hobica/core/types/result.dart';
import 'package:hobica/core/utils/validators.dart';
import 'package:hobica/features/habit/domain/models/frequency_type.dart';
import 'package:hobica/features/habit/domain/models/habit.dart';
import 'package:hobica/features/habit/presentation/providers/habit_form_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// 習慣作成・編集フォーム画面。
///
/// [initialHabit] が null の場合は作成モード、non-null の場合は編集モード。
class HabitFormPage extends ConsumerStatefulWidget {
  const HabitFormPage({this.initialHabit, super.key});

  final Habit? initialHabit;

  @override
  ConsumerState<HabitFormPage> createState() => _HabitFormPageState();
}

class _HabitFormPageState extends ConsumerState<HabitFormPage> {
  static const double _sectionSpacing = 16;
  static const double _labelFieldSpacing = 8;
  static const double _fieldSpacing = 12;

  final _titleController = TextEditingController();
  final _pointsController = TextEditingController();
  final _frequencyValueController = TextEditingController();

  bool _initialized = false;

  @override
  void dispose() {
    _titleController.dispose();
    _pointsController.dispose();
    _frequencyValueController.dispose();
    super.dispose();
  }

  HabitFormProvider get _provider =>
      habitFormProvider(initialHabit: widget.initialHabit);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);

    if (!_initialized) {
      _titleController.text = state.title;
      _pointsController.text = state.points.toString();
      _frequencyValueController.text = state.frequencyValue.toString();
      _initialized = true;
    }

    final isEditMode = widget.initialHabit != null;
    final title = isEditMode ? '習慣を編集' : '習慣を作成';

    return Scaffold(
      headers: [AppBar(title: Text(title))],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(_sectionSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _FormTextField(
              label: 'タイトル',
              controller: _titleController,
              onChanged: (v) =>
                  ref.read(_provider.notifier).updateTitle(v),
              placeholder: const Text('習慣のタイトルを入力'),
              validator: Validators.validateTitle,
            ),
            const SizedBox(height: _fieldSpacing),
            _FormTextField(
              label: 'ポイント',
              controller: _pointsController,
              onChanged: (v) {
                final parsed = int.tryParse(v);
                if (parsed != null) {
                  ref.read(_provider.notifier).updatePoints(parsed);
                }
              },
              placeholder: const Text('例: 30'),
              validator: Validators.validatePoints,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: _fieldSpacing),
            _FrequencySection(
              frequencyType: state.frequencyType,
              frequencyValueController: _frequencyValueController,
              onTypeChanged: (type) =>
                  ref.read(_provider.notifier).updateFrequencyType(type),
              onValueChanged: (v) {
                final parsed = int.tryParse(v);
                if (parsed != null) {
                  ref.read(_provider.notifier).updateFrequencyValue(parsed);
                }
              },
            ),
            const SizedBox(height: _fieldSpacing),
            _RemindSection(
              remindTime: state.remindTime,
              onChanged: (time) =>
                  ref.read(_provider.notifier).updateRemindTime(time),
            ),
            if (state.error != null) ...[
              const SizedBox(height: _labelFieldSpacing),
              Alert.destructive(
                leading: const Icon(BootstrapIcons.exclamationCircle, size: 20),
                title: const Text('エラー'),
                content: Text(state.error!.message),
              ),
            ],
            const SizedBox(height: _sectionSpacing),
            Button.primary(
              onPressed: state.isSubmitting
                  ? null
                  : () => _onSubmit(context),
              child: Text(isEditMode ? '保存' : '作成'),
            ),
            if (isEditMode) ...[
              const SizedBox(height: _fieldSpacing),
              Button.outline(
                onPressed: state.isSubmitting
                    ? null
                    : () => _onDelete(context),
                child: const Text('削除'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _onSubmit(BuildContext context) async {
    final result = await ref.read(_provider.notifier).submit();
    if (!context.mounted) return;
    if (result is Success) {
      context.pop();
    }
  }

  Future<void> _onDelete(BuildContext context) async {
    final confirmed = await _showDeleteDialog(context);
    if (!confirmed || !context.mounted) return;
    final result = await ref.read(_provider.notifier).delete();
    if (!context.mounted) return;
    if (result is Success) {
      context.go(AppRoutes.habits);
    }
  }

  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('習慣を削除'),
            content: const Text('この習慣を削除しますか？この操作は取り消せません。'),
            actions: [
              Button.outline(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('キャンセル'),
              ),
              Button.destructive(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('削除'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class _FormTextField extends StatelessWidget {
  const _FormTextField({
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.placeholder,
    required this.validator,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final Text placeholder;
  final String? Function(String) validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          placeholder: placeholder,
        ),
        Builder(
          builder: (ctx) {
            final error = validator(controller.text);
            if (error == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                error,
                style: TextStyle(
                  color: Theme.of(ctx).colorScheme.destructive,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _FrequencySection extends StatelessWidget {
  const _FrequencySection({
    required this.frequencyType,
    required this.frequencyValueController,
    required this.onTypeChanged,
    required this.onValueChanged,
  });

  final FrequencyType frequencyType;
  final TextEditingController frequencyValueController;
  final ValueChanged<FrequencyType> onTypeChanged;
  final ValueChanged<String> onValueChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('頻度'),
        const SizedBox(height: 8),
        Row(
          children: [
            _FrequencyTypeButton(
              label: '毎日',
              isSelected: frequencyType == FrequencyType.daily,
              onTap: () => onTypeChanged(FrequencyType.daily),
            ),
            const SizedBox(width: 8),
            _FrequencyTypeButton(
              label: '週次',
              isSelected: frequencyType == FrequencyType.weekly,
              onTap: () => onTypeChanged(FrequencyType.weekly),
            ),
          ],
        ),
        if (frequencyType == FrequencyType.weekly) ...[
          const SizedBox(height: 8),
          TextField(
            controller: frequencyValueController,
            onChanged: onValueChanged,
            keyboardType: TextInputType.number,
            placeholder: const Text('週の回数（例: 3）'),
          ),
        ],
      ],
    );
  }
}

class _FrequencyTypeButton extends StatelessWidget {
  const _FrequencyTypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? Button.primary(onPressed: onTap, child: Text(label))
        : Button.outline(onPressed: onTap, child: Text(label));
  }
}

class _RemindSection extends StatelessWidget {
  const _RemindSection({required this.remindTime, required this.onChanged});

  final DateTime? remindTime;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final timeOfDay = remindTime != null
        ? TimeOfDay(hour: remindTime!.hour, minute: remindTime!.minute)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('リマインド（任意）'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TimePicker(
                value: timeOfDay,
                onChanged: (picked) {
                  if (picked == null) {
                    onChanged(null);
                    return;
                  }
                  final now = DateTime.now();
                  onChanged(
                    DateTime(
                      now.year,
                      now.month,
                      now.day,
                      picked.hour,
                      picked.minute,
                    ),
                  );
                },
                use24HourFormat: true,
                placeholder: const Text('未設定'),
              ),
            ),
            if (remindTime != null) ...[
              const SizedBox(width: 8),
              Button.ghost(
                onPressed: () => onChanged(null),
                child: const Icon(BootstrapIcons.xCircle),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
