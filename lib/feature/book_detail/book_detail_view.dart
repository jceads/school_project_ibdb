import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import 'package:school_project_ibdb/core/constants/logo_path.dart';
import 'package:school_project_ibdb/core/constants/string_constants.dart';

import '../../product/base_model/book_response_mode.dart';
import 'cubit/bookdetail_cubit.dart';

class BookDetail extends StatelessWidget {
  BookDetail({Key? key, this.bookModel, required this.isComeFromProfile}) : super(key: key);

  Items? bookModel;
  bool isComeFromProfile;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookDetailCubit(bookModel: bookModel),
      child: BlocConsumer<BookDetailCubit, BookDetailState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: appBar(),
            body: body(context),
            floatingActionButton: isComeFromProfile ? null : FAB(context),
          );
        },
      ),
    );
  }

  Column FAB(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        context.read<BookDetailCubit>().isClicked
            ? Padding(
                padding: context.verticalPaddingLow,
                child: FloatingActionButton(
                    heroTag: null,
                    tooltip: "Leave a comment",
                    onPressed: () {
                      context.read<BookDetailCubit>().writeComment("asdasdasdasd");
                    },
                    child: const Icon(
                      Icons.comment_outlined,
                    )),
              )
            : const SizedBox(),
        Padding(
          padding: context.verticalPaddingLow,
          child: FloatingActionButton(
              heroTag: null,
              tooltip: context.read<BookDetailCubit>().isClicked == false ? "More Options" : "Like this book",
              onPressed: () {
                if (context.read<BookDetailCubit>().isClicked) {
                  context.read<BookDetailCubit>().changeClicked();
                } else {
                  context.read<BookDetailCubit>().likeBook();
                  context.read<BookDetailCubit>().changeClicked();
                }
              },
              child: context.read<BookDetailCubit>().isClicked == false
                  ? const Icon(Icons.add)
                  : const Icon(Icons.thumb_up)),
        ),
      ],
    );
  }

  SingleChildScrollView body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: SizedBox(
              height: context.dynamicHeight(0.4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: bookModel?.volumeInfo?.imageLinks?.thumbnail == null
                    ? Container(
                        constraints: BoxConstraints(minHeight: context.dynamicHeight(0.3)),
                        child: Image.asset(LogoPaths.dummyBook),
                      )
                    : Image.network(bookModel?.volumeInfo?.imageLinks?.thumbnail ?? "", fit: BoxFit.contain),
              ),
            ),
          ),
          SizedBox(height: context.dynamicHeight(0.02)),
          Text(bookModel?.volumeInfo?.title ?? StringConstants().notFound),
          Text(bookModel?.volumeInfo?.authors?.first ?? StringConstants().notFound,
              style: Theme.of(context).textTheme.bodyText1),
          Row(
            children: [
              Text(bookModel?.volumeInfo?.ratingsCount?.toString() ?? ""),
              if (bookModel?.volumeInfo?.ratingsCount != null &&
                  bookModel?.volumeInfo?.ratingsCount.toString() != "")
                const Icon(Icons.star)
            ],
          ),
          const Divider(thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text("Page number:"),
                  bookModel?.volumeInfo?.language != null ? Text("Language:") : SizedBox(),
                  bookModel?.volumeInfo?.publishedDate != null ? Text("Publish Date:") : SizedBox(),
                ],
              ),
              Column(
                children: [
                  Text(bookModel?.volumeInfo?.pageCount?.toString() ?? "Unknown"),
                  Text(bookModel?.volumeInfo?.language ?? ""),
                  Text(bookModel?.volumeInfo?.publishedDate ?? "")
                ],
              )
            ],
          ),
          const Divider(),
          Padding(
            padding: context.horizontalPaddingNormal,
            child: Text(bookModel?.volumeInfo?.description?.toString() ?? StringConstants().notFound,
                style: Theme.of(context).textTheme.bodyLarge),
          ),
          context.read<BookDetailCubit>().comments == null
              ? SizedBox(
                  height: context.dynamicHeight(0.8),
                  child: ListView.separated(
                      itemBuilder: (context, index) => ListTile(
                            leading: Image.asset(LogoPaths.dummyPer),
                            // title: Text(
                            //     context.read<BookDetailCubit>().allComments?.comments?[index].commentOwner ??
                            //         "asd"),
                            title: Text(
                              """context
                                            .read<BookDetailCubit>()
                                            .allComments
                                            ?.comments?[index]
                                            ?.commentOwner""",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            subtitle: Text("""context
                                          .read<BookDetailCubit>()
                                          .allComments
                                          ?.comments?[index]
                                          ?.comment"""),
                            trailing: Text(
                              """context
                                            .read<BookDetailCubit>()
                                            .allComments
                                            ?.comments?[index]
                                            ?.commentTime
                                            ?.substring(0, 19)
                                            .replaceAll("T", " ")""",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                      separatorBuilder: (_, index) => const Divider(thickness: 1),
                      itemCount:
                          //  context.read<BookDetailCubit>().allComments?.comments?.length ?? 0
                          2),
                )
              : Column(
                  children: [
                    const Divider(),
                    const Text("There is no comment. Write first comment here"),
                  ],
                )
        ],
      ),
    );
  }

  AppBar appBar() => AppBar(elevation: 0);
}
