import 'package:equatable/equatable.dart';
import 'package:renta_control/domain/models/guarantor/guarantor.dart';

abstract class GuarantorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GuarantorInitial extends GuarantorState {}

class GuarantorLoading extends GuarantorState {}

class GuarantorLoaded extends GuarantorState {
  final List<Guarantor> guarantors;

  GuarantorLoaded({required this.guarantors});

  @override
  List<Object> get props => [guarantors];
}

class GuarantorError extends GuarantorState {
  final String message;

  GuarantorError({required this.message});

  @override
  List<Object> get props => [message];
}

class GuarantorUpdated extends GuarantorState {}

class GuarantorAdded extends GuarantorState {}

class GuarantorDeleted extends GuarantorState {
  final List<Guarantor> guarantors;

  GuarantorDeleted({required this.guarantors});

  @override
  List<Object> get props => [guarantors];
}
