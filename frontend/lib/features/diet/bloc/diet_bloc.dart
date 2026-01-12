import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'diet_event.dart';
part 'diet_state.dart';

class DietBloc extends Bloc<DietEvent, DietState> {
  DietBloc() : super(DietInitial()) {
    on<DietEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
