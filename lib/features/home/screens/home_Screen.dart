import 'package:bloc_list_view/features/home/bloc/square_bloc.dart';
import 'package:bloc_list_view/features/home/respositories/home_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController scrollController;

  bool isLoading = false;
  SquareBloc squareBloc;
  HomeRepo homeRepo;
  var spinKit;

  @override
  void initState() {
    super.initState();

    homeRepo = HomeRepo();
    scrollController = ScrollController();
    spinKit = SpinKitWave(
      color: Colors.black,
      size: 30.0,
    );
    scrollController.addListener(_pagination);
    squareBloc = SquareBloc(homeRepo);
    squareBloc.add(FetchSquares(1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Paginated View'),
      ),
      body: BlocConsumer<SquareBloc, SquareState>(
        bloc: squareBloc,
        listener: (context, state) {
          if (state.status != SquareStatus.initial) {
            isLoading = false;
          }
        },
        builder: (context, state) {
          if (state.status == SquareStatus.success) {
            return Stack(
              children: [
                Opacity(
                  opacity: isLoading ? 0.3 : 1,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: state?.posts?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Container(
                          child: index >= state?.posts?.length ?? 0
                              ? Center(child: CircularProgressIndicator())
                              : Container(
                                  margin: const EdgeInsets.all(5.0),
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  child: Column(
                                    children: [
                                      Text(
                                        state.posts[index]?.name??'',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.bold),
                                      ),

                                      SizedBox(height: 5,),

                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(state.posts[index]?.description??'',
                                          style: TextStyle(fontSize: 14,color:Colors.grey,fontWeight: FontWeight.normal),


                                        ),
                                      )
                                    ],
                                  )));
                    },
                  ),
                ),
                Visibility(
                    visible: isLoading,
                    child: Center(
                      child: spinKit,
                    ))
              ],
            );
          } else if (state.status == SquareStatus.initial) {
            return Center(child: spinKit);
          } else {
            return Container();
          }
          return spinKit;
        },
      ),
    );
  }

  void _pagination() {
    if ((scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoading)) {
      isLoading = true;
      setState(() {});

      print('calling api -----');
      squareBloc.add(FetchSquares(squareBloc.state.posts.length ~/ 20 + 1));
    }
  }
}
