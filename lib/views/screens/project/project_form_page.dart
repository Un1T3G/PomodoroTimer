import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_timer_task_management/components/popup_modal.dart';
import 'package:pomodoro_timer_task_management/core/values/colors.dart';
import 'package:pomodoro_timer_task_management/core/values/constants.dart';
import 'package:pomodoro_timer_task_management/cubit/project_form_logic/project_form_cubit.dart';
import 'package:pomodoro_timer_task_management/models/project.dart';
import 'package:pomodoro_timer_task_management/views/widgets/action_button.dart';
import 'package:pomodoro_timer_task_management/views/widgets/back_button.dart';
import 'package:pomodoro_timer_task_management/views/widgets/card_title.dart';
import 'package:pomodoro_timer_task_management/views/widgets/page_title.dart';
import 'package:pomodoro_timer_task_management/views/widgets/rouned_card.dart';

class ProjectFormPage extends StatelessWidget {
  const ProjectFormPage({
    Key? key,
    required this.boxName,
    this.project,
  }) : super(key: key);

  final String boxName;
  final Project? project;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectformCubit>(
      create: (context) => ProjectformCubit(
        boxName: boxName,
        project: project,
      ),
      child: CupertinoPageScaffold(
        child: SafeArea(
          child: Stack(
            children: const [
              _Body(),
              _ActionButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: const [
        _Header(),
        _Title(),
        _ProjectNameField(),
        _CardTitle(),
        _ProjectColorPicker(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        BackButton(),
        _DeleteProjectButton(),
      ],
    );
  }
}

class _DeleteProjectButton extends StatelessWidget {
  const _DeleteProjectButton({Key? key}) : super(key: key);

  void _showModal(BuildContext context) {
    openPopupModal(
      context: context,
      title: 'Are you sure delete project?',
      onConiform: context.read<ProjectformCubit>().deleteProject,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = context.read<ProjectformCubit>().state.isEditMode;
    return isEditMode
        ? CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.trash_circle,
              color: kTextColor,
              size: 25,
            ),
            onPressed: () => _showModal(context),
          )
        : const SizedBox();
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProjectformCubit>();

    return PageTitle.withHorizontalMargin(
        title:
            cubit.state.isEditMode ? cubit.state.projectTitle : 'New Project');
  }
}

class _ProjectNameField extends StatelessWidget {
  const _ProjectNameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color =
        context.select((ProjectformCubit cubit) => cubit.state.projectColor);

    return RounedCard.withHorizontalMargin(
      child: CupertinoTextField(
        prefix: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Icon(
            CupertinoIcons.circle_fill,
            color: color,
            size: 20,
          ),
        ),
        padding: EdgeInsets.zero,
        placeholderStyle: const TextStyle(
          fontSize: 18,
          color: kGreyColor,
        ),
        style: const TextStyle(
          fontSize: 18,
          color: kTextColor,
        ),
        placeholder: 'Project name',
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        onChanged: context.read<ProjectformCubit>().changeProjectTitle,
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardTitle.withHorizontalMargin(title: 'Colors');
  }
}

class _ProjectColorPicker extends StatelessWidget {
  const _ProjectColorPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color =
        context.select((ProjectformCubit cubit) => cubit.state.projectColor);

    return RounedCard.withHorizontalMargin(
      child: GridView.count(
        crossAxisCount: 6,
        shrinkWrap: true,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: List.generate(
          projectColors.length,
          (index) => _ColoredCircleButton(
            color: projectColors[index],
            onPick: context.read<ProjectformCubit>().changeProjectColor,
            isSelected: index == projectColors.indexOf(color),
          ),
        ),
      ),
    );
  }
}

class _ColoredCircleButton extends StatelessWidget {
  const _ColoredCircleButton({
    Key? key,
    required this.color,
    required this.onPick,
    required this.isSelected,
  }) : super(key: key);

  final Color color;
  final void Function(Color) onPick;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: isSelected
            ? const Icon(
                CupertinoIcons.checkmark_alt,
                color: kTextColor,
                size: 25,
              )
            : const SizedBox(),
      ),
      onPressed: () => onPick.call(color),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProjectformCubit>();

    return Align(
      alignment: Alignment.bottomCenter,
      child: ActionButton.withChildText(
        onPressed: () {
          cubit.putProject();
          Navigator.of(context).pop();
        },
        title: 'Add Project',
        margin: const EdgeInsets.all(kDefaultMargin),
      ),
    );
  }
}
