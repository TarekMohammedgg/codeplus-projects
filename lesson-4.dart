// enum Access {
//   admin("Admin", true),
//   editor("Editor", true),
//   viewer("Viewer", false);

//   final String title;
//   final bool canDelete;

//   void printInfo() {
//     print("Role:${title} and can Delete status is: ${canDelete} ");
//   }

//   const Access(this.title, this.canDelete);
// }

// void main() {
//   Access admin = Access.admin ;
//   admin.printInfo();
// }

Future<String> fetchUser() async {
  await Future.delayed(const Duration(seconds: 2));
  print("User Loaded");
  return "Tarek";
}

Future<String> fetchPosts() async {
  await Future.delayed(const Duration(seconds: 2));
  print("Posts Loaded");
  return "Posts";
}

Future<String> fetchComments() async {
  await Future.delayed(const Duration(seconds: 2));
  print("Comments Loaded");
  return "Comments";
}

Future<void> main() async {
  // print("Example 1 Start");

  // String user = await fetchUser();
  // // String posts = await fetchPosts();
  // // String comments = await fetchComments();

  // print(user);

  // // print(posts);
  // // print(comments);

  // print("Example 1 End");

  // print("--------------------");

  // print("Example 2 Start");

  var results = await Future.wait([
    fetchUser(),
    fetchPosts(),
    fetchComments(),
  ]);


  print(results);

  // print("Example 2 End");
}
