import 'dart:io';

import 'package:flutter/material.dart' as flutter;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hobica/core/utils/validators.dart';
import 'package:hobica/core/widgets/error_view.dart';
import 'package:hobica/core/widgets/loading_indicator.dart';
import 'package:hobica/features/reward/domain/models/reward.dart';
import 'package:hobica/features/reward/domain/models/reward_category.dart';
import 'package:hobica/features/reward/presentation/providers/reward_form_provider.dart';
import 'package:hobica/features/reward/presentation/providers/reward_list_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class RewardFormPage extends ConsumerStatefulWidget {
  /// rewardId が null の場合は新規作成モード、非 null の場合は編集モード。
  const RewardFormPage({this.rewardId, super.key});

  final int? rewardId;

  @override
  ConsumerState<RewardFormPage> createState() => _RewardFormPageState();
}

class _RewardFormPageState extends ConsumerState<RewardFormPage> {
  final _formKey = flutter.GlobalKey<flutter.FormState>();
  final _titleController = TextEditingController();
  final _pointsController = TextEditingController();
  final _memoController = TextEditingController();
  final _picker = ImagePicker();

  String? _imageUri;
  RewardCategory? _category;
  Reward? _editingReward;
  bool _isLoadingReward = false;

  bool get _isEditMode => widget.rewardId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _loadReward();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _pointsController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _loadReward() async {
    setState(() => _isLoadingReward = true);
    final repo = ref.read(rewardRepositoryProvider);
    final reward = await repo.fetchRewardById(widget.rewardId!);
    if (mounted) {
      setState(() {
        _isLoadingReward = false;
        if (reward != null) {
          _editingReward = reward;
          _titleController.text = reward.title;
          _pointsController.text = reward.targetPoints.toString();
          _memoController.text = reward.memo ?? '';
          _imageUri = reward.imageUri;
          _category = reward.category;
        }
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null && mounted) {
      setState(() => _imageUri = picked.path);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final title = _titleController.text.trim();
    final targetPoints = int.parse(_pointsController.text.trim());
    final memo = _memoController.text.trim().isEmpty
        ? null
        : _memoController.text.trim();

    if (_isEditMode && _editingReward != null) {
      final updated = _editingReward!.copyWith(
        title: title,
        targetPoints: targetPoints,
        imageUri: _imageUri,
        category: _category,
        memo: memo,
      );
      await ref.read(rewardFormProvider.notifier).submitUpdate(updated);
    } else {
      await ref.read(rewardFormProvider.notifier).submitCreate(
            title: title,
            targetPoints: targetPoints,
            imageUri: _imageUri,
            category: _category,
            memo: memo,
          );
    }

    final formState = ref.read(rewardFormProvider);
    if (mounted && formState.savedReward != null) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(rewardFormProvider);

    if (_isLoadingReward) {
      return Scaffold(
        headers: [
          AppBar(title: Text(_isEditMode ? 'ご褒美を編集' : 'ご褒美を追加')),
        ],
        child: const LoadingIndicator(),
      );
    }

    return Scaffold(
      headers: [
        AppBar(title: Text(_isEditMode ? 'ご褒美を編集' : 'ご褒美を追加')),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: flutter.Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (formState.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ErrorView(message: formState.error!),
                ),
              _ImagePickerSection(
                imageUri: _imageUri,
                onPickGallery: () => _pickImage(ImageSource.gallery),
                onPickCamera: () => _pickImage(ImageSource.camera),
              ),
              const SizedBox(height: 16),
              _TitleField(controller: _titleController),
              const SizedBox(height: 16),
              _PointsField(controller: _pointsController),
              const SizedBox(height: 16),
              _CategorySelector(
                selected: _category,
                onChanged: (cat) => setState(() => _category = cat),
              ),
              const SizedBox(height: 16),
              _MemoField(controller: _memoController),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Button.primary(
                  onPressed: formState.isSubmitting ? null : _submit,
                  child: formState.isSubmitting
                      ? const LoadingIndicator()
                      : Text(_isEditMode ? '更新' : '作成'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePickerSection extends StatelessWidget {
  const _ImagePickerSection({
    required this.imageUri,
    required this.onPickGallery,
    required this.onPickCamera,
  });

  final String? imageUri;
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 160,
          width: double.infinity,
          child: imageUri != null
              ? Image.file(File(imageUri!), fit: BoxFit.cover)
              : const ColoredBox(
                  color: Color(0xFFEEEEEE),
                  child: Center(
                    child: Icon(BootstrapIcons.gift, size: 48),
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Button.ghost(
              onPressed: onPickGallery,
              child: const Text('ギャラリーから選択'),
            ),
            const SizedBox(width: 8),
            Button.ghost(
              onPressed: onPickCamera,
              child: const Text('カメラで撮影'),
            ),
          ],
        ),
      ],
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('タイトル'),
        const SizedBox(height: 4),
        flutter.TextFormField(
          controller: controller,
          validator: Validators.validateTitle,
          decoration: const flutter.InputDecoration(
            hintText: 'ご褒美のタイトルを入力',
          ),
        ),
      ],
    );
  }
}

class _PointsField extends StatelessWidget {
  const _PointsField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('必要ポイント'),
        const SizedBox(height: 4),
        flutter.TextFormField(
          controller: controller,
          keyboardType: flutter.TextInputType.number,
          validator: Validators.validatePoints,
          decoration: const flutter.InputDecoration(
            hintText: '例: 300',
          ),
        ),
      ],
    );
  }
}

class _CategorySelector extends StatelessWidget {
  const _CategorySelector({
    required this.selected,
    required this.onChanged,
  });

  static const _categories = [
    (RewardCategory.item, '物品'),
    (RewardCategory.experience, '体験'),
    (RewardCategory.food, '食'),
    (RewardCategory.beauty, '美容'),
    (RewardCategory.entertainment, '娯楽'),
    (RewardCategory.other, 'その他'),
  ];

  final RewardCategory? selected;
  final void Function(RewardCategory?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('カテゴリ（任意）'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _categories.map((entry) {
            final (cat, label) = entry;
            final isSelected = selected == cat;
            return GestureDetector(
              onTap: () => onChanged(isSelected ? null : cat),
              child: isSelected
                  ? PrimaryBadge(child: Text(label))
                  : SecondaryBadge(child: Text(label)),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _MemoField extends StatelessWidget {
  const _MemoField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('メモ（任意）'),
        const SizedBox(height: 4),
        flutter.TextFormField(
          controller: controller,
          maxLines: 3,
          decoration: const flutter.InputDecoration(
            hintText: 'メモを入力（任意）',
          ),
        ),
      ],
    );
  }
}
