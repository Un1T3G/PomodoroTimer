import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'theme_switcher_state.dart';

class ThemeSwitcherCubit extends Cubit<ThemeSwitcherState> {
  ThemeSwitcherCubit() : super(ThemeSwitcherInitial());
}
