import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udemy__sns_app/modules/auth/current_user_store.dart';
import 'package:udemy__sns_app/modules/auth_repository.dart';

class Header extends ConsumerWidget {
  const Header({
    super.key,
  });

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('サインアウト'),
        content: const Text('サインアウトしますか？'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _performSignOut(ref);
            },
            child: const Text('サインアウト'),
          ),
        ],
      ),
    );
  }

  Future<void> _performSignOut(WidgetRef ref) async {
    try {
      await AuthRepository().signout();
      ref.read(currentUserProvider.notifier).setCurrentUser(null);
    } catch (e) {
      print('サインアウトエラー: $e');
    }
  }

  void _handleMenuSelected(BuildContext context, WidgetRef ref, int val) {
    if (val == 1) {
      _showSignOutDialog(context, ref);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return AppBar(
      title: const Text('SNS APP', style: TextStyle(color: Colors.white)),
      actions: [
        PopupMenuButton<int>(
          icon: const Icon(Icons.menu, color: Colors.white),
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: 0,
              child: ListTile(
                title: Text(currentUser!.userMetadata!['name']),
                subtitle: Text(currentUser.email!),
              ),
            ),
            const PopupMenuItem<int>(
                value: 1,
                child: ListTile(
                  title: Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ))
          ],
          onSelected: (val) => _handleMenuSelected(context, ref, val),
        ),
      ],
    );
  }
}
