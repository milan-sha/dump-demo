import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());
  int count=0;
  void onTapCount(){
    count =count +1 ;
    emit(HomeState(sumData: count));
  }
}
