import 'package:equatable/equatable.dart';

enum TaskVisibility { public, friendsOnly, private }

class Privacy extends Equatable {
  final bool isProfilePrivate; // If true, only friends can see the profile stats
  final TaskVisibility defaultTaskVisibility; // Default setting for new tasks
  final bool allowTagging; // Can others tag you in tasks?

  const Privacy({
    required this.isProfilePrivate,
    required this.defaultTaskVisibility,
    required this.allowTagging,
  });

  factory Privacy.defaults() {
    return const Privacy(
      isProfilePrivate: false,
      defaultTaskVisibility: TaskVisibility.friendsOnly,
      allowTagging: true,
    );
  }

  Privacy copyWith({
    bool? isProfilePrivate,
    TaskVisibility? defaultTaskVisibility,
    bool? allowTagging,
  }) {
    return Privacy(
      isProfilePrivate: isProfilePrivate ?? this.isProfilePrivate,
      defaultTaskVisibility: defaultTaskVisibility ?? this.defaultTaskVisibility,
      allowTagging: allowTagging ?? this.allowTagging,
    );
  }

  @override
  List<Object?> get props => [isProfilePrivate, defaultTaskVisibility, allowTagging];
}