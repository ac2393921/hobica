class Validators {
  Validators._();

  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'タイトルを入力してください';
    }
    if (value.length > 50) {
      return 'タイトルは50文字以内で入力してください';
    }
    return null;
  }

  static String? validatePoints(String? value) {
    if (value == null || value.isEmpty) {
      return 'ポイントを入力してください';
    }
    final parsed = int.tryParse(value);
    if (parsed == null) {
      return '整数を入力してください';
    }
    if (parsed < 1) {
      return '1以上の値を入力してください';
    }
    return null;
  }
}
