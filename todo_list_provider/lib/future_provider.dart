import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_provider/models/cat_model.dart';

final httpClient = Provider<Dio>((ref) {
  return Dio(BaseOptions(baseUrl: "https://catfact.ninja/"));
});

final catFactsProvider = FutureProvider.autoDispose
    .family<List<CatFactModel>, Map<String, dynamic>>((ref, parametre) async {
  ref.keepAlive();
  final dio = ref.watch(httpClient);
  final result = await dio.get("/facts", queryParameters: parametre);
  List<Map<String, dynamic>> mapData = List.from(result.data["data"]);
  List<CatFactModel> catFactList =
      mapData.map((e) => CatFactModel.fromMap(e)).toList();
  return catFactList;
});

class FutureProviderExample extends ConsumerWidget {
  const FutureProviderExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var list =
        ref.watch(catFactsProvider(const {"limit": 6, "max_length": 30}));
    return Scaffold(
      body: SafeArea(
        child: list.when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index].fact),
                );
              },
            );
          },
          error: (error, stackTrace) {
            return Center(
              child: Text("Error $error"),
            );
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
