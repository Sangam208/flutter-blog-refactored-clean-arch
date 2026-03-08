import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/common/widgets/loader.dart';
import 'package:my_app/core/utils/format_date.dart';
import 'package:my_app/core/utils/show_toast.dart';
import 'package:my_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:my_app/features/blog/presentation/pages/add_blog.dart';
import 'package:my_app/features/blog/presentation/pages/blog_view.dart';
import 'package:my_app/features/blog/presentation/widgets/blog_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 169, 169),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 240, 160, 160),
        title: Text(
          'Discover',
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
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) showToast(state.message);
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            showToast('Updating your feed');
            return const Loader();
          }

          if (state is BlogDisplaySuccess) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView.builder(
                itemCount: state.blogs.length,
                itemBuilder: (context, index) {
                  final blog = state.blogs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: SizedBox(
                      height: 130,
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlogView(
                                title: blog.title,
                                content: blog.content,
                                imageUrl: blog.imageUrl,
                                username: blog.username!,
                                updatedAt: formatDateByddMMYYYY(blog.updatedAt),
                              ),
                            ),
                          );
                        },
                        child: BlogCard(
                          username: blog.username!,
                          imageUrl: blog.imageUrl,
                          title: blog.title,
                          content: blog.content,
                          index: index,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return SizedBox.shrink();
        },
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
