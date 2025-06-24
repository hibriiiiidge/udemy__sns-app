import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udemy__sns_app/modules/posts/post.dart';
import 'package:udemy__sns_app/widgets/header.dart';
import 'package:udemy__sns_app/widgets/post_card.dart';
import 'package:udemy__sns_app/widgets/post_input.dart';
import 'package:udemy__sns_app/modules/posts/post.repository.dart';
import 'package:udemy__sns_app/modules/auth/current_user_store.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  String _content = "";
  final _textController = TextEditingController();

  void _createPost() async {
    if (_content.isEmpty) return;
    final currentUser = ref.watch(currentUserProvider);
    final post = await PostRepository().create(_content, currentUser!);
    print(post);
    _textController.text = "";
    setState(() {
      _content = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Header(),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            PostInput(
              controller: _textController,
              content: _content,
              onChanged: (value) {
                setState(() {
                  _content = value;
                });
              },
              onSubmitted: _createPost,
            ),
            PostCard(),
            PostCard(),
            PostCard(),
            PostCard(),
          ],
        ),
      ),
    );
  }
}
