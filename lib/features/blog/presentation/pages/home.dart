import 'package:flutter/material.dart';
import 'package:my_app/features/blog/presentation/pages/add_blog.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 169, 169),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 240, 160, 160),
        title: Text(
          'My Blogs',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: const Color.fromARGB(255, 145, 51, 51)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Builder(builder: (context) {
              return IconButton(
                onPressed: Scaffold.of(context).openEndDrawer,
                icon: Icon(Icons.menu),
              );
            }),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            // Add A New Blog
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddBlog(),
            ));
          },
          icon: const Icon(Icons.add),
          iconSize: 32,
          color: const Color.fromARGB(255, 145, 51, 51),
        ),
      ),
      body: Center(
        child: SizedBox(
          child: ListView.builder(
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Blog ${index + 1}'),
              );
            },
            itemCount: 8,
          ),
        ),
      ),
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.6, // 60% width
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.redAccent),
                child: Center(
                  child: Text(
                    "Menu",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () async {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
