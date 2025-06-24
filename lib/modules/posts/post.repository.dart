import "package:udemy__sns_app/modules/posts/post.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class PostRepository {
  Future<Post> create(String content, User user) async {
    final response = await Supabase.instance.client.from("posts").insert({
          "content": content,
          "user_id": user.id,
        }).select();
    final post = response[0];
    return Post.fromJson({
      "id": post["id"],
      "content": post["content"],
      "userId": post["user_id"],
      "userName": user.userMetadata!["name"],
    });
  }
}
