import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_ai_gen.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class FlashCardDetailState extends Equatable {
  final LoadStatus loadStatus;
  final LoadStatus loadStatusAiGen;
  final String message;
  final List<FlashCard> flashCards;
  final FlashCardAiGen? flashCardAiGen;

  const FlashCardDetailState({
    required this.loadStatus,
    required this.loadStatusAiGen,
    required this.message,
    required this.flashCards,
    this.flashCardAiGen,
  });

  // initstate
  factory FlashCardDetailState.initial() => const FlashCardDetailState(
        loadStatus: LoadStatus.initial,
        loadStatusAiGen: LoadStatus.initial,
        message: '',
        flashCards: [],
        flashCardAiGen: null,
      );

  // copyWith
  FlashCardDetailState copyWith({
    LoadStatus? loadStatus,
    LoadStatus? loadStatusAiGen,
    String? message,
    List<FlashCard>? flashCards,
    FlashCardAiGen? flashCardAiGen,
  }) =>
      FlashCardDetailState(
        loadStatus: loadStatus ?? this.loadStatus,
        loadStatusAiGen: loadStatusAiGen ?? this.loadStatusAiGen,
        message: message ?? this.message,
        flashCards: flashCards ?? this.flashCards,
        flashCardAiGen: flashCardAiGen ?? this.flashCardAiGen,
      );

  @override
  List<Object?> get props =>
      [loadStatus, flashCards, flashCardAiGen, loadStatusAiGen];
}
