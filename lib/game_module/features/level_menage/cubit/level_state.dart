part of 'level_cubit.dart';
class LevelsMenagmentState extends Equatable{
  final int currentLevel;
  final bool isLevelCompleted;
  final bool isEndGame;
  final bool isPreparedLevel;
  final int howMuchQuestionsBoxLeft;
  final int collectedBox;
  final int finalLevel;
  final bool isPausedGame;

  const LevelsMenagmentState({required this.currentLevel, this.isLevelCompleted = false, this.isEndGame = false,required this.howMuchQuestionsBoxLeft ,required this.collectedBox,this.finalLevel = 4,this.isPreparedLevel = false,this.isPausedGame = false});

  @override
  List<Object> get props => [currentLevel, isLevelCompleted,isEndGame,howMuchQuestionsBoxLeft,collectedBox,finalLevel,isPreparedLevel,isPausedGame];

  LevelsMenagmentState copyWith({int? currentLevel, bool? isLevelCompleted,bool? isEndGame,int? howMuchQuestionsBoxLeft,int? collectedBox,bool? isPreparedLevel,bool? isPausedGame}) {
    return LevelsMenagmentState(
      currentLevel: currentLevel ?? this.currentLevel,
      isLevelCompleted: isLevelCompleted ?? this.isLevelCompleted,
      isEndGame: isEndGame ?? this.isEndGame,
      howMuchQuestionsBoxLeft:howMuchQuestionsBoxLeft ?? this.howMuchQuestionsBoxLeft,
      collectedBox: collectedBox ?? this.collectedBox,
      isPreparedLevel: isPreparedLevel ?? this.isPreparedLevel,
      isPausedGame: isPausedGame ?? this.isPausedGame
    );
  }
}